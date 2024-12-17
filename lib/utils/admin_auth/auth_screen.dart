import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/admin_auth/auth_service%20.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/textfield.dart';

class AuthAdminScreen extends StatefulWidget {
  final Widget
      child; // Das Widget, das angezeigt wird, wenn der Benutzer Admin ist

  const AuthAdminScreen({super.key, required this.child});

  @override
  _AuthAdminScreenState createState() => _AuthAdminScreenState();
}

class _AuthAdminScreenState extends State<AuthAdminScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus(); // Admin-Status beim Start prüfen
  }

  Future<void> _checkAdminStatus() async {
    setState(() {
      isLoading = true;
    });

    try {
      bool hasAdminClaim = await _authService.checkAdminClaim();
      setState(() {
        isAdmin = hasAdminClaim;
      });
    } catch (e) {
      print('Fehler beim Überprüfen des Admin-Status: $e');
    } finally {
      setState(() {
        isLoading = false; // Sicherstellen, dass das Laden beendet wird
      });
    }
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    try {
      bool success = await _authService.signInWithEmailPassword(
        '${_emailController.text.trim()}@rigging-quiz.de',
        _passwordController.text.trim(),
      );

      if (success) {
        await _checkAdminStatus(); // Admin-Status nach Login prüfen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Keine Admin-Berechtigung')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login fehlgeschlagen: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return QWidgets().progressIndicator;
    }

    // Zeige das `child`-Widget, wenn der Benutzer Admin ist
    if (isAdmin) {
      return widget.child;
    }

    // Andernfalls zeige den Login-Bildschirm
    return QLayout(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: QText(
                text: "Loginseite für den Adminbereich.",
                color: QColors.white,
              ),
            ),
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
                    onPressed: _login,
                    buttonText: "Login",
                  ),
          ],
        ),
      ),
    );
  }
}
