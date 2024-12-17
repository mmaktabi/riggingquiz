import 'package:flutter/material.dart';

class TrueFalseWidget extends StatelessWidget {
  final Function(bool) onChanged;

  const TrueFalseWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<bool>(
      value: true,
      onChanged: (bool? value) {
        onChanged(value ?? true);
      },
      items: const [
        DropdownMenuItem<bool>(
          value: true,
          child: Text('Wahr'),
        ),
        DropdownMenuItem<bool>(
          value: false,
          child: Text('Falsch'),
        ),
      ],
      decoration: const InputDecoration(labelText: 'Richtig oder Falsch'),
    );
  }
}
