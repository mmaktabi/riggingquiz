import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/Screens/management_system.dart/category_list_screen.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/utils/admin_auth/auth_screen.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/textfield.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reauthPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _reauthenticateAndChangePassword() async {
    final userService = Provider.of<UserService>(context, listen: false);

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Reauthentifizieren
      await userService.reauthenticateUser(reauthPasswordController.text);

      // Passwort ändern
      await userService.updatePasswordAndEmail(
        userService.email!,
        passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const AuthAdminScreen(child: CategoryListScreen())),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
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

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);

    return QLayout(
      backButton: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QTextField(
                    controller: reauthPasswordController,
                    labelText: 'Aktuelles Passwort',
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte geben Sie Ihr aktuelles Passwort ein.';
                      }
                      return null;
                    },
                  ),
                  QTextField(
                    controller: passwordController,
                    labelText: 'Neues Passwort',
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
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black38,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: QWidgets().progressIndicator,
                ),
              ),
            ),
          QButton(
            onPressed: _isLoading ? null : _reauthenticateAndChangePassword,
            buttonText: 'Passwort ändern',
          ),
        ],
      ),
    );
  }
}
