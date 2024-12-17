import 'package:flutter/material.dart';
import 'package:rigging_quiz/Screens/live_quiz_screen/review_quiz_screen.dart';
import 'package:rigging_quiz/model/quiz_model.dart';

class TestData {
  // Test ResultModel
  static ResultModel testResult = ResultModel(
    totalPoints: 45,
    correctAnswers: 7,
    schaekel: 8,
    wrongAnswers: 0,
  );

  // Test Quiz Questions
  static List<Quiz> testQuestions = [
    Quiz(
      question: "What is the safe working load of this shackle?",
      hint: "Check the manufacturer specifications.",
      questionType: QuizQuestionType.multipleChoice,
      difficulty: QuizDifficulty.medium,
      multiSelect: [
        {"label": "500 kg", "value": false},
        {"label": "1000 kg", "value": true},
        {"label": "2000 kg", "value": false},
        {"label": "3000 kg", "value": false},
      ],
    ),
    Quiz(
      question: "Identify the correct knot for securing equipment.",
      hint: "Use the most common one for this purpose.",
      questionType: QuizQuestionType.multipleChoice,
      difficulty: QuizDifficulty.beginner,
      multiSelect: [
        {"label": "Bowline", "value": true},
        {"label": "Square knot", "value": false},
        {"label": "Clove hitch", "value": false},
        {"label": "Sheet bend", "value": false},
      ],
    ),
    Quiz(
      question: "Match the parts of a truss system.",
      hint: "Left side corresponds to the right side.",
      questionType: QuizQuestionType.matching,
      difficulty: QuizDifficulty.advanced,
      matchingPairs: [
        {"left": "Base plate", "right": "Support"},
        {"left": "Truss", "right": "Span"},
      ],
    ),
  ];

  // Test selected answers per question
  static List<List<int>> selectedAnswersPerQuestion = [
    [1], // User selected "1000 kg" for the first question
    [0], // User selected "Bowline" for the second question
    [0] // User correctly matched the first pair
  ];
}

// Beispiel, wie du die Testdaten in der ReviewQuizScreen verwenden kannst
class TestReviewQuizScreen extends StatelessWidget {
  const TestReviewQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReviewQuizScreen(
      result: TestData.testResult,
      questions: TestData.testQuestions,
      selectedAnswersPerQuestion: TestData.selectedAnswersPerQuestion,
    );
  }
}
