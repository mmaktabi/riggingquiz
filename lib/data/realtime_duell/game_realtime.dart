import 'package:firebase_database/firebase_database.dart';

class GameRealtime {
  final DatabaseReference _gameSessionsRef =
      FirebaseDatabase.instance.ref().child('game_sessions');

  Future<void> createGameSession(
      String gameId, Map<String, dynamic> data) async {
    try {
      await _gameSessionsRef.child(gameId).set(data);
    } catch (e) {
      print('Fehler beim Erstellen der Spielsession: $e');
      throw Exception('Fehler beim Erstellen der Spielsession.');
    }
  }

  Future<void> updateGameSession(
      String gameId, Map<String, dynamic> updates) async {
    try {
      await _gameSessionsRef.child(gameId).update(updates);
    } catch (e) {
      print('Fehler beim Aktualisieren der Spielsession: $e');
      throw Exception('Fehler beim Aktualisieren der Spielsession.');
    }
  }

  Future<Map<String, dynamic>?> getGameSession(String gameId) async {
    try {
      final gameSnapshot = await _gameSessionsRef.child(gameId).get();
      if (!gameSnapshot.exists) {
        throw Exception('Spielsession $gameId nicht gefunden.');
      }
      return Map<String, dynamic>.from(gameSnapshot.value as Map);
    } catch (e) {
      print('Fehler beim Abrufen der Spielsession: $e');
      throw Exception('Fehler beim Abrufen der Spielsession.');
    }
  }

  Future<void> deleteGameSession(String gameId) async {
    try {
      await _gameSessionsRef.child(gameId).remove();
    } catch (e) {
      print('Fehler beim Löschen der Spielsession: $e');
      throw Exception('Fehler beim Löschen der Spielsession.');
    }
  }

  Future<void> updatePlayer(
      String gameId, String playerUid, Map<String, dynamic> updates) async {
    try {
      await _gameSessionsRef
          .child('$gameId/players/$playerUid')
          .update(updates);
    } catch (e) {
      print('Fehler beim Aktualisieren des Spielers: $e');
      throw Exception('Fehler beim Aktualisieren des Spielers.');
    }
  }
}
