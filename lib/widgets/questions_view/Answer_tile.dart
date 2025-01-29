import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
class AnswerTile extends StatelessWidget {
  final String answer;
  final bool isCorrect;
  final bool isSelected;
  final bool isPressed;
  final int index;
  final Function(int) onAnswerSelected;

  const AnswerTile({
    required this.answer,
    required this.isCorrect,
    required this.isSelected,
    required this.isPressed,
    required this.index,
    required this.onAnswerSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tileColor = isPressed
        ? (isCorrect
        ? QColors.primaryColor1
        : isSelected
        ? QColors.errorColor
        : QColors.white)
        : isSelected
        ? QColors.primaryColor1
        : QColors.white;


    final textColor = isPressed
        ? (isCorrect
        ? QColors.primaryColor
        : isSelected
        ? QColors.white
        : QColors.primaryColor)
        : isSelected
        ? QColors.primaryColor
        : QColors.primaryColor;




    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onAnswerSelected(index),
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
}
