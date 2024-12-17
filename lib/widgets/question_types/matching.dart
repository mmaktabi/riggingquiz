import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/img_upload.dart';
import 'package:rigging_quiz/widgets/textfield.dart';

class MatchingWidget extends StatefulWidget {
  final Function(List<Map<String, String>>) onPairsChanged;
  final List<Map<String, String>>? initialValue;

  const MatchingWidget({super.key, required this.onPairsChanged, this.initialValue});

  @override
  _MatchingWidgetState createState() => _MatchingWidgetState();
}

class _MatchingWidgetState extends State<MatchingWidget> {
  List<TextEditingController> leftControllers = [];
  List<TextEditingController> rightControllers = [];
  List<String?> leftImageUrls = [];
  List<String?> rightImageUrls = [];
  bool isLoading = true; // Statusvariable für das Laden der Daten

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
        _initializeWithValues(widget.initialValue!);
      } else {
        setState(() {
          _addPair();
          _addPair();
        });
      }
      // Setze isLoading auf false, nachdem die Initialisierung abgeschlossen ist
      setState(() {
        isLoading = false;
      });
    });
  }

  void _initializeWithValues(List<Map<String, String>> values) {
    for (var value in values) {
      final leftController = TextEditingController(text: value['leftText']);
      final rightController = TextEditingController(text: value['rightText']);
      leftControllers.add(leftController);
      rightControllers.add(rightController);
      leftImageUrls.add(value['leftImage']);
      rightImageUrls.add(value['rightImage']);
    }
    _updatePairs(); // Aktualisiert die Paare ohne setState
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return QWidgets().progressIndicator; // Ladeindikator anzeigen
    }

    return Column(
      children: [
        ...List.generate(leftControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                QImageUpload(
                  text: "",
                  link: leftImageUrls[index],
                  onImageSelected: (String imageUrl) {
                    setState(() {
                      leftImageUrls[index] = imageUrl;
                    });
                    _updatePairs();
                  },
                ),
                Expanded(
                  child: QTextField(
                    controller: leftControllers[index],
                    labelText: 'Linke Seite ${index + 1}',
                    onChanged: (_) => _updatePairs(),
                  ),
                ),
                const SizedBox(width: 10),
                QImageUpload(
                  text: "",
                  link: rightImageUrls[index],
                  onImageSelected: (String imageUrl) {
                    setState(() {
                      rightImageUrls[index] = imageUrl;
                    });
                    _updatePairs();
                  },
                ),
                Expanded(
                  child: QTextField(
                    controller: rightControllers[index],
                    labelText: 'Rechte Seite ${index + 1}',
                    onChanged: (_) => _updatePairs(),
                  ),
                ),
                if (index > 1)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removePair(index),
                  ),
              ],
            ),
          );
        }),
        ElevatedButton(
          onPressed: _addPair,
          child: const Text('Paar hinzufügen'),
        ),
      ],
    );
  }

  void _addPair() {
    setState(() {
      leftControllers.add(TextEditingController());
      rightControllers.add(TextEditingController());
      leftImageUrls.add(null);
      rightImageUrls.add(null);
    });
    _updatePairs();
  }

  void _removePair(int index) {
    setState(() {
      leftControllers[index].dispose();
      rightControllers[index].dispose();
      leftControllers.removeAt(index);
      rightControllers.removeAt(index);
      leftImageUrls.removeAt(index);
      rightImageUrls.removeAt(index);
    });
    _updatePairs();
  }

  void _updatePairs() {
    List<Map<String, String>> pairs = [];
    for (int i = 0; i < leftControllers.length; i++) {
      pairs.add({
        'leftText': leftControllers[i].text,
        'leftImage': leftImageUrls[i] ?? '',
        'rightText': rightControllers[i].text,
        'rightImage': rightImageUrls[i] ?? '',
      });
    }
    widget.onPairsChanged(pairs);
  }

  @override
  void dispose() {
    for (var controller in leftControllers) {
      controller.dispose();
    }
    for (var controller in rightControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
