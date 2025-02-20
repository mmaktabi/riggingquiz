import 'package:flutter/material.dart';
import 'package:rigging_quiz/Screens/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/utils/images.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/textfield.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isSignUp = false;
  bool _isLoading = false;
  bool _acceptedPrivacyPolicy = false;
  double _selectedAge = 18;

  // Variablen zum Speichern der eingegebenen Werte
  String _email = "";
  String _password = "";
  String _name = "";

  @override
  Widget build(BuildContext context) {
    return QLayout(
      child: Column(
        children: [
          const SizedBox(height: 50),
          const SizedBox(
            width: 220,
            height: 220,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(Images.appLogo),
            ),
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // E-Mail Eingabe
                QTextField(
                  labelText: 'E-Mail',
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _email = value ?? "",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte geben Sie eine E-Mail ein.';
                    }
                    return null;
                  },
                ),

                // Passwort Eingabe
                QTextField(
                  labelText: 'Passwort',
                  isPassword: true,
                  onSaved: (value) => _password = value ?? "",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte geben Sie ein Passwort ein.';
                    }
                    String pattern =
                        r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~])[A-Za-z\d!@#\$&*~]{8,}$';
                    RegExp regex = RegExp(pattern);

                    if (!regex.hasMatch(value)) {
                      return 'Das Passwort muss mindestens 8 Zeichen lang sein, eine Zahl, einen Großbuchstaben und ein Sonderzeichen enthalten.';
                    }
                    return null;
                  },
                ),

                // Zusätzliche Eingaben für Registrierung
                if (_isSignUp)
                  Column(
                    children: [
                      // Name Eingabe
                      QTextField(
                        labelText: 'Name',
                        onSaved: (value) => _name = value ?? "",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte geben Sie einen Namen ein.';
                          }
                          return null;
                        },
                      ),

                      // Alter Eingabe mit Slider
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            QText(
                              text: 'Alter: ${_selectedAge.round()}',
                            ),
                            Expanded(
                              child: Slider(
                                value: _selectedAge,
                                min: 10,
                                max: 100,
                                activeColor: QColors.primaryColor,
                                thumbColor: QColors.primaryColor,
                                divisions: 90,
                                label: _selectedAge.round().toString(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAge = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Datenschutzerklärung akzeptieren
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Checkbox(
                              activeColor: QColors.primaryColor,
                              value: _acceptedPrivacyPolicy,
                              onChanged: (value) {
                                setState(() {
                                  _acceptedPrivacyPolicy = value ?? false;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: () async {
                                const url = 'https://rigging-quiz.de/datenschutz';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                } else {
                                throw 'Konnte den Link nicht öffnen: $url';
                                }
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: QText(
                                  text: 'Ich akzeptiere die Datenschutzerklärung',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // Anmelde-/Registrierungs-Button
                QButton(
                  onPressed: _isLoading || (!_acceptedPrivacyPolicy && _isSignUp)
                      ? null
                      : _submit,
                  buttonText: _isSignUp ? 'Registrieren' : 'Anmelden',
                ),
                if (_isLoading) QWidgets().progressIndicator,

                // Wechsel zwischen Login und Registrierung
                QButton(
                  textButton: true,
                  textColor: QColors.primaryColor,
                  weight: FontWeight.bold,
                  onPressed: _toggleSignUp,
                  buttonText: _isSignUp
                      ? 'Bereits registriert? Hier anmelden'
                      : 'Noch kein Konto? Hier registrieren',
                ),

                // Anonyme Anmeldung
                QButton(
                  onPressed: _isLoading ? null : _signInAnonymously,
                  buttonText: 'Anonym fortfahren',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// **Wechselt zwischen Login und Registrierung**
  void _toggleSignUp() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  /// **Anmeldung oder Registrierung**
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save(); // 👈 Speichert alle Werte in Variablen

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isSignUp) {
        await UserService().signUpUser(
          _email,
          _password,
          _name,
          _selectedAge.round().toString(),
        );
      } else {
        await UserService().signInUser(
          _email,
          _password,
        );
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// **Anonyme Anmeldung**
  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await UserService().signInAnonymouslyUser();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
