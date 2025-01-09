import 'package:flutter/material.dart';
import 'package:rigging_quiz/Screens/home_page.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/utils/images.dart';
import 'package:rigging_quiz/widgets/textfield.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false; // Flag, um zwischen Sign-In und Sign-Up zu wechseln
  bool _isLoading = false;

  // Controller für Textfelder
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return QLayout(
      child: Column(
        children: [
          SizedBox(height: 50),
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
                QTextField(
                  labelText: 'E-Mail',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte geben Sie eine E-Mail ein.';
                    }
                    return null;
                  },
                ),
                QTextField(
                  labelText: 'Passwort',
                  controller: _passwordController,
                  isPassword: true,
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
                if (_isSignUp)
                  Row(
                    children: [
                      Expanded(
                        child: QTextField(
                          labelText: 'Name',
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte geben Sie einen Namen ein.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                if (_isSignUp)
                  QTextField(
                    keyboardType: TextInputType.number,
                    controller: _ageController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte geben Sie Ihr Alter ein.';
                      }
                      return null;
                    },
                    labelText: 'Alter',
                  ),
                const SizedBox(height: 20),
                QButton(
                  onPressed: _isLoading ? null : _submit,
                  buttonText: _isSignUp ? 'Registrieren' : 'Anmelden',
                ),
                if (_isLoading) QWidgets().progressIndicator,
                QButton(
                  textButton: true,
                  textColor: QColors.primaryColor,
                  weight: FontWeight.bold,
                  onPressed: _toggleSignUp,
                  buttonText: _isSignUp
                      ? 'Bereits registriert? Hier anmelden'
                      : 'Noch kein Konto? Hier registrieren',
                ),
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

  void _toggleSignUp() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isSignUp) {
        await UserService().signUpUser(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
          _ageController.text,
        );
      } else {
        await UserService().signInUser(
          _emailController.text,
          _passwordController.text,
        );
      }

      if (mounted) {
        Navigator.push(
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

  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await UserService().signInAnonymouslyUser();
      if (mounted) {
        Navigator.push(
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
