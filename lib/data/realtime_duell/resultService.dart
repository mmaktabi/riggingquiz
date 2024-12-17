import 'package:firebase_database/firebase_database.dart';
import 'package:rigging_quiz/utils/score_service.dart';

class ResultService {
  final DatabaseReference _gameSessionsRef =
      FirebaseDatabase.instance.ref().child('game_sessions');

  Future<Map<String, dynamic>> getGameResult(String gameId) async {
    try {
      final gameSnapshot = await _gameSessionsRef.child(gameId).get();
      if (!gameSnapshot.exists) {
        throw Exception('Spielsession $gameId nicht gefunden.');
      }

      final gameData = Map<String, dynamic>.from(gameSnapshot.value as Map);
      if (gameData['status'] != 'finished') {
        throw Exception('Spiel ist noch nicht beendet.');
      }

      return Map<String, dynamic>.from(gameData['players']);
    } catch (e) {
      print('Fehler beim Abrufen des Spielergebnisses: $e');
      throw Exception('Fehler beim Abrufen des Spielergebnisses.');
    }
  }

  Future<void> updateScoresIfNotUpdated(String gameId) async {
    final gameSessionRef =
        FirebaseDatabase.instance.ref().child('game_sessions/$gameId');
    DataSnapshot snapshot = await gameSessionRef.get();

    if (snapshot.exists) {
      final gameData = Map<String, dynamic>.from(snapshot.value as Map);
      final scoresUpdated = gameData['scoresUpdated'] ?? false;

      if (scoresUpdated) return;

      final playersData = Map<String, dynamic>.from(gameData['players'] ?? {});
      if (playersData.keys.length != 2) {
        throw Exception('Ungültige Spieleranzahl in der Session.');
      }

      final playerUids = playersData.keys.toList();
      final player1Uid = playerUids[0];
      final player2Uid = playerUids[1];

      final player1Score = playersData[player1Uid]['score'] ?? 0;
      final player2Score = playersData[player2Uid]['score'] ?? 0;

      int player1Total = player1Score + (player1Score > player2Score ? 5 : 0);
      int player2Total = player2Score + (player2Score > player1Score ? 5 : 0);

      await _updateUserScoreAndHistory(player1Uid, player1Total);
      await _updateUserScoreAndHistory(player2Uid, player2Total);

      await gameSessionRef.update({'scoresUpdated': true});
    }
  }

  Future<void> _updateUserScoreAndHistory(String uid, int totalScore) async {
    final scoreService = ScoreService();
    await scoreService.updateScore(uid, totalScore);
    await scoreService.updateHistory(uid, totalScore, "Duell");
  }
}
