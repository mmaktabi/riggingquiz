import 'package:flutter/material.dart';
import 'package:rigging_quiz/widgets/button.dart';
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
      buttonText: "Lade deine Freunde ein, RiggingQuiz beizutreten!",
      onPressed: () async {
        if (html.window.navigator.share != null) {
          // Verwende die Web Share API direkt
          try {
            await html.window.navigator.share({
              'title': 'RiggingQuiz!',
              'text': shareText,
              'url': 'https://rigging-quiz.de/',
            });
          } catch (error) {
            print('Teilen fehlgeschlagen: $error');
          }
        } else {
          // Fallback für Browser ohne Web Share API
          print('Web Share API wird nicht unterstützt');
          // Kopiere den Text in die Zwischenablage
          await html.window.navigator.clipboard!.writeText(shareText);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Text wurde in die Zwischenablage kopiert!'),
            ),
          );
        }
      },
    );
  }
}
