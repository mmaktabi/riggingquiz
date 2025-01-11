import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String firebaseFunctionUrl =
      "http://localhost:5001/rigging-c0661/us-central1/createAdminUser";

  Future<void> createAdminUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(firebaseFunctionUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-backend-key':
              'mein-geheimer-schlussel', // Sicherer Backend-Schlüssel
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
      } else {
        print("Fehler: ${response.body}");
        throw Exception("Fehler beim Erstellen des Admin-Benutzers");
      }
    } catch (e) {
      print("Fehler: $e");
      rethrow;
    }
  }

  // Prüfen, ob der aktuelle Benutzer den Admin-Claim besitzt
  Future<bool> checkAdminClaim() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        IdTokenResult tokenResult = await user.getIdTokenResult(true);
        return tokenResult.claims?['admin'] == true;
      }
    } catch (e) {
      print('Fehler beim Überprüfen des Admin-Claims: $e');
    }
    return false;
  }

  // Benutzer einloggen und prüfen, ob admin=1
  Future<bool> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Token abrufen und Claims prüfen
        IdTokenResult tokenResult = await user.getIdTokenResult();
        if (tokenResult.claims != null &&
            tokenResult.claims!['admin'] == true) {
          print('Benutzer ist berechtigt');
          return true;
        } else {
          print('Benutzer ist nicht berechtigt');
          // Benutzer abmelden, falls kein admin=1
          await signOut();
          return false;
        }
      }
      return false;
    } catch (e) {
      print('Login fehlgeschlagen: $e');
      return false;
    }
  }

  // Benutzer abmelden
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Aktueller Benutzer
  User? get currentUser => _auth.currentUser;
}
