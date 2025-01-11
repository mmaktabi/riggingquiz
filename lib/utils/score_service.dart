import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ScoreService extends ChangeNotifier {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Methode zum Abrufen des Scores des Benutzers
  Stream<int> getScoreStream(String uid) {
    DatabaseReference scoreRef = _database.ref().child('users/$uid/score');

    return scoreRef.onValue.map((event) {
      if (event.snapshot.value != null) {
        try {
          final value = event.snapshot.value;
          if (value is int) {
            return value;
          } else if (value is String) {
            return int.tryParse(value) ?? 0;
          } else {
            return 0;
          }
        } catch (e) {
          print('Fehler beim Konvertieren des Scores: $e');
          return 0;
        }
      } else {
        return 0;
      }
    });
  }

  // Methode zum Aktualisieren des Scores des Benutzers
  Future<void> updateScore(String uid, int newScore) async {
    try {
      DatabaseReference scoreRef = _database.ref().child('users/$uid/score');
      final snapshot = await scoreRef.get();
      int currentScore = 0;

      if (snapshot.exists && snapshot.value != null) {
        final value = snapshot.value;
        if (value is int) {
          currentScore = value;
        } else if (value is double) {
          currentScore = value.toInt();
        } else if (value is String) {
          currentScore = int.tryParse(value) ?? 0;
        } else {
          print('Unbekannter Typ des aktuellen Scores: $value');
          currentScore = 0;
        }
      }

      int updatedScore = currentScore + newScore;
      await scoreRef.set(updatedScore);
    } catch (e) {
      throw Exception('Fehler beim Aktualisieren des Scores: $e');
    }
  }

  // Methode zum Hinzufügen eines Eintrags zur Historie
  Future<void> updateHistory(
      String uid, int scoreChange, String categoryName) async {
    try {
      DatabaseReference historyRef =
          _database.ref().child('users/$uid/history');
      String timestamp = DateTime.now().toIso8601String();

      // Neuen Eintrag zur Historie hinzufügen
      await historyRef.push().set({
        'score': scoreChange,
        'timestamp': timestamp,
        'categoryName': categoryName,
      });
    } catch (e) {
      throw Exception('Fehler beim Aktualisieren der Historie: $e');
    }
  }

  // Methode zum Abrufen der Historie des Benutzers
  Stream<List<Map<String, dynamic>>> getHistoryStream(String uid) {
    DatabaseReference historyRef = _database.ref().child('users/$uid/history');
    return historyRef.onValue.map((event) {
      if (event.snapshot.value != null) {
        final historyList = <Map<String, dynamic>>[];
        final historyData =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        historyData.forEach((key, value) {
          if (value is Map) {
            historyList.add({
              'id': key,
              'score': value['score'] ?? 0,
              'categoryName': value['categoryName'] ?? "Unbekannte Kategorie",
              'timestamp': value['timestamp'] ?? '',
            });
          }
        });

        return historyList;
      } else {
        return [];
      }
    });
  }
}
