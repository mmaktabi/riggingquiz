import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';

class CustomIcon extends StatelessWidget {
  final bool? canSelect;
  final double? size;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? bgColor;
  final IconData? icon;

  const CustomIcon(
      {super.key,
      this.canSelect,
      this.size,
      this.padding,
      this.radius = 0,
      this.onTap,
      this.color = ColorsHelpers.primaryColor,
      this.bgColor = ColorsHelpers.transparent,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.all(Radius.circular(radius))),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(0),
          child: Icon(
            icon ?? Icons.question_mark,
            color: color,
            size: size ?? 28.0,
          ),
        ),
      ),
    );
  }
}
