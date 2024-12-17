import 'package:flutter/material.dart';
import 'package:rigging_quiz/Screens/management_system.dart/generic_form.dart';
import 'package:rigging_quiz/data/firebase/add_quiz.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/img_upload.dart';
import 'package:rigging_quiz/widgets/question_types/multiple_choice.dart';
import 'package:rigging_quiz/widgets/question_types/matching.dart';
import 'package:rigging_quiz/widgets/textfield.dart';

class AddQuestionScreen extends StatefulWidget {
  final String categoryId;
  final String? questionId;

  const AddQuestionScreen({super.key, required this.categoryId, this.questionId});

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final QuizService _quizService = QuizService();

  final TextEditingController questionController = TextEditingController();
  final TextEditingController hintController = TextEditingController();

  String difficulty = QuizDifficulty.beginner.name;
  String questionType = QuizQuestionType.multipleChoice.name;
  List<Map<String, String>> matchingPairs = [];
  List<Map<String, dynamic>> multiSelect = [];
  String? imageUrl;

  bool isLoading = true; // Statusvariable für das Laden der Daten

  @override
  void initState() {
    super.initState();
    if (widget.questionId != null) {
      // Verwende addPostFrameCallback, um sicherzustellen, dass setState erst nach dem ersten Frame aufgerufen wird
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadQuestionData();
      });
    } else {
      setState(() {
        isLoading =
            false; // Direkt auf false setzen, da keine Daten geladen werden müssen
      });
    }
  }

  void _loadQuestionData() async {
    final Quiz? quiz =
        await _quizService.getQuestion(widget.categoryId, widget.questionId!);
    if (quiz != null) {
      setState(() {
        questionController.text = quiz.question;
        hintController.text = quiz.hint;
        difficulty = quiz.difficulty.name;
        questionType = quiz.questionType.name;
        imageUrl = quiz.imageUrl;
        matchingPairs =
            List<Map<String, String>>.from(quiz.matchingPairs ?? []);
        multiSelect = List<Map<String, dynamic>>.from(quiz.multiSelect ?? []);
        isLoading = false; // Das Laden ist abgeschlossen
      });
    } else {
      setState(() {
        isLoading =
            false; // Auch wenn kein Quiz gefunden wird, ist das Laden abgeschlossen
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return QWidgets().progressIndicator; // Ladeindikator anzeigen
    }

    return QLayout(
      backButton: true,
      addEmptyHeader: true,
      child: GenericForm(
        formKey: _formKey,
        fields: [
          QImageUpload(
            text: "",
            link: imageUrl,
            onImageSelected: (String url) {
              setState(() {
                imageUrl = url;
              });
            },
          ),
          QTextField(
            controller: questionController,
            labelText: "Frage",
            validator: (value) =>
                value!.isEmpty ? 'Frage ist erforderlich' : null,
          ),
          QTextField(
            controller: hintController,
            labelText: 'Hinweis',
          ),
          /*QDropDown<String>(
            value: difficulty,
            items: QuizDifficulty.values.map((level) => level.name).toList(),
            labelText: 'Schwierigkeitsgrad',
            onChanged: (String? newValue) {
              setState(() {
                difficulty = newValue!;
              });
            },
          ),*/
          const SizedBox(height: 50),

          /* QDropDown<String>(
            value: questionType,
            items: QuizQuestionType.values.map((type) => type.name).toList(),
            labelText: 'Fragetyp',
            onChanged: (String? newValue) {
              setState(() {
                questionType = newValue!;
              });
            },
          ),*/

          _buildQuestionTypeWidget(),
        ],
        onSave: () {
          if (_formKey.currentState!.validate()) {
            Quiz newQuiz = _createQuizFromForm();
            if (widget.questionId != null) {
              _quizService.updateQuestion(
                  widget.categoryId, widget.questionId!, newQuiz);
            } else {
              _quizService.addQuestionToCategory(widget.categoryId, newQuiz);
            }
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildQuestionTypeWidget() {
    switch (questionType) {
      case 'multipleChoice':
        return MultipleChoiceWidget(
          onMultiChoiceChanged: (List<Map<String, dynamic>> data) {
            setState(() {
              multiSelect = data;
            });
          },
          initialValue: widget.questionId == null ? [] : multiSelect,
        );
      case 'matching':
        return MatchingWidget(
          onPairsChanged: (List<Map<String, String>> pairs) {
            setState(() {
              matchingPairs = pairs;
            });
          },
          initialValue: matchingPairs,
        );
      default:
        return Container();
    }
  }

  Quiz _createQuizFromForm() {
    return Quiz(
      question: questionController.text,
      hint: hintController.text,
      imageUrl: imageUrl,
      questionType: QuizQuestionType.values
          .firstWhere((type) => type.name == questionType),
      difficulty:
          QuizDifficulty.values.firstWhere((level) => level.name == difficulty),
      matchingPairs: matchingPairs,
      multiSelect: multiSelect,
    );
  }
}
