import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class TimerIndicator extends StatefulWidget {
  final int maxTime; // Maximale Zeit in Sekunden
  final int initialTime; // Anfangszeit in Sekunden
  final VoidCallback? onTimeExpired;

  const TimerIndicator({
    super.key,
    required this.maxTime,
    this.initialTime = 0,
    this.onTimeExpired,
  });

  @override
  _TimerIndicatorState createState() => _TimerIndicatorState();
}

class _TimerIndicatorState extends State<TimerIndicator>
    with SingleTickerProviderStateMixin {
  late int _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = widget.initialTime;

    // Timer starten
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant TimerIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Timer und Fortschritt nur neu starten, wenn MaxTime oder InitialTime sich ändern
    if (widget.maxTime != oldWidget.maxTime ||
        widget.initialTime != oldWidget.initialTime) {
      _currentTime = widget.initialTime;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel(); // Bestehenden Timer abbrechen
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_currentTime < widget.maxTime) {
        setState(() {
          _currentTime++;
        });
      } else {
        _timer?.cancel();
        widget.onTimeExpired?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double percent = (_currentTime / widget.maxTime).clamp(0.0, 1.0);

    return SizedBox(
      height: 60, // Kleinere Größe
      width: 60, // Kleinere Größe
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 8.0,
            percent: percent,
            animation: false, // Animation deaktivieren, da Prozentwert stetig
            progressColor: QColors.primaryColor,
            backgroundColor: QColors.primaryColor.withOpacity(0.2),
            circularStrokeCap: CircularStrokeCap.round,
            center: QText(
              text: '${widget.maxTime - _currentTime}',
              fontSize: 14,
              color: QColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
