import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
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
            ? QColors.accentColor
            : isSelected
                ? QColors.errorColor
                : QColors.white)
        : isSelected
            ? QColors.accentColor
            : QColors.white;

    final textColor = isPressed && isCorrect || isSelected
        ? QColors.white
        : QColors.primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: AnimatedButton.strip(
              onPress: () => onAnswerSelected(index),
              text: answer,
              backgroundColor: Colors.white,
              selectedBackgroundColor: tileColor,


              stripColor: QColors.primaryColor,
              animationDuration: Duration(milliseconds: 300),
              stripTransitionType: StripTransitionType.LEFT_TO_RIGHT,
              isReverse: false,

              textStyle: primaryTextStyle(color: textColor),
              selectedTextColor: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
