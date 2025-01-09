import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/constant.dart';

class QuizService {
  final FirebaseDatabase database = FirebaseDatabase.instance;

  // Methode zum Abrufen von 7 zufälligen Fragen aus einer Kategorie
  Future<List<Quiz>> getRandomQuestions(String categoryId) async {
    final DatabaseReference questionsRef =
    database.ref().child('categories/$categoryId/questions');
    final snapshot = await questionsRef.get();

    if (snapshot.exists) {
      final Map<String, dynamic> questionsData =
      Map<String, dynamic>.from(snapshot.value as Map);
      List<String> allQuestionKeys = questionsData.keys.toList();

      // Wenn es weniger als 7 Fragen gibt, laden wir alle
      if (allQuestionKeys.length <= 7) {
        return _loadQuestionsByKeys(categoryId, allQuestionKeys);
      }

      // Zufällige Auswahl von 7 Fragen-IDs
      allQuestionKeys.shuffle();
      List<String> selectedKeys = allQuestionKeys.take(7).toList();

      // Lade nur die ausgewählten Fragen
      return _loadQuestionsByKeys(categoryId, selectedKeys);
    }

    // Wenn keine Fragen gefunden wurden, gib eine leere Liste zurück
    return [];
  }

  // Hilfsmethode zum Laden der Fragen anhand einer Liste von IDs
  Future<List<Quiz>> _loadQuestionsByKeys(
      String categoryId, List<String> keys) async {
    List<Quiz> questions = [];
    for (String key in keys) {
      final snapshot = await database
          .ref()
          .child('categories/$categoryId/questions/$key')
          .get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        questions.add(_mapToQuiz(data));
      }
    }
    return questions;
  }

  // Methode zum Abrufen aller Kategorien
  // Methode zum Abrufen aller Kategorien
  Future<List<QuizCategory>> getCategories() async {
    final snapshot = await database.ref().child('categories').get();
    if (snapshot.exists) {
      final Map<String, dynamic> categoriesData =
      Map<String, dynamic>.from(snapshot.value as Map);
      List<QuizCategory> categories = [];

      for (var entry in categoriesData.entries) {
        final String categoryId = entry.key; // Hole die Kategorie-ID
        final data = Map<String, dynamic>.from(entry.value);

        // Lade 7 zufällige Fragen für jede Kategorie
        final List<Quiz> quizzes = await getRandomQuestions(categoryId);

        categories.add(QuizCategory(
          id: categoryId, // Kategorie-ID hinzufügen
          categoryColor: data['categoryColor'] != null
              ? Color(int.parse(data['categoryColor'].substring(1), radix: 16))
              : QColors.primaryColor, // Standardfarbe, falls keine vorhanden
          name: data['name'] ?? 'Unbekannt',
          description: data['description'] ?? 'Keine Beschreibung verfügbar',
          iconImage: data['iconImage'] ?? '',
          difficulty: QuizDifficulty.values.firstWhere(
                (level) => level.name == data['difficulty'],
            orElse: () => QuizDifficulty.beginner,
          ),
          quizzes: quizzes,
        ));
      }

      return categories;
    }
    return [];
  }

  // Methode zum Abrufen einer einzelnen Frage aus einer Kategorie
  Future<Quiz?> getQuestion(String categoryId, String questionId) async {
    final snapshot = await database
        .ref()
        .child('categories/$categoryId/questions/$questionId')
        .get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return _mapToQuiz(data);
    }
    return null;
  }

  // Methode zum Hinzufügen einer neuen Kategorie
  Future<void> addCategory(QuizCategory category) async {
    final DatabaseReference categoryRef =
    database.ref().child('categories').push();
    await categoryRef.set(_categoryToMap(category));
  }

  // Methode zum Aktualisieren einer Kategorie
  Future<void> updateCategory(String categoryId, QuizCategory category) async {
    final DatabaseReference categoryRef =
    database.ref().child('categories/$categoryId');
    await categoryRef.update(_categoryToMap(category));
  }

  // Methode zum Löschen einer Kategorie
  Future<void> deleteCategory(String categoryId) async {
    final DatabaseReference categoryRef =
    database.ref().child('categories/$categoryId');
    await categoryRef.remove();
  }

  // Methode zum Hinzufügen einer neuen Frage zu einer Kategorie
  Future<void> addQuestionToCategory(String categoryId, Quiz quiz) async {
    final DatabaseReference questionRef =
    database.ref().child('categories/$categoryId/questions').push();
    await questionRef.set(_quizToMap(quiz));
  }

  // Methode zum Aktualisieren einer Frage
  Future<void> updateQuestion(
      String categoryId, String questionId, Quiz quiz) async {
    final DatabaseReference questionRef =
    database.ref().child('categories/$categoryId/questions/$questionId');
    await questionRef.update(_quizToMap(quiz));
  }

  // Methode zum Löschen einer Frage
  Future<void> deleteQuestion(String categoryId, String questionId) async {
    final DatabaseReference questionRef =
    database.ref().child('categories/$categoryId/questions/$questionId');
    await questionRef.remove();
  }

  // Hilfsmethode zur Umwandlung von Daten in ein Quiz-Objekt
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
    );
  }

  // Hilfsmethoden zur Konvertierung der Objekte in Maps
  Map<String, dynamic> _categoryToMap(QuizCategory category) {
    print(category.categoryColor);
    return {
      'name': category.name,
      'description': category.description,
      'iconImage': category.iconImage,
      'difficulty': category.difficulty.name,
      'categoryColor':
      '#${category.categoryColor.value.toRadixString(16).padLeft(8, '0')}', // Farbe als Hex-String speichern
    };
  }

  Map<String, dynamic> _quizToMap(Quiz quiz) {
    return {
      'question': quiz.question,
      'hint': quiz.hint,
      'questionType': quiz.questionType.name,
      'difficulty': quiz.difficulty.name,
      'matchingPairs': quiz.matchingPairs,
      'multiSelect': quiz.multiSelect,
      'imageUrl': quiz.imageUrl,
    };
  }
}
