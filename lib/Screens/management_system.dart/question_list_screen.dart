import 'package:flutter/material.dart';
import 'package:rigging_quiz/Screens/management_system.dart/add_questions_screen.dart';
import 'package:rigging_quiz/data/firebase/add_quiz.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class QuestionListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const QuestionListScreen({super.key, 
    required this.categoryId,
    required this.categoryName,
  });

  @override
  _QuestionListScreenState createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  final QuizService _quizService = QuizService();

  @override
  Widget build(BuildContext context) {
    return QLayout(
      backButton: true,
      addEmptyHeader: true,
      child: StreamBuilder(
        stream: _quizService.database
            .ref()
            .child('categories/${widget.categoryId}/questions')
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            if (!mounted) return QWidgets().progressIndicator;
          }

          if (snapshot.hasData) {
            final event = snapshot.data!;

            if (event.snapshot.value != null) {
              Map<dynamic, dynamic> questionsMap =
                  event.snapshot.value as Map<dynamic, dynamic>;
              List<MapEntry<dynamic, dynamic>> questionsList =
                  questionsMap.entries.toList();

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QText(
                          text: "Fragen für ${widget.categoryName} ",
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
                                builder: (context) => AddQuestionScreen(
                                  categoryId: widget.categoryId,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    ListView.builder(
                      itemCount: questionsList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String questionId = questionsList[index].key;
                        Map questionData = questionsList[index].value;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddQuestionScreen(
                                      categoryId: widget.categoryId,
                                      questionId: questionId,
                                    ),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundColor: QColors.primaryColor,
                                child: QText(
                                  text: '${index + 1}',
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              title: QText(
                                text: questionData['question'] ??
                                    'Fragetext fehlt',
                                color: QColors.primaryColor,
                                weight: FontWeight.w600,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: QColors.primaryColor),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddQuestionScreen(
                                            categoryId: widget.categoryId,
                                            questionId: questionId,
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
                                                'Möchten Sie diese Frage wirklich löschen?'),
                                            actions: [
                                              TextButton(
                                                child: const Text('Abbrechen'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text(
                                                  'Löschen',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                onPressed: () {
                                                  _quizService.deleteQuestion(
                                                      widget.categoryId,
                                                      questionId);
                                                  Navigator.of(context).pop();
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
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return _buildNoQuestionsView(context);
            }
          } else {
            return _buildNoQuestionsView(context);
          }
        },
      ),
    );
  }

  Widget _buildNoQuestionsView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Keine Fragen vorhanden.'),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Frage hinzufügen'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddQuestionScreen(categoryId: widget.categoryId),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
