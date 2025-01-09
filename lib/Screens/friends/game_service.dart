import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/score_service.dart';

class GameService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final DatabaseReference _gameSessionsRef =
      FirebaseDatabase.instance.ref().child('game_sessions');
  final DatabaseReference _categoriesRef =
      FirebaseDatabase.instance.ref().child('categories');

  // Lösche eine Spielsession
  Future<void> deleteGameSession(String gameId) async {
    try {
      await _gameSessionsRef.child(gameId).remove();
      print('Spielsession $gameId erfolgreich gelöscht.');
    } catch (e) {
      print('Fehler beim Löschen der Spielsession: $e');
      throw Exception('Fehler beim Löschen der Spielsession.');
    }
  }

  // Abrufen der Benutzerdaten
  Future<Map<String, dynamic>?> getUserDataMap(String uid) async {
    try {
      final snapshot = await _dbRef.child('users/$uid').get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print('Fehler beim Abrufen der Benutzerdaten: $e');
      return null;
    }
  }

  // Sende eine Duellanfrage
  Future<String> sendDuelRequest({
    required String requesterUid,
    required String friendUid,
    required String categoryId,
  }) async {
    try {
      if ([requesterUid, friendUid, categoryId].any((value) => value.isEmpty)) {
        throw Exception('Ungültige Parameter für Duellanfrage.');
      }

      final newGameRef = _gameSessionsRef.push();
      final gameId = newGameRef.key;

      if (gameId == null) {
        throw Exception('Fehler beim Erstellen einer neuen Spiel-ID.');
      }

      final gameData = {
        'gameId': gameId,
        'status': 'pending',
        'categoryId': categoryId,
        'requesterUid': requesterUid,
        'friendUid': friendUid,
        'timestamp': DateTime.now().toIso8601String(),
        'friendUid_status': '${friendUid}_pending',
        'requesterUid_status': '${requesterUid}_pending',
      };

      await newGameRef.set(gameData);
      print('Spielsession erfolgreich erstellt: $gameId');
      return gameId;
    } catch (e) {
      print('Fehler beim Senden der Duellanfrage: $e');
      throw Exception('Fehler beim Senden der Duellanfrage.');
    }
  }

  // Verweis auf den game_sessions-Knoten in der Realtime Database
  DatabaseReference getGameSessionsRef() {
    return _dbRef.child('game_sessions');
  }

  // Akzeptiere eine Duellanfrage
  Future<void> acceptDuelRequest(String gameId, String friendUid) async {
    try {
      await _gameSessionsRef.child(gameId).update({
        'status': 'accepted',
        'friendUid_status': '${friendUid}_accepted',
      });
      await startGameSession(gameId);
    } catch (e) {
      print('Fehler beim Akzeptieren der Duellanfrage: $e');
      throw Exception('Fehler beim Akzeptieren der Duellanfrage.');
    }
  }

  // Lehnt eine Duellanfrage ab
  Future<void> declineDuelRequest(String gameId, String friendUid) async {
    try {
      await _gameSessionsRef.child(gameId).update({
        'status': 'declined',
        'friendUid_status': '${friendUid}_declined',
      });
    } catch (e) {
      print('Fehler beim Ablehnen der Duellanfrage: $e');
      throw Exception('Fehler beim Ablehnen der Duellanfrage.');
    }
  }

  // Startet eine Spielsession
  Future<void> startGameSession(String gameId) async {
    try {
      final gameSnapshot = await _gameSessionsRef.child(gameId).get();
      if (!gameSnapshot.exists) {
        throw Exception('Spielsession $gameId nicht gefunden.');
      }

      final gameData = Map<String, dynamic>.from(gameSnapshot.value as Map);
      final categoryId = gameData['categoryId'] ?? '';
      final player1Uid = gameData['requesterUid'] ?? '';
      final player2Uid = gameData['friendUid'] ?? '';

      if ([categoryId, player1Uid, player2Uid].any((value) => value.isEmpty)) {
        throw Exception('Ungültige Daten in der Spielsession.');
      }

      final categorySnapshot = await _categoriesRef.child(categoryId).get();
      if (!categorySnapshot.exists) {
        throw Exception('Kategorie $categoryId nicht gefunden.');
      }

      final categoryData =
          Map<String, dynamic>.from(categorySnapshot.value as Map);
      final questionsMap =
          Map<String, dynamic>.from(categoryData['questions'] ?? {});
      if (questionsMap.isEmpty) {
        throw Exception('Keine Fragen in der Kategorie gefunden.');
      }

      final questionIds = questionsMap.keys.toList()..shuffle();
      final selectedQuestions = questionIds.take(2).toList();
      print('Ausgewählte Fragen: $selectedQuestions');

      await _gameSessionsRef.child(gameId).update({
        'questionIds': selectedQuestions,
        'players': {
          player1Uid: {
            'score': 0,
            'currentQuestionIndex': 0,
            'finished': false
          },
          player2Uid: {
            'score': 0,
            'currentQuestionIndex': 0,
            'finished': false
          },
        },
        'status': 'ongoing',
        'requesterUid_status': '${player1Uid}_ongoing',
        'friendUid_status': '${player2Uid}_ongoing',
      });
    } catch (e) {
      print('Fehler beim Starten der Spielsession: $e');
      throw Exception('Fehler beim Starten der Spielsession.');
    }
  }

  // Hole die aktuelle Frage
  Future<Map<String, dynamic>?> getCurrentQuestion(
      String gameId, String playerUid) async {
    try {
      final gameSnapshot = await _gameSessionsRef.child(gameId).get();
      if (!gameSnapshot.exists) {
        throw Exception('Spielsession $gameId nicht gefunden.');
      }

      final gameData = Map<String, dynamic>.from(gameSnapshot.value as Map);
      print('Aktuelle Spielsession-Daten: $gameData');

      final playersData = Map<String, dynamic>.from(gameData['players']);
      final playerData = playersData[playerUid];
      int currentQuestionIndex = playerData['currentQuestionIndex'] ?? 0;

      final questionIds = List<String>.from(gameData['questionIds'] ?? []);
      if (currentQuestionIndex >= questionIds.length) {
        print('Keine weiteren Fragen.');
        return null;
      }


      final currentQuestionId = questionIds[currentQuestionIndex];
      final categoryId = gameData['categoryId'] ?? '';
      print('Kategorie-ID: $categoryId, Frage-ID: $currentQuestionId');

      final questionSnapshot = await _categoriesRef
          .child('$categoryId/questions/$currentQuestionId')
          .get();

      if (!questionSnapshot.exists) {
        throw Exception('Frage $currentQuestionId nicht gefunden.');
      }

      final questionData =
          Map<String, dynamic>.from(questionSnapshot.value as Map);
      print('Geladene Frage: $currentQuestionIndex');

      return {
        'question': _mapToQuiz(questionData),
        'currentQuestionIndex': currentQuestionIndex,
      };
    } catch (e) {
      print('Fehler beim Abrufen der aktuellen Frage: $e');
      throw Exception('Fehler beim Abrufen der aktuellen Frage.');
    }
  }

  Future<void> submitAnswer(
      String gameId, String playerUid, bool isCorrect) async {
    try {
      final playerRef = _gameSessionsRef.child('$gameId/players/$playerUid');

      // Debugging
      print('Vor Update: ${await playerRef.get()}');

      // Aktualisierung
      await playerRef.update({
        'currentQuestionIndex': ServerValue.increment(1),
        if (isCorrect) 'score': ServerValue.increment(1),
      });

      // Verzögerung zur Synchronisation
      await Future.delayed(const Duration(milliseconds: 100));

      // Prüfe den aktuellen Status
      final gameSnapshot = await _gameSessionsRef.child(gameId).get();
      final gameData = Map<String, dynamic>.from(gameSnapshot.value as Map);
      final playersData = Map<String, dynamic>.from(gameData['players']);

      final playerData =
          Map<String, dynamic>.from(playersData[playerUid] ?? {});
      final questionIds = List<String>.from(gameData['questionIds'] ?? []);
      final currentQuestionIndex = playerData['currentQuestionIndex'];
      print('Anzahl der Fragen: ${questionIds.length}');
      print('Frage IDs: $questionIds');

      // Setze Spielerstatus auf "finished", wenn alle Fragen beantwortet sind
      if (currentQuestionIndex >= questionIds.length) {
        print('Spieler $playerUid hat alle Fragen beantwortet.');
        await playerRef.update({'finished': true});
      }

      final isFinished =
          currentQuestionIndex >= (gameData['questionIds'] as List).length;

      // Überprüfen, ob alle Spieler fertig sind
      final allFinished = (playersData..[playerUid] = {'finished': isFinished})
          .values
          .every((player) => player['finished'] == true);

      if (allFinished) {
        print('Alle Spieler sind fertig. Setze Spielstatus auf "finished".');
        await _gameSessionsRef.child(gameId).update({'status': 'finished'});
      }

      print('Nach Update: ${await playerRef.get()}');
    } catch (e) {
      print('Fehler beim Verarbeiten der Antwort: $e');
      throw Exception('Fehler beim Verarbeiten der Antwort.');
    }
  }

  // Ergebnis des Spiels
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

  // Status des Spiels
  Future<String> getGameStatus(String gameId) async {
    try {
      final gameSnapshot = await _gameSessionsRef.child(gameId).get();
      if (!gameSnapshot.exists) {
        throw Exception('Spielsession $gameId nicht gefunden.');
      }

      final gameData = Map<String, dynamic>.from(gameSnapshot.value as Map);
      return gameData['status'] ?? 'unknown';
    } catch (e) {
      print('Fehler beim Abrufen des Spielstatus: $e');
      throw Exception('Fehler beim Abrufen des Spielstatus.');
    }
  }

  Future<void> updateScoresIfNotUpdated(String gameId) async {
    final gameSessionRef = _dbRef.child('game_sessions/$gameId');
    DataSnapshot snapshot = await gameSessionRef.get();

    if (snapshot.exists) {
      Map<String, dynamic> gameData =
          Map<String, dynamic>.from(snapshot.value as Map);

      bool scoresUpdated = gameData['scoresUpdated'] ?? false;
      String status = gameData['status'] ?? 'ongoing';

      if (status == 'finished' && !scoresUpdated) {
        Map<String, dynamic> playersData =
            Map<String, dynamic>.from(gameData['players'] ?? {});
        List<String> playerUids = playersData.keys.toList();

        if (playerUids.length == 2) {
          String player1Uid = playerUids[0];
          String player2Uid = playerUids[1];

          // Default-Werte sicherstellen
          int player1Score = playersData[player1Uid]['score'] ?? 0;
          int player2Score = playersData[player2Uid]['score'] ?? 0;

          // Schäkel berechnen
          int player1TotalScore = player1Score;
          int player2TotalScore = player2Score;

          if (player1Score > player2Score) {
            player1TotalScore += 3; // Bonus für den Gewinner
          } else if (player2Score > player1Score) {
            player2TotalScore += 3;
          }
          await _updateUserScoreAndHistory(
              player1Uid, player1TotalScore, "RiggingDuell");
          await _updateUserScoreAndHistory(
              player2Uid, player2TotalScore, "RiggingDuell");

          // Setze `scoresUpdated` auf true
          await gameSessionRef.update({'scoresUpdated': true});
        } else {
          print('Fehler: Ungültige Spieleranzahl.');
        }
      }
    }
  }

  Future<void> _updateUserScoreAndHistory(
      String uid, int totalScore, String gameType) async {
    final scoreService = ScoreService();
    await scoreService.updateScore(uid, totalScore);
    await scoreService.updateHistory(uid, totalScore, gameType);
  }

  // Mapping der Quiz-Daten
  Quiz _mapToQuiz(Map<String, dynamic> data) {
    return Quiz(
      question: data['question'] ?? '',
      hint: data['hint'] ?? '',
      questionType: QuizQuestionType.values.firstWhere(
        (type) => type.name == data['questionType'],
        orElse: () => QuizQuestionType.multipleChoice,
      ),
      difficulty: QuizDifficulty.values.firstWhere(
        (level) => level.name == data['difficulty'],
        orElse: () => QuizDifficulty.beginner,
      ),
      multiSelect: (data['multiSelect'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      matchingPairs: (data['matchingPairs'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          [],
      imageUrl: data['imageUrl'],
      score: data['score'] is int ? data['score'] : 1,
    );
  }
}
