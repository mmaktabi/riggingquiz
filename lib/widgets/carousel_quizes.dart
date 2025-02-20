import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rigging_quiz/Screens/live_quiz_screen/detail_quiz_screen.dart';
import 'package:rigging_quiz/data/firebase/add_quiz.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class CarouselQuizes extends StatefulWidget {
  const CarouselQuizes({super.key});

  @override
  _CarouselQuizesState createState() => _CarouselQuizesState();
}

class _CarouselQuizesState extends State<CarouselQuizes> {
  final QuizService quizService = QuizService();
  final ValueNotifier<int?> _hoveredIndexNotifier = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _hoveredIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double viewportFraction = width >= 800 ? 0.4 : 0.8;

    return SizedBox(
      height: 250,
      child: FutureBuilder<List<QuizCategory>>(
        future: quizService.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return QWidgets().progressIndicator;
          } else if (snapshot.hasError) {
            return const Center(child: Text('Fehler beim Laden der Kategorien'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Keine Kategorien verfügbar'));
          } else {
            final categories = snapshot.data!;
            return Center(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 250,
                  viewportFraction: viewportFraction,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 10),
                ),
                items: categories.asMap().entries.map((entry) {
                  int index = entry.key;
                  QuizCategory category = entry.value;

                  return MouseRegion(
                    onEnter: (_) => _hoveredIndexNotifier.value = index,
                    onExit: (_) => _hoveredIndexNotifier.value = null,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailQuizScreen(
                              quizCategory: category,
                            ),
                          ),
                        );
                      },
                      child: ValueListenableBuilder<int?>(
                        valueListenable: _hoveredIndexNotifier,
                        builder: (context, hoveredIndex, child) {
                          bool isHovered = hoveredIndex == index;
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: AnimatedScale(

                              scale: isHovered ? 0.98 : 0.99,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),

                                decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                  boxShadow: [
                                    isHovered ? BoxShadow(
                                      color: Color.fromRGBO(0, 49, 94, 0.5),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ) : BoxShadow(
                                      color: Color.fromRGBO(0, 49, 94, 0),

                                    )
                                  ],

                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.0, 1.0, 1.0],
                                    colors: [

                                      QColors.dullLavender,
                                      QColors.backgroundColor,
                                      QColors.backgroundColor,
                                    ],
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      category.iconImage != ""
                                          ? Image.network(
                                              category.iconImage,
                                              fit: BoxFit.cover,
                                              height: 100,
                                            )
                                          : const SizedBox(height: 100),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: QText(
                                          text: category.name,
                                          fontSize: 24,
                                          weight: FontWeight.bold,
                                          color: QColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
