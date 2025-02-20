import 'package:flutter/material.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/questions_view/Answer_tile.dart';
import 'package:rigging_quiz/widgets/questions_view/matchingquestionwidget.dart';
import 'package:rigging_quiz/widgets/questions_view/questionNumber.dart';
import 'package:rigging_quiz/widgets/questions_view/timer_indicator.dart';

class QuestionView extends StatefulWidget {
  final Quiz question;
  final bool isPressed;
  final List<int> selectedAnswers;
  final void Function(int) onAnswerSelected;
  final String feedback;
  final int index;
  final void Function() onNextQuestion;
  final VoidCallback onSubmit;
  final bool showSubmitButton;
  final bool showNextButton;
  final int maxTime;
  final int timeRemaining;
  final void Function()? onTimeExpired;

  const QuestionView({
    super.key,
    required this.question,
    required this.isPressed,
    required this.selectedAnswers,
    required this.onAnswerSelected,
    required this.feedback,
    required this.onNextQuestion,
    required this.index,
    required this.onSubmit,
    required this.showSubmitButton,
    required this.showNextButton,
    required this.maxTime,
    required this.timeRemaining,
    this.onTimeExpired,
  });

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.of(context).size.width;

    double imgSize;
    if (width > 600) {
      imgSize =  height/6;
    } else {

      imgSize = height/5;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: QuestionNumber(
                number: widget.index,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Image.asset(
                    "assets/app_logo.png",
                    height: imgSize,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.exit_to_app_rounded,
                    size: 30, color: QColors.primaryColor),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
        _buildQuestionHeader(),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildTimer(),
              const SizedBox(height: 16),
              _buildAnswerOptions(),
              if (widget.isPressed) _buildFeedbackAndNextButton(),
              if (widget.showSubmitButton && !widget.isPressed)
                _buildSubmitButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: QText(
            text: widget.question.question,
            color: QColors.white,
            weight: FontWeight.w500,
            fontSize: 20,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTimer() {
    return TimerIndicator(
      maxTime: widget.maxTime,
      initialTime: widget.timeRemaining,
    );
  }

  Widget _buildAnswerOptions() {
    switch (widget.question.questionType) {
      case QuizQuestionType.multipleChoice:
        return _buildMultipleChoiceOptions();
      case QuizQuestionType.matching:
        return MatchingQuestionWidget(
          matchingPairs: widget.question.matchingPairs ?? [],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMultipleChoiceOptions() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: widget.question.multiSelect?.length ?? 0,
      itemBuilder: (context, index) {
        final answer = widget.question.multiSelect?[index]['label'] ?? '';
        final isCorrect = widget.question.multiSelect?[index]['value'] as bool;
        final isSelected = widget.selectedAnswers.contains(index);

        return AnswerTile(
          isPressed: widget.isPressed,
          onAnswerSelected: (index) {
            widget.onAnswerSelected(index); // Zustand aktualisieren
          },
          answer: answer,
          isCorrect: isCorrect,
          isSelected: isSelected,
          index: index,
        );

      },
    );
  }


  Widget _buildFeedbackAndNextButton() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: QText(
            text: widget.feedback,
            fontSize: 16,
            weight: FontWeight.bold,
            color: widget.feedback.contains("richtig")
                ? QColors.accentColor
                : QColors.errorColor,
          ),
        ),
        if (widget.showNextButton)
          QButton(
            buttonText: 'Nächste Frage',
            onPressed: widget.onNextQuestion,
          ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return QButton(
      buttonText: 'Antwort abgeben',
      onPressed: widget.selectedAnswers.isNotEmpty ? widget.onSubmit : null,
    );
  }
}
