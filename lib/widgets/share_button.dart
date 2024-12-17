import 'package:flutter/material.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Text für das Teilen
    const String shareText = '''
🎉 Hey! Ich habe gerade das rigging_quiz entdeckt – ein interaktives Quiz für alle, die Spaß an Wissen und Herausforderungen haben! 💡 Teste dein Können in Rigging, Traversen und mehr.

👉 Jetzt ausprobieren: https://rigging-quiz.de/

Mach mit und werde der Rigging-Meister! 🏆
''';

    return QButton(
      fontSize: 12,
      icon: Icons.share,
      buttonText: "Lade deine Freunde ein, rigging_quiz beizutreten!",
      onPressed: () async {
        try {
          // Versuche zuerst, das native Teilen auszuführen
          await Share.share(shareText);
        } catch (e) {
          // Fallback für Web: Öffne die Teilen-URL
          html.window.open('mailto:?body=$shareText', '_blank');
        }
      },
    );
  }
}
