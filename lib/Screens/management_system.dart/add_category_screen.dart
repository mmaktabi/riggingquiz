import 'package:flutter/material.dart';
import 'package:rigging_quiz/Screens/management_system.dart/generic_form.dart';
import 'package:rigging_quiz/data/firebase/add_quiz.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/forms/colorpicker.dart';
import 'package:rigging_quiz/widgets/img_upload.dart';
import 'package:rigging_quiz/widgets/textfield.dart';

class CategoryFormScreen extends StatefulWidget {
  final String title;
  final QuizCategory? category;

  const CategoryFormScreen({super.key, 
    required this.title,
    this.category,
  });

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final QuizService _quizService = QuizService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String difficulty = 'beginner';
  String imageUrl = "";
  Color selectedColor = Colors.blue; // Standardfarbe

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      nameController.text = widget.category!.name;
      descriptionController.text = widget.category!.description;
      difficulty = widget.category!.difficulty.name;
      imageUrl = widget.category!.iconImage;
      selectedColor = widget.category!.categoryColor; // Farbe laden
    }
  }

  @override
  Widget build(BuildContext context) {
    return QLayout(
      addEmptyHeader: true,
      backButton: true,
      child: GenericForm(
        formKey: _formKey,
        fields: [
          Align(
            alignment: Alignment.centerLeft,
            child: QText(
              text: widget.title,
              color: QColors.white,
              fontSize: 18,
            ),
          ),
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
            controller: nameController,
            labelText: 'Name',
            validator: (value) =>
                value!.isEmpty ? 'Name ist erforderlich' : null,
          ),
          QTextField(
            controller: descriptionController,
            labelText: 'Beschreibung',
          ),
          /*   QDropDown<String>(
            value: difficulty,
            items: QuizDifficulty.values.map((level) => level.name).toList(),
            labelText: 'Schwierigkeitsgrad',
            onChanged: (String? newValue) {
              setState(() {
                difficulty = newValue!;
              });
            },
          ),*/
          ColorPickerForm(
            initialColor: selectedColor, // Initialfarbe übergeben
            onColorSelected: (color) =>
                selectedColor = color, // Farbe speichern
          ),
        ],
        onSave: () {
          if (_formKey.currentState!.validate()) {
            QuizCategory category = QuizCategory(
              name: nameController.text,
              description: descriptionController.text,
              iconImage: imageUrl, // URL des Bildes
              difficulty: QuizDifficulty.values.firstWhere(
                (d) => d.name == difficulty,
                orElse: () => QuizDifficulty.beginner,
              ),
              quizzes: widget.category?.quizzes ?? [],
              categoryColor: selectedColor, // Farbe speichern
            );

            if (widget.category?.id != null) {
              _quizService.updateCategory(widget.category?.id ?? "", category);
            } else {
              _quizService.addCategory(category);
            }
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryFormScreen(title: "Kategorie hinzufügen");
  }
}

class EditCategoryScreen extends StatelessWidget {
  final QuizCategory category;

  const EditCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return CategoryFormScreen(
      title: "Kategorie bearbeiten",
      category: category,
    );
  }
}
