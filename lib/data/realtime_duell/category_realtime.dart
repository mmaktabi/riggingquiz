import 'package:firebase_database/firebase_database.dart';

class CategoryRealtime {
  final DatabaseReference _categoriesRef =
      FirebaseDatabase.instance.ref().child('categories');

  Future<Map<String, dynamic>?> getQuestion(
      String categoryId, String questionId) async {
    try {
      final questionSnapshot =
          await _categoriesRef.child('$categoryId/questions/$questionId').get();

      if (!questionSnapshot.exists) {
        throw Exception('Frage $questionId nicht gefunden.');
      }

      return Map<String, dynamic>.from(questionSnapshot.value as Map);
    } catch (e) {
      print('Fehler beim Abrufen der Frage: $e');
      throw Exception('Fehler beim Abrufen der Frage.');
    }
  }

  Future<List<String>> getQuestionIds(String categoryId) async {
    try {
      final categorySnapshot = await _categoriesRef.child(categoryId).get();

      if (!categorySnapshot.exists) {
        throw Exception('Kategorie $categoryId nicht gefunden.');
      }

      final categoryData =
          Map<String, dynamic>.from(categorySnapshot.value as Map);
      final questionsMap =
          Map<String, dynamic>.from(categoryData['questions'] ?? {});
      return questionsMap.keys.toList()..shuffle();
    } catch (e) {
      print('Fehler beim Abrufen der Fragen: $e');
      throw Exception('Fehler beim Abrufen der Fragen.');
    }
  }
}
