import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';

class QText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final Color color;
  final double fontSize;
  final double? letterSpacing;
  final FontWeight? weight;

  const QText(
      {super.key,
      required this.text,
      this.style,
      this.color = ColorsHelpers.text,
      this.fontSize = 14,
      this.letterSpacing,
      this.weight = FontWeight.w400,
      this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    TextScaler textScaler = MediaQuery.textScalerOf(context);

    return Text(
      text,
      textAlign: textAlign,
      style: style ??
          primaryTextStyle(
              letterSpacing: letterSpacing,
              fontSize: fontSize,
              weight: weight,
              color: color),
      textScaler: textScaler,
    );
  }
}

TextStyle primaryTextStyle({
  bool bold = false,
  double fontSize = 14.0,
  double? letterSpacing,
  color = QColors.accentColor,
  bool center = false,
  FontWeight? weight = FontWeight.w400,
}) {
  return TextStyle(
      color: color,
      fontFamily: 'Epilogue',
      decoration: TextDecoration.none,
      fontWeight: weight,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      height: 1.3);
}
