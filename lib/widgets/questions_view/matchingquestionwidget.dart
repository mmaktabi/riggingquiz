import 'package:flutter/material.dart';
import 'package:flutter_quiz_matcher/flutter_quiz_matcher.dart';
import 'package:flutter_quiz_matcher/models/model.dart';

class MatchingQuestionWidget extends StatefulWidget {
  final List<Map<String, String>> matchingPairs;

  const MatchingQuestionWidget({super.key, required this.matchingPairs});

  @override
  _MatchingQuestionWidgetState createState() => _MatchingQuestionWidgetState();
}

class _MatchingQuestionWidgetState extends State<MatchingQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final questions = widget.matchingPairs.map((pair) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            width: constraints.maxWidth * 0.4, // Breite anpassen
            height: 100,
            child: Center(
              child: Text(
                pair['leftText'] ?? '',
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList();

        final answers = widget.matchingPairs.map((pair) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            width: constraints.maxWidth * 0.4, // Breite anpassen
            height: 100,
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                pair['rightText'] ?? '',
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList();

        return SizedBox(
          height: 1000,
          child: QuizMatcher(
            questions: questions,
            answers: answers,
            defaultLineColor: Colors.black,
            correctLineColor: Colors.green,
            incorrectLineColor: Colors.red,
            drawingLineColor: Colors.blue,
            onScoreUpdated: (UserScore userAnswers) {
              // Logik zur Aktualisierung des Punktestands oder für andere Aktionen
              print(
                  "Frage ${userAnswers.questionIndex} Antwort: ${userAnswers.questionAnswer}");
            },
            paddingAround: const EdgeInsets.all(8),
          ),
        );
      },
    );
  }
}
