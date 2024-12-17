import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class QTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function(String?)? onSaved;

  const QTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType ?? TextInputType.text,
        cursorColor: QColors.primaryColor, // Cursor-Farbe
        style: primaryTextStyle(color: QColors.primaryColor), // Textfarbe
        validator: validator, // Validator für Eingabeprüfung
        onChanged: onChanged, // Callback bei Änderungen
        onFieldSubmitted: onSubmitted, // Callback bei Abschluss der Eingabe
        onSaved: onSaved, // Callback beim Speichern des Formulars
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: primaryTextStyle(color: QColors.primaryColor),
          filled: true,
          fillColor: QColors.formBgColor, // Hintergrundfarbe des Feldes
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: QColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: QColors.primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: QColors.secondaryColor),
          ),
        ),
      ),
    );
  }
}
