import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/Screens/live_quiz_screen/review_quiz_screen.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/score_service.dart';

class QuizManager {
  final QuizCategory quizCategory;
  final BuildContext context; // Hinzugefügt
  int currentStepIndex = 0;
  int totalPoints = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  List<int> selectedAnswers = [];
  List<List<int>> selectedAnswersPerQuestion = [];
  bool isPressed = false;
  String currentFeedback = "";
  int timeRemaining = 20;
  final int maxTime = 20; // Hinzugefügt
  Timer? _timer;
  final Function onTimeExpired;

  QuizManager(
    this.quizCategory, {
    required this.onTimeExpired,
    required this.context, // Hinzugefügt
  }) {
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    timeRemaining = maxTime; // Hinzugefügt
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining <= 0) {
        timer.cancel();
        onTimeExpired();
      } else {
        timeRemaining--;
      }
    });
  }

  void resetTimer() {
    timeRemaining = maxTime; // Geändert
    startTimer();
  }

  void toggleAnswer(int index) {
    if (isPressed) return;

    if (selectedAnswers.contains(index)) {
      selectedAnswers.remove(index);
    } else {
      selectedAnswers.add(index);
    }
  }

  void submitAnswer() {
    if (isPressed || selectedAnswers.isEmpty) return;

    final currentQuestion = quizCategory.quizzes[currentStepIndex];
    final correctIndices = currentQuestion.multiSelect
        ?.asMap()
        .entries
        .where((entry) => entry.value['value'] == true)
        .map((entry) => entry.key)
        .toList();

    final allCorrectSelected = correctIndices != null &&
        correctIndices.every((index) => selectedAnswers.contains(index)) &&
        selectedAnswers.length == correctIndices.length;

    final anyIncorrectSelected = selectedAnswers
        .any((index) => !(correctIndices?.contains(index) ?? false));

    final isCorrect = allCorrectSelected && !anyIncorrectSelected;

    if (isCorrect) {
      timeRemaining = 0;
      totalPoints += currentQuestion.score;
      correctAnswers++;
      currentFeedback = "Yess! Das war richtig!";
    } else {
      wrongAnswers++;
      currentFeedback = "Oh nein! Das war falsch.";
    }

    isPressed = true;
    _timer?.cancel();
  }

  void handleTimeExpired() {
    wrongAnswers++;
    currentFeedback = "Zeit abgelaufen!";
    isPressed = true;
  }

  void nextQuestion() {
    if (!isPressed) return;

    selectedAnswersPerQuestion.add(List.from(selectedAnswers));
    selectedAnswers = [];
    isPressed = false;
    currentFeedback = "";

    if (currentStepIndex + 1 < quizCategory.quizzes.length) {
      currentStepIndex++;
      resetTimer();
    } else {
      _endQuiz();
    }
  }

  void _endQuiz() {
    _timer?.cancel(); // Timer stoppen
    selectedAnswersPerQuestion.add(List.from(selectedAnswers));
    int schaekel = correctAnswers == 7 ? 8 : correctAnswers;
    ScoreService scoreService = ScoreService();
    final userService = Provider.of<UserService>(context, listen: false);

    scoreService.updateScore(userService.uid ?? "", schaekel);
    scoreService.updateHistory(
        userService.uid ?? "", schaekel, quizCategory.name);

    final result = ResultModel(
      totalPoints: totalPoints,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      schaekel: totalPoints,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewQuizScreen(
          result: result,
          questions: quizCategory.quizzes,
          selectedAnswersPerQuestion: selectedAnswersPerQuestion,
        ),
      ),
    );
  }

  void dispose() {
    _timer?.cancel();
  }
}
