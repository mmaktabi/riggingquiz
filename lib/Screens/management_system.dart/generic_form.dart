import 'package:flutter/material.dart';
import 'package:rigging_quiz/widgets/button.dart';

class GenericForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final VoidCallback onSave;

  const GenericForm({super.key, 
    required this.formKey,
    required this.fields,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...fields,
            const SizedBox(height: 20),
            QButton(
              buttonText: "Speichern",
              onPressed: onSave,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ],
        ),
      ),
    );
  }
}
