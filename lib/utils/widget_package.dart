import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';

class QWidgets {
  final Widget progressIndicator = const Center(
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: CircularProgressIndicator(
        color: QColors.primaryColor,
        strokeWidth: 0.5,
      ),
    ),
  );
}
