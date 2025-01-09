import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/Screens/live_quiz_screen/review_quiz_screen.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/score_service.dart';

class QuizProvider with ChangeNotifier {
  late QuizCategory _quizCategory;
  int _currentStepIndex = 0;
  int _totalPoints = 0;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  List<int> _selectedAnswers = [];
  List<List<int>> _selectedAnswersPerQuestion = [];
  bool _isPressed = false;
  String _currentFeedback = "";
  int _timeRemaining = 20;
  final int _maxTime = 20;
  Timer? _timer;
  bool _isLoading = true;

  // Getter für den Ladezustand
  bool get isLoading => _isLoading;

  void initializeQuiz(QuizCategory quizCategory) {
    _quizCategory = quizCategory;
    resetState();
    _isLoading = false; // Laden abgeschlossen
    startTimer(() {
      handleTimeExpired();
    });
    notifyListeners();
  }


  void resetState() {
    _currentStepIndex = 0;
    _totalPoints = 0;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    _selectedAnswers = [];
    _selectedAnswersPerQuestion = [];
    _isPressed = false;
    _currentFeedback = "";
    _timeRemaining = _maxTime;
    _isLoading = true; // Ladezustand aktivieren

    notifyListeners();
  }

  // Getters
  QuizCategory get quizCategory => _quizCategory;
  int get currentStepIndex => _currentStepIndex;
  int get totalPoints => _totalPoints;
  int get correctAnswers => _correctAnswers;
  int get wrongAnswers => _wrongAnswers;
  List<int> get selectedAnswers => _selectedAnswers;
  bool get isPressed => _isPressed;
  String get currentFeedback => _currentFeedback;
  int get timeRemaining => _timeRemaining;
  int get maxTime => _maxTime;

  // Timer-Methoden
  void startTimer(Function onTimeExpired) {
    _timer?.cancel();
    _timeRemaining = _maxTime;
    print('Starting timer with $_timeRemaining seconds');
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining <= 0) {
        timer.cancel();
        onTimeExpired();
      } else {
        _timeRemaining--;
        notifyListeners();
      }
    });
  }

  void resetTimer() {
    _timeRemaining = _maxTime;
    startTimer(() {
      handleTimeExpired();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void handleTimeExpired() {
    _wrongAnswers++;
    _currentFeedback = "Zeit abgelaufen!";
    _isPressed = true;
    stopTimer();
    notifyListeners();
  }

  // Quiz-Methoden
  void toggleAnswer(int index) {
    if (_isPressed) return;

    if (_selectedAnswers.contains(index)) {
      _selectedAnswers.remove(index);
    } else {
      _selectedAnswers.add(index);
    }
    notifyListeners();
  }

  void submitAnswer() {
    if (_isPressed || _selectedAnswers.isEmpty) return;

    final currentQuestion = _quizCategory.quizzes[_currentStepIndex];
    final correctIndices = currentQuestion.multiSelect
        ?.asMap()
        .entries
        .where((entry) => entry.value['value'] == true)
        .map((entry) => entry.key)
        .toList();

    final allCorrectSelected = correctIndices != null &&
        correctIndices.every((index) => _selectedAnswers.contains(index)) &&
        _selectedAnswers.length == correctIndices.length;

    final anyIncorrectSelected = _selectedAnswers
        .any((index) => !(correctIndices?.contains(index) ?? false));

    final isCorrect = allCorrectSelected && !anyIncorrectSelected;

    if (isCorrect) {
      _totalPoints += currentQuestion.score;
      _correctAnswers++;
      _currentFeedback = "Yess! Das war richtig!";
    } else {
      _wrongAnswers++;
      _currentFeedback = "Oh nein! Das war falsch.";
    }

    _isPressed = true;
    stopTimer();
    notifyListeners();
  }

  void nextQuestion(BuildContext context) {
    if (!_isPressed) return;

    _selectedAnswersPerQuestion.add(List.from(_selectedAnswers));
    _selectedAnswers = [];
    _isPressed = false;
    _currentFeedback = "";

    if (_currentStepIndex + 1 < _quizCategory.quizzes.length) {
      _currentStepIndex++;
      resetTimer();
    } else {
      endQuiz(context); // Endquiz aufrufen
    }
    notifyListeners();
  }


  void endQuiz(BuildContext context) {
    stopTimer(); // Sicherstellen, dass der Timer gestoppt wird
    _selectedAnswersPerQuestion.add(List.from(_selectedAnswers));

    // Berechnung der Schäkels (Punkte)
    int schaekel = _correctAnswers == 7 ? 8 : _correctAnswers;

    // Ergebnisse in den Score-Service speichern
    ScoreService scoreService = ScoreService();
    final userService = Provider.of<UserService>(context, listen: false);

    scoreService.updateScore(userService.uid ?? "", schaekel);
    scoreService.updateHistory(userService.uid ?? "", schaekel, _quizCategory.name);

    // Result-Objekt erstellen
    final result = ResultModel(
      totalPoints: _totalPoints,
      correctAnswers: _correctAnswers,
      wrongAnswers: _wrongAnswers,
      schaekel: schaekel,
    );

    // Navigation zur Review-Seite
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewQuizScreen(
          result: result,
          questions: _quizCategory.quizzes,
          selectedAnswersPerQuestion: _selectedAnswersPerQuestion,
        ),
      ),
    );
  }

}
