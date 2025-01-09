import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/Screens/live_quiz_screen/quiz_manager.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class TimerIndicator extends StatefulWidget {
  final int maxTime;
  final int initialTime;
  final VoidCallback? onTimeExpired;
  final VoidCallback? stopTimerExternally; // Neuer Callback

  const TimerIndicator({
    super.key,
    required this.maxTime,
    this.initialTime = 0,
    this.onTimeExpired,
    this.stopTimerExternally,
  });

  @override
  State<TimerIndicator> createState() => _TimerIndicatorState();
}

class _TimerIndicatorState extends State<TimerIndicator> {

  @override
  Widget build(BuildContext context) {
    double percent = (widget.initialTime / widget.maxTime).clamp(0.0, 1.0);

    return CircularPercentIndicator(
      radius: 30.0,
      lineWidth: 8.0,
      percent: percent,
      animation: false,
      progressColor: QColors.primaryColor,
      backgroundColor: QColors.primaryColor.withOpacity(0.2),
      circularStrokeCap: CircularStrokeCap.round,
      center: QText(
        text: '${widget.initialTime}',
        fontSize: 14,
        color: QColors.white,
      ),
    );
  }
}
