import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/images.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rigging_quiz/widgets/score/score_header.dart';

/// Diese Klasse enthält das Layout mit `Scaffold` und einer verbesserten Scroll-Implementierung
class QLayout extends StatefulWidget {
  final Widget child;
  final bool backButton;
  final bool showScore;
  final bool addEmptyHeader;
  final bool noScroll;

  // Maximalbreite für den Inhalt
  final double maxWidth;
  final ScrollController? scrollController;

  const QLayout({
    super.key,
    required this.child,
    this.scrollController,
    this.backButton = false,
    this.showScore = false,
    this.addEmptyHeader = false,
    this.maxWidth = 1000,
    this.noScroll = false,
  });

  @override
  State<QLayout> createState() => _QLayoutState();
}

class _QLayoutState extends State<QLayout> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double containerWidth = width > widget.maxWidth ? widget.maxWidth : width;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Anpassung bei der Tastatur
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 49, 94, 0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 1),
              )
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0, 1.0],
              colors: [
                QColors.primaryColor,
                QColors.backgroundColor,
                QColors.backgroundColor,
              ],
            ),
          ),
          constraints: BoxConstraints(minHeight: height),
          width: containerWidth,
          child: widget.noScroll
              ? widget.child
              : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back-Button als Header
                if (widget.backButton)
                  AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          size: 30, color: QColors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                // Optionaler leerer Header
                if (widget.addEmptyHeader) const SizedBox(height: 50),
                // Score-Header anzeigen
                if (widget.showScore) const ScoreHeader(badges: []),
                // Der Hauptinhalt
                widget.child,
                // Platz am Ende für Polsterung
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
