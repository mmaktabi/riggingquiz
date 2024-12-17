import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class QDropDown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String labelText;
  final Function(T?) onChanged;

  const QDropDown({super.key, 
    required this.value,
    required this.items,
    required this.labelText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<T>(
          value: value,
          style: primaryTextStyle(color: QColors.accentColor),
          dropdownColor: QColors.secondaryColor,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
          decoration: _inputDecoration(true)),
    );
  }

  Widget _label(bool isFieldFocused) {
    return Container(
      decoration: BoxDecoration(
        color: isFieldFocused ? QColors.accentColor : QColors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
        child: QText(
          text: labelText,
          fontSize: 14,
          color: isFieldFocused ? QColors.text : QColors.accentColor,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(bool isFieldFocusedNotEmpty) {
    return InputDecoration(
      label: _label(isFieldFocusedNotEmpty),
      fillColor: QColors.secondaryColor,
      errorStyle: primaryTextStyle(color: ColorsHelpers.red, fontSize: 11),
      hintStyle: primaryTextStyle(),
      suffixStyle: primaryTextStyle(fontSize: 13, color: QColors.accentColor),
      filled: true,
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: QColors.secondaryColor),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: QColors.secondaryColor),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: QColors.secondaryColor),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: ColorsHelpers.red),
      ),
    );
  }
}
