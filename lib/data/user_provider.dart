import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';

import 'package:random_avatar/random_avatar.dart';

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();

  // Privater Konstruktor
  UserService._internal();

  // Getter für die Singleton-Instanz
  factory UserService() {
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Cache-Variablen, die aktualisiert werden können
  String? _uid;
  String? _email;
  String? _name;
  String? _avatarUrl;
  bool _isLoading = false; // Variable zum Anzeigen des Ladezustands

  // Getter für aktuelle Benutzerinformationen
  String? get uid => _uid ?? _auth.currentUser?.uid;
  String? get email => _email ?? _auth.currentUser?.email;
  String? get name => _name ?? _auth.currentUser?.displayName;
  String? get avatarUrl => _avatarUrl ?? _auth.currentUser?.photoURL;
  bool get isLoading => _isLoading;

  // Stream zur Überwachung von Authentifizierungszustandsänderungen
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Difficulty und Notification Claims werden aus den Custom Claims gelesen
  Future<String> getDifficulty() async {
    try {
      _setLoading(true);
      User? user = _auth.currentUser;
      if (user != null) {
        IdTokenResult idTokenResult = await user.getIdTokenResult(true);
        return idTokenResult.claims?['difficulty']?.toString() ?? "unknown";
      }
    } catch (e) {
      print("Fehler beim Abrufen des Difficulty-Claims: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
    return "unknown";
  }

  Future<String> getNotification() async {
    try {
      _setLoading(true);
      User? user = _auth.currentUser;
      if (user != null) {
        IdTokenResult idTokenResult = await user.getIdTokenResult(true);
        return (idTokenResult.claims?['notification'] ?? false).toString();
      }
    } catch (e) {
      print("Fehler beim Abrufen des Notification-Claims: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
    return "false";
  }

  // Methode zur Anmeldung des Benutzers
  Future<UserCredential?> signInUser(String email, String password) async {
    try {
      _setLoading(true);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await updateCachedUserData(); // Aktualisiere die Daten nach Anmeldung
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Fehler bei der Anmeldung: ${e.message}');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> reauthenticateUser(String currentPassword) async {
    User? user = _auth.currentUser;
    if (user == null || email == null) {
      throw Exception("Benutzer ist nicht eingeloggt.");
    }

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      throw Exception("Reauthentifizierung fehlgeschlagen: ${e.toString()}");
    }
  }

  Future<void> linkAnonymousUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Kein Benutzer ist derzeit angemeldet.');
      }

      if (!user.isAnonymous) {
        throw Exception('Der Benutzer ist nicht anonym.');
      }

      // Erstellen Sie die Anmeldedaten mit der angegebenen E-Mail und dem Passwort
      final credential =
          EmailAuthProvider.credential(email: email, password: password);

      // Verknüpfen Sie das anonyme Konto mit den Anmeldedaten
      await user.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // Behandeln Sie spezifische Fehlercodes
      if (e.code == 'email-already-in-use') {
        throw Exception(
            'Die E-Mail-Adresse wird bereits von einem anderen Konto verwendet.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Die E-Mail-Adresse ist ungültig.');
      } else if (e.code == 'credential-already-in-use') {
        throw Exception('Das Konto mit diesen Anmeldedaten existiert bereits.');
      } else {
        throw Exception(
            'Fehler beim Verknüpfen des anonymen Benutzers: ${e.message}');
      }
    } catch (e) {
      throw Exception('Fehler beim Verknüpfen des anonymen Benutzers: $e');
    }
  }

  // Methode zur Anmeldung eines anonymen Benutzers mit zufälligem Avatar
  Future<UserCredential?> signInAnonymouslyUser() async {
    try {
      _setLoading(true);
      UserCredential userCredential = await _auth.signInAnonymously();

      String uid = userCredential.user!.uid;

      // Erstelle einen zufälligen Namen und Avatar für den anonymen Benutzer
      String randomName = 'Rigger${Random().nextInt(10000)}';

      // Avatar generieren und in Firebase Storage hochladen
      String avatarSvg = RandomAvatarString(randomName, trBackground: true);
      String avatarUrl = await _uploadAvatarToStorage(uid, avatarSvg);

      // Benutzerinformationen aktualisieren
      await userCredential.user!.updateDisplayName(randomName);
      await userCredential.user!.updatePhotoURL(avatarUrl);

      // Benutzer in der Realtime Database speichern
      await addUserInRealTimeDatabase(uid, randomName, avatarUrl);

      // Cache sofort aktualisieren und UI benachrichtigen
      _name = randomName;
      _avatarUrl = avatarUrl;

      return userCredential;
    } catch (e) {
      throw Exception('Fehler bei der anonymen Anmeldung: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> changeNameAndAvatar(String newName, String newAvatarSvg) async {
    try {
      _setLoading(true);
      User? user = _auth.currentUser;

      if (user != null) {
        // Avatar hochladen
        String newAvatarUrl =
            await _uploadAvatarToStorage(user.uid, newAvatarSvg);

        // Benutzerinformationen in Firebase Auth aktualisieren
        await user.updateDisplayName(newName);
        await user.updatePhotoURL(newAvatarUrl);

        // Benutzerinformationen in der Realtime Database aktualisieren
        DatabaseReference userRef = _database.ref().child('users/${user.uid}');
        await userRef.update({
          'name': newName,
          'searchName':
              newName.toLowerCase(), // Aktualisieren des searchName-Feldes
          'avatarUrl': newAvatarUrl,
        });

        // Cache sofort aktualisieren und UI benachrichtigen
        _name = newName;
        _avatarUrl = newAvatarUrl;
      } else {
        throw Exception('Benutzer ist nicht eingeloggt.');
      }
    } catch (e) {
      throw Exception('Fehler beim Ändern von Name und Avatar: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Registrierung eines neuen Benutzers und Speicherung von Avatar in Firebase Storage
  Future<UserCredential?> signUpUser(
      String email, String password, String name, String age) async {
    try {
      _setLoading(true);
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Avatar generieren und in Firebase Storage hochladen
      String avatarSvg = RandomAvatarString(name, trBackground: true);
      String avatarUrl = await _uploadAvatarToStorage(uid, avatarSvg);

      // Benutzerinformationen aktualisieren
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.updatePhotoURL(avatarUrl);

      // Sende eine E-Mail-Verifizierung
      await userCredential.user!.sendEmailVerification();

      // Benutzer in der Realtime Database speichern
      await addUserInRealTimeDatabase(uid, name, avatarUrl);

      // Cache sofort aktualisieren und UI benachrichtigen
      _name = name;
      _avatarUrl = avatarUrl;

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Fehler bei der Registrierung: ${e.message}');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Benutzerinformationen erneut laden und im Cache aktualisieren
  Future<void> updateCachedUserData() async {
    try {
      _setLoading(true);
      User? user = _auth.currentUser;
      if (user != null) {
        await user.reload();

        // Cache aktualisieren und UI benachrichtigen
        _uid = user.uid;
        _email = user.email;
        _name = user.displayName;
        _avatarUrl = user.photoURL;
      }
    } catch (e) {
      throw Exception('Fehler beim Aktualisieren der Benutzerdaten: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Hochladen des Avatars (SVG-Zeichenkette) in Firebase Storage
  Future<String> _uploadAvatarToStorage(String uid, String avatarSvg) async {
    try {
      Uint8List avatarBytes = Uint8List.fromList(utf8.encode(avatarSvg));
      Reference ref = _storage.ref().child('users/$uid/avatar.svg');
      UploadTask uploadTask = ref.putData(
          avatarBytes, SettableMetadata(contentType: 'image/svg+xml'));

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Fehler beim Hochladen des Avatars: $e');
    }
  }

// E-Mail und Passwort ändern
  Future<void> updatePasswordAndEmail(
      String newEmail, String newPassword) async {
    try {
      _setLoading(true);
      User? user = _auth.currentUser;

      if (user != null) {
        // E-Mail verifizieren und ändern
        await user.verifyBeforeUpdateEmail(newEmail);

        // Passwort aktualisieren
        await user.updatePassword(newPassword);

        // Benutzer abmelden und anschließend erneut anmelden
        await signOut();

        // Warte eine kurze Zeit, damit der Abmeldeprozess abgeschlossen ist
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      throw Exception('Fehler beim Ändern von E-Mail oder Passwort: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Methode, um den Benutzer in der Realtime Database zu speichern
  Future<void> addUserInRealTimeDatabase(
      String uid, String name, String url) async {
    try {
      _setLoading(true);

      // Referenz für den User-Pfad in der Realtime Database
      DatabaseReference userRef = _database.ref().child('users/$uid');

      // Struktur, die in der Datenbank gespeichert wird
      Map<String, dynamic> userData = {
        'uid': uid,
        'name': name,
        'searchName': name.toLowerCase(), // Hinzufügen des searchName-Feldes
        'avatarUrl': url,
        'score': 0,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Benutzerinformationen in der Datenbank speichern
      await userRef.set(userData);
    } catch (e) {
      throw Exception(
          'Fehler beim Speichern des Benutzers in der Realtime Database: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Abmeldung des Benutzers
  Future<void> signOut() async {
    try {
      _setLoading(true);
      User? user = _auth.currentUser;
      if (user != null) {
        await _auth.signOut();
        // Cache leeren nach Abmeldung und UI benachrichtigen
        _clearCache();
      }
    } catch (e) {
      throw Exception('Fehler beim Abmelden: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Schwierigkeit als Custom Claim ändern
  Future<void> updateDifficulty(String difficulty) async {
    try {
      _setLoading(true);
      User? user = _auth.currentUser;
      if (user != null) {
        await user.getIdToken(true);
        await updateCachedUserData();
      }
    } catch (e) {
      throw Exception('Fehler beim Ändern der Schwierigkeit: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Benachrichtigungseinstellung als Custom Claim ändern
  Future<void> updateNotification(bool notification) async {
    try {
      _setLoading(true);
      User? user = _auth.currentUser;
      if (user != null) {
        await user.getIdToken(true);
        await updateCachedUserData();
      }
    } catch (e) {
      throw Exception(
          'Fehler beim Ändern der Benachrichtigungseinstellung: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> setLoggedUserAsAdmin() async {
    try {
      _setLoading(true);
      User? user = _auth.currentUser;
      if (user != null) {
        // Custom Claim für den Benutzer setzen
        await _database.ref().child('users/${user.uid}').update({
          'isAdmin': true,
        });

        // Diese Funktion erfordert normalerweise Admin-Rechte oder Server-Interaktion,
        // um Custom Claims sicher zu setzen.
        await _auth.currentUser!.getIdToken(true);
      } else {
        throw Exception('Kein Benutzer angemeldet.');
      }
    } catch (e) {
      throw Exception('Fehler beim Setzen des Benutzers als Admin: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Kein Benutzer ist derzeit angemeldet.');
      }

      // E-Mail-Adresse des Benutzers abrufen
      final email = user.email;
      if (email == null) {
        throw Exception('E-Mail-Adresse nicht verfügbar.');
      }

      // Anmeldedaten mit E-Mail und altem Passwort erstellen
      final credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);

      // Benutzer neu authentifizieren
      await user.reauthenticateWithCredential(credential);

      // Passwort aktualisieren
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('Das alte Passwort ist falsch.');
      } else if (e.code == 'weak-password') {
        throw Exception('Das neue Passwort ist zu schwach.');
      } else {
        throw Exception('Fehler beim Ändern des Passworts: ${e.message}');
      }
    } catch (e) {
      throw Exception('Fehler beim Ändern des Passworts: $e');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }

  // Cache leeren
  void _clearCache() {
    _uid = null;
    _email = null;
    _name = null;
    _avatarUrl = null;
  }
}
