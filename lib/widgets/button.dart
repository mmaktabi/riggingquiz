import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class QButton extends StatefulWidget {
  final void Function()? onPressed;
  final String buttonText;
  final bool isLoading;
  final bool textButton;
  final Color textColor;
  final Gradient? backgroundGradient;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final double fontSize;
  final FontWeight? weight;
  final IconData? icon;

  const QButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isLoading = false,
    this.textButton = false,
    this.textColor = QColors.white,
    this.backgroundGradient,
    this.backgroundColor = QColors.primaryColor,
    this.radius = 13,
    this.fontSize = 15,
    this.padding,
    this.icon,
    this.weight = FontWeight.w400,
    this.margin,
  });

  @override
  State<QButton> createState() => _QButtonState();
}

class _QButtonState extends State<QButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.textButton) {
      return Padding(
        padding: widget.margin ??
            const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: TextButton(
          onPressed: widget.onPressed,
          child: Padding(
            padding: widget.padding ??
                const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
            child: QText(
              text: widget.buttonText,
              color: widget.textColor,
              weight: widget.weight,
              fontSize: widget.fontSize,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: widget.margin ?? const EdgeInsets.all(8),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (!widget.isLoading) widget.onPressed?.call();
            },
            child: AnimatedScale(
              scale: _isHovered ? 1.015 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  gradient: widget.backgroundGradient ??
                      LinearGradient(
                        colors: [
                          widget.backgroundColor,
                          widget.backgroundColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                  borderRadius: BorderRadius.circular(widget.radius),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: QColors.primaryColor.withOpacity(0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : [],
                ),
                child: AnimatedSwitcher(
                  key: GlobalKey(),
                  duration: const Duration(milliseconds: 300),
                  child: widget.isLoading
                      ? const SizedBox(
                          key: ValueKey<int>(2),
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                QColors.accentColor),
                          ),
                        )
                      : Padding(
                          padding: widget.padding ??
                              const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                          child: widget.icon != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Icon(
                                        widget.icon,
                                        color: widget.textColor,
                                      ),
                                    ),
                                    QText(
                                      text: widget.buttonText,
                                      color: widget.textColor,
                                      fontSize: widget.fontSize,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              : QText(
                                  text: widget.buttonText,
                                  color: widget.textColor,
                                  fontSize: widget.fontSize,
                                  textAlign: TextAlign.center,
                                ),
                        ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
