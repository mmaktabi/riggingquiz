import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rigging_quiz/game_utils/quiz_manager.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/points_line.dart';

class DuelResultScreen extends StatefulWidget {
  final String gameId;
  final String playerUid;

  const DuelResultScreen({
    super.key,
    required this.gameId,
    required this.playerUid,
  });

  @override
  _DuelResultScreenState createState() => _DuelResultScreenState();
}

class _DuelResultScreenState extends State<DuelResultScreen> {
  Map<String, dynamic> results = {};
  bool isLoading = true;
  String message = '';
  String gameStatus = 'ongoing'; // Standardstatus
  bool _scoreUpdated = false; // Um Mehrfachaktualisierungen zu vermeiden
  int correctAnswers = 0;
  int wrongAnswers = 0;
  int totalQuestions = 0;
  int schaekelEarned = 0;

  @override
  void initState() {
    super.initState();
    loadResults();
    _listenForGameFinish();
  }

  @override
  void dispose() {
    GameManager.instance.stopListeningToGameStatus();
    super.dispose();
  }

  Future<void> loadResults() async {
    try {
      setState(() {
        isLoading = true;
      });

      gameStatus = await GameManager.instance.getGameStatus(widget.gameId);

      if (gameStatus != 'finished') {
        return;
      }

      final gameData = await GameManager.instance.getGameResult(widget.gameId);
      results = Map<String, dynamic>.from(gameData);

      if (!(results['scoresUpdated'] ?? false)) {
        await GameManager.instance.updateScoresIfNotUpdated(widget.gameId);

        // Erneut die Ergebnisse abrufen
        results = await GameManager.instance.getGameResult(widget.gameId);
      }

      _synchronizeResults();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Ergebnisse: $e')),
      );
    }
  }

  void _synchronizeResults() {
    final String opponentUid = results.keys.firstWhere(
          (uid) => uid != widget.playerUid,
      orElse: () => '',
    );

    final Map<String, dynamic> playerData =
    Map<String, dynamic>.from(results[widget.playerUid] ?? {});
    final Map<String, dynamic> opponentData =
    Map<String, dynamic>.from(results[opponentUid] ?? {});

    correctAnswers = playerData['correctAnswers'] ?? 0;
    wrongAnswers = playerData['wrongAnswers'] ?? 0;
    totalQuestions = correctAnswers + wrongAnswers;

    int playerScore = playerData['score'] ?? 0;
    int opponentScore = opponentData['score'] ?? 0;

    if (playerScore > opponentScore) {
      message = 'Herzlichen Glückwunsch! Du hast gewonnen!';
      schaekelEarned = playerScore;
    } else if (playerScore < opponentScore) {
      message = 'Leider hast du verloren.';
      schaekelEarned = playerScore;
    } else {
      message = 'Unentschieden!';
      schaekelEarned = playerScore;
    }
  }

  void _listenForGameFinish() {
    GameManager.instance.startListeningToGameStatus(
      gameId: widget.gameId,
      onGameStatusChanged: (status, _) {
        if (status == 'finished') {
          loadResults();
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return QLayout(
      child: isLoading
          ? QWidgets().progressIndicator
          : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (gameStatus == 'finished') ...[
            _buildTopDesign(),
            const SizedBox(height: 20),
            QText(
              text: message,
              weight: FontWeight.w500,
              fontSize: 20,
              color: QColors.primaryColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PointsLine(
              punkte: correctAnswers * 10, // Angenommen 10 Punkte pro korrekte Antwort
              maximalPunkte: totalQuestions * 10,
              schaekel: schaekelEarned,
            ),
            const SizedBox(height: 20),
          ] else ...[
            Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                const QText(
                  text: 'Warte, bis dein Gegner fertig ist.',
                  weight: FontWeight.w500,
                  fontSize: 20,
                  color: QColors.primaryColor,
                ),
                const SizedBox(height: 20),
                QWidgets().progressIndicator,
              ],
            ),
          ],
          const SizedBox(height: 40),
          _buildScoreCard(),
          const SizedBox(height: 40),
          QButton(
            buttonText: 'Zurück zum Hauptmenü',
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopDesign() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: QColors.primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const QText(
            text: 'Spielergebnisse',
            weight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          const CircleAvatar(
            radius: 50,
            backgroundColor: QColors.primaryColor,
            child: Icon(
              Icons.emoji_events,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          QText(
            text: 'Du hast $schaekelEarned Schäkel erhalten!',
            fontSize: 16,
            color: Colors.white,
            textAlign: TextAlign.center,
          ),
          if (message.contains('gewonnen'))
            const QText(
              text: 'Zusätzliche 5 Schäkel für den Sieg!',
              fontSize: 16,
              color: QColors.accentColor,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    if (results.isEmpty || gameStatus != 'finished') {
      return const Center(
        child: QText(
          text: "Die Ergebnisse werden angezeigt, sobald beide Spieler fertig sind.",
          fontSize: 16,
          color: QColors.primaryColor,
        ),
      );
    }

    String opponentUid = results.keys.firstWhere(
          (uid) => uid != widget.playerUid,
      orElse: () => '',
    );

    int playerScore = results[widget.playerUid]?['score'] ?? 0;
    int opponentScore = results[opponentUid]?['score'] ?? 0;

    return Column(
      children: [
        _buildPlayerScoreRow('Du', playerScore, isCurrentUser: true),
        const SizedBox(height: 20),
        _buildPlayerScoreRow('Gegner', opponentScore),
      ],
    );
  }

  Widget _buildPlayerScoreRow(String name, int score,
      {bool isCurrentUser = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isCurrentUser ? Icons.person : Icons.person_outline,
          color: QColors.primaryColor,
          size: 40,
        ),
        const SizedBox(width: 10),
        QText(
          text: name,
          fontSize: 20,
          weight: FontWeight.bold,
          color: Colors.black,
        ),
        const SizedBox(width: 20),
        QText(
          text: '$score Schäkel.',
          fontSize: 20,
          weight: FontWeight.w500,
          color: Colors.black,
        ),
      ],
    );
  }
}
