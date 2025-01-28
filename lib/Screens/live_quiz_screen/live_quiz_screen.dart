import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/Screens/live_quiz_screen/quiz_manager_local.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/questions_view/question_view.dart';

class LiveQuizScreen extends StatefulWidget {
  final QuizCategory quizCategory;

  const LiveQuizScreen({super.key, required this.quizCategory});

  @override
  State<LiveQuizScreen> createState() => _LiveQuizScreenState();
}

class _LiveQuizScreenState extends State<LiveQuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizProvider = Provider.of<QuizProviderLocal>(context, listen: false);
      quizProvider.initializeQuiz(widget.quizCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProviderLocal>(context);

    // Ladezustand überprüfen
    if (quizProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Wenn das Quiz geladen ist, zeige die Fragen an
    return QLayout(
      child: Column(
        children: [
          QuestionView(
            showNextButton: true,
            question: quizProvider.quizCategory.quizzes[quizProvider.currentStepIndex],
            index: quizProvider.currentStepIndex + 1,
            isPressed: quizProvider.isPressed,
            selectedAnswers: quizProvider.selectedAnswers,
            onAnswerSelected: (index) {
              quizProvider.toggleAnswer(index);
            },
            feedback: quizProvider.currentFeedback,
            onNextQuestion: () {
              quizProvider.nextQuestion(context);
            },
            onSubmit: () {
              quizProvider.submitAnswer();
            },
            showSubmitButton: !quizProvider.isPressed,
            maxTime: quizProvider.maxTime,
            timeRemaining: quizProvider.timeRemaining,
            onTimeExpired: () {
              quizProvider.handleTimeExpired();
            },
          ),
        ],
      ),
    );
  }
}
