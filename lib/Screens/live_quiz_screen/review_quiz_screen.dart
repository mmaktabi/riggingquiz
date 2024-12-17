import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rigging_quiz/Screens/home_page.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/points_line.dart';

class ReviewQuizScreen extends StatelessWidget {
  final ResultModel result; // ResultModel für die Ergebnisse
  final List<Quiz> questions; // Liste der Fragen, die angezeigt werden sollen
  final List<List<int>>
      selectedAnswersPerQuestion; // Liste der ausgewählten Antworten

  const ReviewQuizScreen({
    super.key,
    required this.result,
    required this.questions,
    required this.selectedAnswersPerQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return QLayout(
      showScore: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildQuizSummary(),
            const SizedBox(height: 16),
            PointsLine(
              punkte: result.correctAnswers,
              maximalPunkte: 70,
              schaekel: result.correctAnswers,
            ),
            QButton(
              weight: FontWeight.bold,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              buttonText: 'Noch mehr spielen',
            ),
            _buildSectionTitle('Deine Antworten'),
            const SizedBox(height: 16),
            _buildAnswersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: QText(
        text: title,
        color: QColors.accentColor,
        fontSize: 18,
        weight: FontWeight.w500,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSectionTitle('DEIN ERGEBNIS'),
      ],
    );
  }

  Widget _buildQuizSummary() {
    return Stack(
      children: [
        _buildQuizCompletionDetails(),
      ],
    );
  }

  Widget _buildQuizCompletionDetails() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: const BoxDecoration(
          color: QColors.secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 50.0,
                  lineWidth: 10.0,
                  percent: result.correctAnswers /
                      (result.correctAnswers + result.wrongAnswers),
                  animation: true,
                  progressColor: QColors.accentColor,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: QText(
                    text: '${result.correctAnswers}/7',
                    weight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(width: 20),
                QText(
                  text:
                      'Du hast ${result.correctAnswers}\nvon ${result.correctAnswers + result.wrongAnswers}\nFragen geantwortet',
                  weight: FontWeight.w500,
                  fontSize: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswersList() {
    return Container(
      decoration: BoxDecoration(
        color: QColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return _buildAnswerItem(questions[index], index + 1);
          },
        ),
      ),
    );
  }

  Widget _buildAnswerItem(Quiz question, int questionNumber) {
    int questionIndex = questionNumber - 1;
    List<int> selectedAnswersForQuestion =
        selectedAnswersPerQuestion[questionIndex];

    // Liste der Antworten erstellen
    List<Map<String, dynamic>> answerEntries = question.multiSelect ?? [];

    // Überprüfen, ob die Frage richtig beantwortet wurde
    bool isQuestionCorrect = true;
    for (var entry in answerEntries.asMap().entries) {
      int answerIndex = entry.key;
      bool isCorrect = entry.value['value'];
      bool isSelected = selectedAnswersForQuestion.contains(answerIndex);

      if (isCorrect && !isSelected) {
        isQuestionCorrect = false;
        break;
      }
      if (!isCorrect && isSelected) {
        isQuestionCorrect = false;
        break;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: QColors.primaryColor,
                radius: 16,
                child: QText(
                  text: questionNumber.toString(),
                  weight: FontWeight.w500,
                  fontSize: 16,
                  color: QColors.accentColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QText(
                  text: question.question,
                  weight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Anzeige der einzelnen Antworten
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: answerEntries.asMap().entries.map((entry) {
              int answerIndex = entry.key;
              String answerText = entry.value['label'];
              bool isCorrect = entry.value['value'];
              bool isSelected =
                  selectedAnswersForQuestion.contains(answerIndex);

              Color backgroundColor = Colors.transparent;
              IconData? icon;

              if (isSelected) {
                if (isCorrect) {
                  backgroundColor = Colors.green[100]!;
                  icon = Icons.check_circle;
                } else {
                  backgroundColor = Colors.red[100]!;
                  icon = Icons.cancel;
                }
              } else {
                if (!isQuestionCorrect && isCorrect) {
                  backgroundColor = Colors.blue[100]!;
                  icon = Icons.info;
                }
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: QText(
                        text: answerText,
                        weight: FontWeight.w400,
                        fontSize: 14,
                        color: ColorsHelpers.grey2,
                      ),
                    ),
                    if (icon != null)
                      Icon(
                        icon,
                        color: isCorrect
                            ? (isSelected ? Colors.green : Colors.blue)
                            : Colors.red,
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
