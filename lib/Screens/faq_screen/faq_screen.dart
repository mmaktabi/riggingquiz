import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final Map<String, String> faqs = {
    "Wie kann ich einem Quiz beitreten?":
        "Du kannst einem Quiz beitreten, indem du auf der Startseite ein öffentliches Quiz auswählst.",
    "Kann ich mit Freunden spielen?":
        "Ja, du kannst deine Freunde einladen, indem du den Einladungslink teilst.",
    "Wie setze ich mein Passwort zurück?":
        "Um dein Passwort zurückzusetzen, klicke auf der Anmeldeseite auf 'Passwort vergessen'.",
    "Wie kann ich meinen Fortschritt verfolgen?":
        "Du kannst deinen Fortschritt im Abschnitt 'Profil' unter 'Quizverlauf' verfolgen.",
    "Welche Arten von Quizzes gibt es?":
        "Es gibt verschiedene Kategorien wie Wissenschaft, Mathematik, Geschichte und mehr.",
    "Gibt es eine Begrenzung für die Teilnahme an Quizzes?":
        "Nein, du kannst an so vielen Quizzes teilnehmen, wie du möchtest.",
    "Wie lösche ich mein Konto?":
        "Du kannst dein Konto im Abschnitt 'Einstellungen' unter 'Konto löschen' entfernen.",
    "Wie bearbeite ich meine Profildaten?":
        "Gehe zum Abschnitt 'Profil bearbeiten', um deine Informationen zu aktualisieren.",
    "Kann ich meine Freunde zum Spielen einladen?":
        "Ja, du kannst deine Freunde einladen, indem du den Einladungslink teilst.",
    "Wie sehe ich meine Quiz-Ergebnisse?":
        "Ergebnisse sind sofort nach Abschluss eines Quizzes im Abschnitt 'Ergebnisse' verfügbar."
  };

  @override
  Widget build(BuildContext context) {
    return QLayout(
      backButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: QText(
                text: "FAQS",
                fontSize: 22,
                color: QColors.accentColor,
                weight: FontWeight.w700,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: faqs.entries.map((faq) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FaqDetailScreen(
                            question: faq.key,
                            answer: faq.value,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          child: QText(
                            text: faq.key,
                            fontSize: 16,
                            color: QColors.accentColor,
                          ),
                        ),
                        const Divider(
                          color: QColors.accentColor,
                          height: 0,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class FaqDetailScreen extends StatelessWidget {
  final String question;
  final String answer;

  const FaqDetailScreen(
      {super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return QLayout(
      backButton: true,
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          QText(
            fontSize: 16,
            text: answer,
            color: QColors.accentColor,
          ),
        ],
      ),
    );
  }
}
