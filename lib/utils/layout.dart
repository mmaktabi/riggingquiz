import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/images.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rigging_quiz/widgets/score/score_header.dart';

/// Diese Klasse enthält das Layout mit `Scaffold` und `CustomScrollView` mit Slivers
class QLayout extends StatelessWidget {
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
    this.maxWidth = 888, // Standard maximale Breite auf 888 gesetzt
    this.noScroll = false,
  });

  @override
  Widget build(BuildContext context) {
    // Aktuelle Bildschirmbreite
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // Die Breite des Inhalts ist entweder die Bildschirmbreite oder maximal 888 Pixel
    double containerWidth = width > maxWidth ? maxWidth : width;

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Sicherstellen, dass die Größe bei Tastatur angepasst wird
      body: Stack(
        children: [
          // Hintergrund
          Positioned.fill(
            child: Container(
              color: QColors.white, // Hintergrundfarbe
              child: SvgPicture.asset(
                Images.ovalWithOutlineBottomHomeScreen, // SVG-Bild
                fit: BoxFit.cover,
                alignment: Alignment.center, // Zentriere das Bild
              ),
            ),
          ),
          // Der eigentliche Inhalt in der Mitte
          Center(
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
                  stops: [
                    0.0, // Anfang der primaryColor
                    1.0, // Übergang von tertiaryColor zur secondaryColor
                    1.0, // Ende der secondaryColor
                  ],
                  colors: [
                    QColors.primaryColor, // Primäre Farbe
                    QColors.backgroundColor, // Sekundäre Farbe, unten
                    QColors.backgroundColor, // Sekundäre Farbe, unten
                  ],
                ),
              ),
              constraints: BoxConstraints(minHeight: height),
              width: containerWidth,
              child: noScroll
                  ? child
                  : CustomScrollView(
                      controller: scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.manual,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              if (backButton)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back,
                                        size: 30, color: QColors.white),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              if (addEmptyHeader)
                                const SizedBox(
                                  height: 50,
                                ),
                              if (showScore) const ScoreHeader(badges: []),
                              child,
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }
}
