import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rigging_quiz/Screens/friends/duel_result_screen.dart';
import 'package:rigging_quiz/Screens/friends/game_service.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/questions_view/question_view.dart';

class DuelGameScreen extends StatefulWidget {
  final String gameId;
  final String playerUid;

  const DuelGameScreen({
    super.key,
    required this.gameId,
    required this.playerUid,
  });

  @override
  _DuelGameScreenState createState() => _DuelGameScreenState();
}

class _DuelGameScreenState extends State<DuelGameScreen> {
  final GameService _gameService = GameService();
  Quiz? currentQuestion;
  bool isLoading = true;
  bool isPressed = false;
  String feedback = '';
  List<int> selectedAnswers = [];
  bool showSubmitButton = true;

  int currentQuestionIndex = 0;
  int timeRemaining = 20;
  Timer? _timer;
  final int maxTime = 20;

  StreamSubscription<DatabaseEvent>? _questionIndexListener;

  @override
  void initState() {
    super.initState();
    listenToQuestionIndex();
    loadCurrentQuestion();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _questionIndexListener?.cancel();
    super.dispose();
  }

  /// Hört Änderungen des `currentQuestionIndex` in Echtzeit
  void listenToQuestionIndex() {
    final playerRef = _gameService.getGameSessionsRef().child(
        '${widget.gameId}/players/${widget.playerUid}/currentQuestionIndex');

    _questionIndexListener = playerRef.onValue.listen((event) {
      final newIndex = event.snapshot.value as int? ?? 0;
      if (newIndex != currentQuestionIndex) {
        setState(() {
          currentQuestionIndex = newIndex;
        });
      }
    });
  }

  Future<void> loadCurrentQuestion() async {
    try {
      setState(() {
        isLoading = true;
        isPressed = false;
        selectedAnswers = [];
        feedback = '';
        showSubmitButton = true;
        timeRemaining = maxTime;
      });

      // Lade die aktuelle Frage und den Index
      final result = await _gameService.getCurrentQuestion(
        widget.gameId,
        widget.playerUid,
      );

      if (result == null) {
        // Keine weiteren Fragen, navigiere zum Ergebnisbildschirm
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DuelResultScreen(
              gameId: widget.gameId,
              playerUid: widget.playerUid,
            ),
          ),
        );
        return;
      }

      // Aktualisiere die aktuelle Frage
      setState(() {
        currentQuestion = result['question'] as Quiz;
        currentQuestionIndex = result['currentQuestionIndex'] as int;
      });

      startTimer();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Frage: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void startTimer() {
    _timer?.cancel(); // Vorherigen Timer abbrechen, falls vorhanden

    // Timer starten
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining <= 1) {
        timer.cancel();
        _handleTimeExpired();
      } else {
        setState(() {
          timeRemaining--;
        });
      }
    });
  }

  void _handleTimeExpired() {
    setState(() {
      isPressed = true;
      feedback = "Zeit abgelaufen!";
      showSubmitButton = false;
    });
    _timer?.cancel();
    _gameService.submitAnswer(widget.gameId, widget.playerUid, false);
    Future.delayed(const Duration(seconds: 1), loadCurrentQuestion);
  }

  void _toggleAnswer(int index) {
    if (isPressed) return;

    setState(() {
      if (selectedAnswers.contains(index)) {
        selectedAnswers.remove(index);
      } else {
        selectedAnswers.add(index);
      }
    });
  }

  void _submitAnswer() {
    if (isPressed || selectedAnswers.isEmpty) return;

    final correctIndices = currentQuestion?.multiSelect
        ?.asMap()
        .entries
        .where((entry) => entry.value['value'] == true)
        .map((entry) => entry.key)
        .toList();

    final allCorrectSelected = correctIndices != null &&
        correctIndices.every((index) => selectedAnswers.contains(index)) &&
        selectedAnswers.length == correctIndices.length;

    final anyIncorrectSelected = selectedAnswers.any(
      (index) => !(correctIndices?.contains(index) ?? false),
    );

    final isCorrect = allCorrectSelected && !anyIncorrectSelected;

    setState(() {
      isPressed = true;
      feedback =
          isCorrect ? "Yess! Das war richtig!" : "Oh nein! Das war falsch.";
      showSubmitButton = false;
    });

    _timer?.cancel();

    // Antwort übermitteln
    _gameService.submitAnswer(widget.gameId, widget.playerUid, isCorrect);

    // Nächste Frage nach einer kurzen Verzögerung laden
    Future.delayed(const Duration(seconds: 1), loadCurrentQuestion);
  }

  void _nextQuestion() {
    loadCurrentQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return QLayout(
      child: isLoading
          ? QWidgets().progressIndicator
          : currentQuestion != null
              ? QuestionView(
                  showNextButton: false,
                  question: currentQuestion!,
                  index: currentQuestionIndex + 1,
                  isPressed: isPressed,
                  selectedAnswers: selectedAnswers,
                  onAnswerSelected: _toggleAnswer,
                  feedback: feedback,
                  onNextQuestion: _nextQuestion,
                  onSubmit: _submitAnswer,
                  showSubmitButton: showSubmitButton,
                  maxTime: maxTime,
                  timeRemaining: timeRemaining,
                )
              : const Center(child: Text('Keine weiteren Fragen.')),
    );
  }
}
