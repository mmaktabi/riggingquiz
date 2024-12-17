import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/img_upload.dart';
import 'package:rigging_quiz/widgets/textfield.dart';

class MultipleChoiceWidget extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onMultiChoiceChanged;
  final List<Map<String, dynamic>>? initialValue;

  const MultipleChoiceWidget({super.key, 
    required this.onMultiChoiceChanged,
    this.initialValue,
  });

  @override
  _MultipleChoiceWidgetState createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  List<TextEditingController> optionControllers = [];
  List<bool> isSelected = [];
  List<String?> imageUrls = [];
  bool isLoading = true; // Statusvariable für das Laden der Daten

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
        _initializeWithValues(widget.initialValue!);
      } else {
        setState(() {
          _addOption();
          _addOption();
        });
      }
      // Setze isLoading auf false, nachdem die Initialisierung abgeschlossen ist
      setState(() {
        isLoading = false;
      });
    });
  }

  void _initializeWithValues(List<Map<String, dynamic>> values) {
    for (var value in values) {
      final controller = TextEditingController(text: value['label'] ?? '');
      optionControllers.add(controller);
      isSelected.add(value['value'] ?? false);
      imageUrls.add(
          value.containsKey('imageUrl') ? value['imageUrl'] as String? : null);
    }
    _updateOptions(); // Aktualisiert die Optionen ohne setState
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
          child: QWidgets().progressIndicator); // Ladeindikator anzeigen
    }

    return Column(
      children: [
        ...List.generate(optionControllers.length, (index) {
          return Row(
            children: [
              QImageUpload(
                text: "",
                link: imageUrls[index],
                onImageSelected: (String imageUrl) {
                  setState(() {
                    imageUrls[index] = imageUrl;
                  });
                  _updateOptions();
                },
              ),
              Expanded(
                child: QTextField(
                  controller: optionControllers[index],
                  labelText: 'Option ${index + 1}',
                  onChanged: (value) {
                    _updateOptions(); // Aktualisiert die Daten bei Änderungen am Textfeld
                  },
                ),
              ),
              if (index > 1)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeOption(index),
                ),
              Checkbox(
                activeColor: QColors.primaryColor,
                value: isSelected[index],
                onChanged: (bool? value) {
                  setState(() {
                    isSelected[index] = value ?? false;
                  });
                  _updateOptions();
                },
              ),
            ],
          );
        }),
        QButton(
          buttonText: "Option hinzufügen",
          onPressed: _addOption,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
      ],
    );
  }

  void _addOption() {
    setState(() {
      optionControllers.add(TextEditingController());
      isSelected.add(false);
      imageUrls.add(null); // Null als Standard setzen
    });
    _updateOptions();
  }

  void _removeOption(int index) {
    setState(() {
      optionControllers[index].dispose();
      optionControllers.removeAt(index);
      isSelected.removeAt(index);
      imageUrls.removeAt(index);
    });
    _updateOptions();
  }

  void _updateOptions() {
    List<Map<String, dynamic>> optionsData = [];
    for (int i = 0; i < optionControllers.length; i++) {
      optionsData.add({
        'label': optionControllers[i].text,
        'value': isSelected[i],
        'imageUrl': imageUrls[i],
      });
    }
    widget.onMultiChoiceChanged(optionsData);
  }

  @override
  void dispose() {
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
