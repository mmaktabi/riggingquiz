import 'package:flutter/material.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/questions_view/matchingquestionwidget.dart';
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          _buildQuestionHeader(),
          const SizedBox(height: 16),
          _buildTimer(),
          const SizedBox(height: 16),
          _buildAnswerOptions(),
          if (widget.isPressed) _buildFeedbackAndNextButton(),
          if (widget.showSubmitButton && !widget.isPressed)
            _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildQuestionHeader() {
    return Column(
      children: [
        QText(
          text: 'Frage: ${widget.index}',
          color: QColors.accentColor,
          weight: FontWeight.w500,
          fontSize: 14,
          textAlign: TextAlign.center,
        ),
        QText(
          text: widget.question.question,
          color: QColors.white,
          weight: FontWeight.w500,
          fontSize: 20,
          textAlign: TextAlign.center,
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

        return _buildAnswerTile(answer, isCorrect, isSelected, index);
      },
    );
  }

  Widget _buildAnswerTile(
      String answer, bool isCorrect, bool isSelected, int index) {
    final tileColor = widget.isPressed
        ? (isCorrect
            ? QColors.accentColor
            : isSelected
                ? QColors.errorColor
                : QColors.white)
        : isSelected
            ? QColors.accentColor
            : QColors.white;

    final textColor = widget.isPressed && isCorrect || isSelected
        ? QColors.white
        : QColors.primaryColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child:  GestureDetector(
        onTap: () => widget.onAnswerSelected(index),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: QText(
              text: answer,
              color: textColor,
            ),
          ),
        ),
      ),
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
