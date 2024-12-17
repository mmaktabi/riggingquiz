import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/SignInPage.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/textfield.dart';

class EditEmailPassword extends StatefulWidget {
  const EditEmailPassword({super.key});

  @override
  _EditEmailPasswordState createState() => _EditEmailPasswordState();
}

class _EditEmailPasswordState extends State<EditEmailPassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isAnonymous = true; // Standardmäßig auf true setzen

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    isAnonymous = user?.isAnonymous ?? true;
  }

  // Helper Funktion zum Maskieren der E-Mail-Adresse
  String _maskEmail(String email) {
    // Teile die E-Mail-Adresse in den lokalen und den Domain-Teil
    List<String> parts = email.split('@');
    if (parts.length != 2) {
      return email; // ungültige E-Mail, einfach zurückgeben
    }

    String localPart = parts[0];
    String domainPart = parts[1];

    // Maskiere den lokalen Teil, lasse nur die ersten 3 Buchstaben sichtbar
    String maskedLocalPart = localPart.length <= 3
        ? localPart // wenn der lokale Teil kürzer ist, alles anzeigen
        : '${localPart.substring(0, 3)}${'*' * (localPart.length - 3)}';

    return '$maskedLocalPart@$domainPart';
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);

    return QLayout(
      backButton: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const QText(
                text: "Du bist eingeloggt als",
                color: QColors.accentColor,
              ),
              userService.email != null
                  ? QText(
                      text: _maskEmail(userService.email!),
                      color: QColors.accentColor,
                    )
                  : const QText(
                      text: "Anonym",
                      color: QColors.accentColor,
                    ),
              const SizedBox(height: 20),
              if (isAnonymous)
                ..._buildAnonymousUserForm(userService)
              else
                ..._buildRegisteredUserForm(userService),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAnonymousUserForm(UserService userService) {
    return [
      const QText(
        text:
            "Gib hier deine neue E-Mail-Adresse und dein Passwort ein, um ein Konto zu erstellen.",
        color: QColors.accentColor,
      ),
      QTextField(
        controller: emailController,
        labelText: 'E-Mail',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Bitte eine E-Mail-Adresse eingeben';
          }
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Bitte eine gültige E-Mail-Adresse eingeben';
          }
          return null;
        },
      ),
      QTextField(
        controller: newPasswordController,
        labelText: 'Passwort',
        isPassword: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Bitte geben Sie ein Passwort ein.';
          }

          // Passwortregeln überprüfen
          String pattern =
              r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~])[A-Za-z\d!@#\$&*~]{8,}$';
          RegExp regex = RegExp(pattern);

          if (!regex.hasMatch(value)) {
            return 'Das Passwort muss mindestens 8 Zeichen lang sein, eine Zahl, einen Großbuchstaben und ein Sonderzeichen enthalten.';
          }

          return null;
        },
      ),
      const SizedBox(height: 20),
      QButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              // Verknüpfen des anonymen Benutzers mit E-Mail und Passwort
              await userService.linkAnonymousUserWithEmailAndPassword(
                emailController.text,
                newPasswordController.text,
              );

              // Optional: Senden Sie eine E-Mail zur Bestätigung
              final user = FirebaseAuth.instance.currentUser;
              if (user != null && !user.emailVerified) {
                await user.sendEmailVerification();
              }

              // Navigieren Sie zu einer Bestätigungsseite oder zurück zur Hauptseite
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fehler: $e')),
              );
            }
          }
        },
        buttonText: 'Registrieren',
      ),
    ];
  }

  List<Widget> _buildRegisteredUserForm(UserService userService) {
    return [
      const QText(
        text: "Ändere hier dein Passwort.",
        color: QColors.accentColor,
      ),
      QTextField(
        controller: oldPasswordController,
        labelText: 'Altes Passwort',
        isPassword: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Bitte geben Sie Ihr altes Passwort ein.';
          }
          return null;
        },
      ),
      QTextField(
        controller: newPasswordController,
        labelText: 'Neues Passwort',
        isPassword: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Bitte geben Sie ein neues Passwort ein.';
          }

          // Passwortregeln überprüfen
          String pattern =
              r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~])[A-Za-z\d!@#\$&*~]{8,}$';
          RegExp regex = RegExp(pattern);

          if (!regex.hasMatch(value)) {
            return 'Das Passwort muss mindestens 8 Zeichen lang sein, eine Zahl, einen Großbuchstaben und ein Sonderzeichen enthalten.';
          }

          return null;
        },
      ),
      const SizedBox(height: 20),
      QButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              // Passwort ändern
              await userService.changePassword(
                oldPasswordController.text,
                newPasswordController.text,
              );

              // Erfolgsmeldung anzeigen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Passwort erfolgreich geändert.')),
              );

              // Optional: Zurück zur vorherigen Seite navigieren
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fehler: $e')),
              );
            }
          }
        },
        buttonText: 'Passwort ändern',
      ),
    ];
  }
}
