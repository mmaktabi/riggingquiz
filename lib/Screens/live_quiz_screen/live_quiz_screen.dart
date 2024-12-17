import 'package:flutter/material.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/questions_view/question_view.dart';
import 'quiz_manager.dart';

class LiveQuizScreen extends StatefulWidget {
  final QuizCategory quizCategory;

  const LiveQuizScreen({super.key, required this.quizCategory});

  @override
  State<LiveQuizScreen> createState() => _LiveQuizScreenState();
}

class _LiveQuizScreenState extends State<LiveQuizScreen> {
  late QuizManager _quizManager;

  @override
  void initState() {
    super.initState();
    _quizManager = QuizManager(
      widget.quizCategory,
      onTimeExpired: _handleTimeExpired,
      context: context,
    );
  }

  void _handleTimeExpired() {
    setState(() {
      _quizManager.handleTimeExpired(); // Kontext nicht mehr notwendig
    });
  }

  void _onAnswerSelected(int index) {
    setState(() {
      _quizManager.toggleAnswer(index);
    });
  }

  void _onSubmit() {
    setState(() {
      _quizManager.submitAnswer();
    });
  }

  void _nextQuestion() {
    setState(() {
      _quizManager.nextQuestion(); // Kontext nicht mehr notwendig
    });
  }

  @override
  void dispose() {
    _quizManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QLayout(
      child: Column(
        children: [
          QuestionView(
            showNextButton: true,
            question: _quizManager
                .quizCategory.quizzes[_quizManager.currentStepIndex],
            index: _quizManager.currentStepIndex + 1,
            isPressed: _quizManager.isPressed,
            selectedAnswers: _quizManager.selectedAnswers,
            onAnswerSelected: _onAnswerSelected,
            feedback: _quizManager.currentFeedback,
            onNextQuestion: _nextQuestion,
            onSubmit: _onSubmit,
            showSubmitButton: !_quizManager.isPressed,
            maxTime: _quizManager.maxTime,
            timeRemaining: _quizManager.timeRemaining,
            onTimeExpired: _handleTimeExpired, // Hinzugefügt
          ),
        ],
      ),
    );
  }
}
