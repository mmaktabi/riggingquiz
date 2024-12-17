import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/admin_auth/auth_service%20.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/textfield.dart';

class AuthAdmin extends StatefulWidget {
  const AuthAdmin({super.key});

  @override
  _AuthAdminState createState() => _AuthAdminState();
}

class _AuthAdminState extends State<AuthAdmin> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QTextField(
              labelText: 'Benutzername',
              controller: _emailController,
            ),
            QTextField(
              labelText: 'Password',
              controller: _passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            isLoading
                ? QWidgets().progressIndicator
                : QButton(
                    onPressed: () {
                      _authService.createAdminUser(
                        "${_emailController.text.trim()}@rigging-quiz.de",
                        _passwordController.text.trim(),
                      );
                    },
                    buttonText: "Admin erstellen",
                  ),
          ],
        ),
      ),
    );
  }
}
