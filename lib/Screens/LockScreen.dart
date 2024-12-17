import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/admin_auth/auth_service%20.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockScreen extends StatefulWidget {
  final Widget child; // Neues child-Widget
  final VoidCallback onUnlock;

  const LockScreen({super.key, required this.child, required this.onUnlock});

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String email = '';
  String password = '';
  String _message = '';
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  bool isUnlocked = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkIfUnlocked();
  }

  Future<void> _checkIfUnlocked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool unlocked = prefs.getBool('isUnlocked') ?? false;
    if (unlocked) {
      setState(() {
        isUnlocked = true;
      });
      widget.onUnlock();
    }
  }

  Future<void> _checkPassword(String pass) async {
    if (pass == "Apex123@" && email == "info@apex-riggingschule.de") {
      // Erfolgreiches Passwort, speichere den Status in den SharedPreferences

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isUnlocked', true);

      setState(() {
        _message = 'Passwort korrekt!';
        isUnlocked = true;
        widget.onUnlock();
      });
    } else {
      toggleLoading();
      setState(() {
        _message = 'Falsches Passwort!';
      });
    }
  }

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isUnlocked) {
      return widget.child; // Zeige das Child an, wenn entsperrt
    }

    return QLayout(
      addEmptyHeader: true,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 500,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                    ),
                    child: Column(
                      children: [
                        QTextField(
                          labelText: 'E-mail',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte ein E-mail eingeben';
                            }
                            return null;
                          },
                          onSaved: (value) => email = value!,
                        ),
                        QTextField(
                          labelText: 'Passwort',
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte ein Passwort eingeben';
                            }
                            return null;
                          },
                          onSaved: (value) => password = value!,
                        ),
                        QButton(
                          onPressed: () {
                            if (formKey.currentState != null) {
                              if (formKey.currentState!.validate()) {
                                toggleLoading();
                                formKey.currentState!.save();
                                _checkPassword(password);
                              }
                            }
                          },
                          buttonText: 'Überprüfen',
                          isLoading: isLoading,
                        ),
                        QText(
                          text: _message,
                          color: QColors.red,
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
