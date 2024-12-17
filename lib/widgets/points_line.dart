import 'package:flutter/material.dart';

import 'package:rigging_quiz/utils/constant.dart';

class PointsLine extends StatefulWidget {
  final int punkte;
  final int schaekel;
  final int maximalPunkte;

  const PointsLine({
    super.key,
    required this.punkte,
    required this.schaekel,
    required this.maximalPunkte,
  });

  @override
  _PunkteStreifenState createState() => _PunkteStreifenState();
}

class _PunkteStreifenState extends State<PointsLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(
            begin: 0.0,
            end: ((widget.punkte * 10) / widget.maximalPunkte).clamp(0.0, 1.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Fortschrittsstreifen
        Expanded(
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: QColors.secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Stack(
                  children: [
                    FractionallySizedBox(
                      heightFactor: 1,
                      widthFactor: _animation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: QColors.primaryColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double availableWidth = constraints.maxWidth;
                            int pointsToShow = widget
                                .schaekel; //(widget.punkte ~/ 10).clamp(0, widget.punkte ~/ 10);

                            if (pointsToShow > 1) {
                              double spacing =
                                  availableWidth / (pointsToShow + 1);
                              return Stack(
                                children: List.generate(pointsToShow, (index) {
                                  return Positioned(
                                    left: (index + 1) * spacing -
                                        16, // Verschiebung angepasst
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: Image.asset(
                                        QImages.schaekel,
                                        height: 33,
                                      ),
                                    ),
                                  );
                                }),
                              );
                            } else if (pointsToShow == 1) {
                              return Center(
                                child: Image.asset(
                                  QImages.schaekel,
                                  height: 33,
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
