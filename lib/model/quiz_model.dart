import 'package:flutter/material.dart';

class Quiz {
  final String question;
  final String hint;
  final String? imageUrl;
  final QuizQuestionType questionType;
  final QuizDifficulty difficulty;
  final List<Map<String, String>>?
      matchingPairs; // Modified field for matching questions
  final List<Map<String, dynamic>>?
      multiSelect; // Modified field for matching questions
  final int score; // Neues Feld für Punkte
  final int index; // Neues Feld für Punkte

  Quiz({
    required this.question,
    this.matchingPairs,
    this.multiSelect,
    this.imageUrl,
    required this.hint,
    required this.questionType,
    required this.difficulty,
    this.score = 10,
    this.index = 0,
  });
  // Factory method to create a Quiz object from a Map
  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      question: map['question'] ?? '',
      hint: map['hint'] ?? '',
      imageUrl: map['imageUrl'],
      questionType: QuizQuestionType.values
          .firstWhere((type) => type.name == map['questionType']),
      difficulty: QuizDifficulty.values
          .firstWhere((level) => level.name == map['difficulty']),
      matchingPairs: List<Map<String, String>>.from(map['matchingPairs'] ?? []),
      multiSelect: List<Map<String, dynamic>>.from(map['multiSelect'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'matchingPairs': matchingPairs
          ?.map((pair) => {'left': pair['left'], 'right': pair['right']})
          .toList(),
      'hint': hint,
      'questionType': questionType.name,
      'difficulty': difficulty.name,
    };
  }
}

class QuizCategory {
  final String? id;
  final String name;
  final String description;
  final String iconImage;
  final QuizDifficulty difficulty;
  final List<Quiz> quizzes;
  final Color categoryColor; // Neue Farbeigenschaft

  QuizCategory({
    this.id,
    required this.name,
    required this.description,
    required this.iconImage,
    required this.difficulty,
    required this.quizzes,
    required this.categoryColor,
  });
}

enum QuizDifficulty {
  beginner,
  medium,
  advanced,
}

enum QuizQuestionType { multipleChoice, matching }

class QuestionModel {
  String? question;
  Map<String, bool>? answers; // Umbenennung für mehr Klarheit
  int points;
  QuizQuestionType questionType;

  QuestionModel(this.question, this.answers, this.points, this.questionType);
}

class ResultModel {
  int totalPoints;
  int correctAnswers;
  int wrongAnswers;
  int schaekel;

  ResultModel({
    required this.totalPoints,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.schaekel,
  });
}
