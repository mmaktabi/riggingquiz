import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class QTextField extends StatefulWidget {
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
    this.controller, // 👈 Optionaler Controller
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.onSaved,
  });

  @override
  _QTextFieldState createState() => _QTextFieldState();
}

class _QTextFieldState extends State<QTextField> {
  bool _isPasswordVisible = false;
  late FocusNode _focusNode;
  TextEditingController? _internalController; // 👈 Falls kein Controller übergeben wird

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Falls kein Controller übergeben wurde, erstelle einen internen
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();

    // Falls ein interner Controller erstellt wurde, dispose ihn
    _internalController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        focusNode: _focusNode,
        controller: widget.controller ?? _internalController, // 👈 Verwende externen oder internen Controller
        obscureText: widget.isPassword && !_isPasswordVisible,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        cursorColor: QColors.primaryColor,
        style: primaryTextStyle(color: QColors.primaryColor),
        validator: widget.validator,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        onSaved: widget.onSaved,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: primaryTextStyle(color: QColors.primaryColor),
          filled: true,
          fillColor: QColors.formBgColor,
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
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: QColors.primaryColor,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
