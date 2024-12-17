import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class ColorPickerForm extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerForm({super.key, required this.initialColor, required this.onColorSelected});

  @override
  _ColorPickerFormState createState() => _ColorPickerFormState();
}

class _ColorPickerFormState extends State<ColorPickerForm> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  void changeColor(Color color) {
    setState(() => selectedColor = color);
    widget.onColorSelected(color); // Farbe zurückgeben
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: QText(text: "Kategoriefarbe"),
        ),
        QButton(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Wähle eine Farbe'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        hexInputBar: true, // Hex-Eingabe aktivieren
                        pickerColor: selectedColor,
                        onColorChanged: changeColor,
                        showLabel: true,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      QButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          buttonText: "Auswählen")
                    ],
                  );
                },
              );
            },
            buttonText: 'Farbe auswählen'),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: selectedColor,
              borderRadius: const BorderRadius.all(Radius.circular(33))),
        ),
      ],
    );
  }
}
