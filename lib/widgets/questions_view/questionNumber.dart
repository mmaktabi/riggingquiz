import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class QuestionNumber extends StatelessWidget {
  final int number;

  const QuestionNumber({
    super.key,
    required this.number,
  });
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TagPainter(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: QText(text:
          '#${number}',
          color: QColors.primaryColor,
          fontSize: 20,
        ),
      ),

    );
  }
}

class TagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = QColors.backgroundColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0); // Start at the top-left corner
    path.lineTo(size.width - 10, 0); // Top-right corner (leave space for the triangle)
    path.lineTo(size.width, size.height / 2); // Right peak
    path.lineTo(size.width - 10, size.height); // Bottom-right corner
    path.lineTo(0, size.height); // Bottom-left corner
    path.close(); // Close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

