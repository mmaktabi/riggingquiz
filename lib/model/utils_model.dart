// Enum für den Fragetyp
import 'package:flutter/material.dart';

enum QuestionType { single, multiple }

class QuestionModel {
  String? question;
  Map<String, bool>? answers; // Umbenennung für mehr Klarheit
  int points;
  QuestionType questionType;

  QuestionModel(this.question, this.answers, this.points, this.questionType);
}

class ResultModel {
  int totalPoints;
  int correctAnswers;
  int wrongAnswers;

  ResultModel({
    required this.totalPoints,
    required this.correctAnswers,
    required this.wrongAnswers,
  });
}

// Result Screen
class ResultScreen extends StatelessWidget {
  final ResultModel result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total Points: ${result.totalPoints}'),
            Text('Correct Answers: ${result.correctAnswers}'),
            Text('Wrong Answers: ${result.wrongAnswers}'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

// Neue Klasse für die Überprüfung von Antworten
class AnswerChecker {
  static List<int> checkAnswer({
    required int index,
    required QuestionModel question,
    required List<int> selectedAnswers,
    required bool isPressed,
  }) {
    if (question.questionType == QuestionType.single) {
      return [index]; // Setze die ausgewählte Antwort für Single Choice
    } else {
      // Für Multiple Choice
      if (selectedAnswers.contains(index)) {
        selectedAnswers
            .remove(index); // Antwort abwählen, wenn sie bereits ausgewählt ist
      } else {
        selectedAnswers.add(index); // Antwort hinzufügen
      }
      return selectedAnswers; // Rückgabe der ausgewählten Antworten
    }
  }

  static bool checkAllCorrect({
    required List<int> selectedAnswers,
    required QuestionModel question,
  }) {
    return selectedAnswers.every((answer) =>
        question.answers![question.answers!.keys.elementAt(answer)] == true);
  }
}
