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
    this.textColor = QColors.primaryColor,
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

class _QButtonState extends State<QButton> with TickerProviderStateMixin {
  bool _isHovered = false;
  double _scale = 1.0;
  late AnimationController _controller;
  late AnimationController _scaleController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: widget.backgroundColor,
      end: widget.backgroundColor.withOpacity(0.8),
    ).animate(_controller);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.onPressed?.call();
  }

  void _onHoverEnter(bool hover) {
    setState(() => _isHovered = hover);
  }

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
          onEnter: (_) => _onHoverEnter(true),
          onExit: (_) => _onHoverEnter(false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: () => _scaleController.reverse(),
            child: AnimatedBuilder(
              animation: Listenable.merge([_controller, _scaleController]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: widget.backgroundGradient ??
                          LinearGradient(
                              colors: [
                                QColors.primaryColor1,
                                QColors.primaryColor1
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0, 1]),
                      borderRadius: BorderRadius.circular(widget.radius),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: widget.backgroundColor.withOpacity(0.5),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ]
                          : [],
                    ),
                    child: AnimatedSwitcher(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                );
              },
            ),
          ),
        ),
      );
    }
  }
}
