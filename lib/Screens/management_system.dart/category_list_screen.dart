import 'package:flutter/material.dart';
import 'package:rigging_quiz/Screens/management_system.dart/add_category_screen.dart';
import 'package:rigging_quiz/Screens/management_system.dart/change_password.dart';
import 'package:rigging_quiz/Screens/management_system.dart/question_list_screen.dart';
import 'package:rigging_quiz/data/firebase/add_quiz.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/admin_auth/auth_screen.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final QuizService _quizService = QuizService();
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return QLayout(
      addEmptyHeader: true,
      child: StreamBuilder(
        stream: _quizService.database.ref().child('categories').onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            if (!mounted) return QWidgets().progressIndicator;
          }

          if (snapshot.hasData &&
              (snapshot.data!).snapshot.value != null) {
            Map<dynamic, dynamic> categoriesMap =
                (snapshot.data!).snapshot.value
                    as Map<dynamic, dynamic>;
            List<MapEntry<dynamic, dynamic>> categoriesList =
                categoriesMap.entries.toList();
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 200,
                        child: QButton(
                          fontSize: 13,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditPassword(),
                                ));
                          },
                          buttonText: "Password ändern",
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: QButton(
                          fontSize: 13,
                          onPressed: () async {
                            await userService.signOut();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AuthAdminScreen(
                                      child: CategoryListScreen()),
                                ));
                          },
                          buttonText: "Ausloggen",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const QText(
                        text: "Kategorien",
                        fontSize: 16,
                        color: QColors.white,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: QColors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddCategoryScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: categoriesList.length,
                    itemBuilder: (context, index) {
                      // Lokale Variablen innerhalb des Builders definieren
                      String categoryId = categoriesList[index].key;
                      Map categoryData = categoriesList[index].value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0), // Abstand zwischen den Kacheln
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Colors.white, // Hintergrundfarbe des Containers
                            borderRadius: BorderRadius.circular(
                                15.0), // Abgerundete Ecken
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withOpacity(0.1), // Schatten
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // Position des Schattens
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical:
                                    8.0), // Abstand innerhalb des Containers
                            title: QText(
                              text: categoryData['name'] ??
                                  'Unbekannte Kategorie',
                              color: QColors.primaryColor,
                              fontSize: 20,
                              weight: FontWeight.w600,
                            ),
                            subtitle: QText(
                              text: categoryData['description'] ??
                                  'Keine Beschreibung verfügbar',
                              color: QColors.primaryColor,
                              fontSize: 14,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: QColors.primaryColor),
                                  onPressed: () {
                                    // Navigiere zur Bearbeitungsseite der Kategorie
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditCategoryScreen(
                                          category: QuizCategory(
                                            id: categoryId,
                                            categoryColor: categoryData[
                                                        'categoryColor'] !=
                                                    null
                                                ? Color(int.parse(
                                                    categoryData[
                                                            'categoryColor']
                                                        .substring(1),
                                                    radix:
                                                        16)) // Farbe aus Hex-String laden
                                                : QColors
                                                    .primaryColor, // Standardfarbe, falls null
                                            name: categoryData['name'],
                                            description:
                                                categoryData['description'],
                                            iconImage:
                                                categoryData['iconImage'],
                                            difficulty: QuizDifficulty.values
                                                .firstWhere(
                                              (d) =>
                                                  d.name ==
                                                  categoryData['difficulty'],
                                            ),
                                            quizzes: [],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: QColors.primaryColor),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Löschen bestätigen'),
                                          content: const Text(
                                              'Möchten Sie diese Kategorie wirklich löschen?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Abbrechen'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Dialog schließen
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Löschen',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              onPressed: () {
                                                _quizService
                                                    .deleteCategory(categoryId);
                                                Navigator.of(context)
                                                    .pop(); // Dialog schließen
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              // Gehe zur Fragenansicht der Kategorie
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuestionListScreen(
                                    categoryId: categoryId,
                                    categoryName: categoryData['name'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          } else {
            return Column(
              children: [
                const Center(child: Text('Keine Kategorien vorhanden.')),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddCategoryScreen(),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
