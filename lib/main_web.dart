import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/Screens/friends/duel_game_screen.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/Screens/friends/game_service.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:universal_html/js.dart';

class CombinedProvider with ChangeNotifier {
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final StreamSubscription<User?> _authStateChangesSubscription;
  StreamSubscription<DatabaseEvent>? _duelRequestSubscription;
  final GameService _gameService = GameService();

  final UserService userService; // Benutzerabhängigkeit wird injiziert
  final BuildContext context; // Benutzerabhängigkeit wird injiziert

  CombinedProvider({required this.userService,required this.context, }) {
    // Abonniere den Authentifizierungsstatus
    _authStateChangesSubscription = _auth.authStateChanges().listen((User? user) {
      _user = user;

      if (_user != null) {
        listenForDuelRequests(context);
      } else {
        _duelRequestSubscription?.cancel();
      }

      notifyListeners();
    });
  }

  User? get currentUser => _user;

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
  /// Startet das Abhören von Duel-Anfragen.
  void listenForDuelRequests(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    final userUid = userService.uid;

    if (userUid == null) return;

    _duelRequestSubscription = FirebaseDatabase.instance
        .ref()
        .child('game_sessions')
        .orderByChild('friendUid')
        .equalTo(userUid)
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        for (final child in event.snapshot.children) {
          final data = Map<String, dynamic>.from(child.value as Map);
          if (data['status'] == 'pending') {
            _showDuelRequestDialog(
              context: context,
              fromUid: data['requesterUid'],
              categoryId: data['categoryId'],
              gameId: data['gameId'],
            );
          }
        }
      }
    }, onError: (error) {
      debugPrint("Fehler beim Abonnieren des Streams: $error");
    });
  }
  Future<void> _showDuelRequestDialog({
    required BuildContext context,
    required String fromUid,
    required String categoryId,
    required String gameId,
  }) async {
    if (!context.mounted) return;

    // Lade Benutzerdaten des Anfragenden
    final userRef = FirebaseDatabase.instance.ref().child('users/$fromUid');
    final userSnapshot = await userRef.get();

    if (!userSnapshot.exists) {
      debugPrint("User-Daten für $fromUid nicht gefunden.");
      return;
    }

    final userData = Map<String, dynamic>.from(userSnapshot.value as Map);
    String requesterName = userData['name'] ?? 'Unknown User';
    String requesterAvatar = userData['avatarUrl'] ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const QText(text: 'Spiel Anfrage'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  child: requesterAvatar.isEmpty
                      ? const Icon(Icons.person)
                  // Hier kannst du dein Avatar-Widget einbauen
                      : Text(requesterAvatar[0].toUpperCase()),
                ),
                const SizedBox(height: 10),
                QText(
                  text:
                  '$requesterName glaubt, er hätte eine Chance gegen dich. Beweise das Gegenteil und zeig, was in dir steckt! Gewinne das Duell und sichere dir 5 zusätzliche Schäkel!',
                ),
              ],
            ),
          ),
          actions: [
            QButton(
              onPressed: () async {
                final userService = Provider.of<UserService>(context, listen: false);
                await _gameService.declineDuelRequest(gameId, userService.uid!);
                Navigator.of(dialogContext).pop();
              },
              buttonText: "Ablehnen",
            ),
            QButton(
              buttonText: "Annehmen",
              onPressed: () async {
                final userService = Provider.of<UserService>(context, listen: false);
                await _gameService.acceptDuelRequest(gameId, userService.uid!);
                await _gameService.startGameSession(gameId);
                Navigator.of(dialogContext).pop();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DuelGameScreen(
                      gameId: gameId,
                      playerUid: userService.uid ?? "",
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _authStateChangesSubscription.cancel();
    _duelRequestSubscription?.cancel();
    super.dispose();
  }
}
