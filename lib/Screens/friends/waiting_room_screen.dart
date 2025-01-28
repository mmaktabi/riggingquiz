import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/Screens/friends/duel_game_screen.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/game_utils/quiz_manager.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/avatar.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class WaitingRoomScreen extends StatefulWidget {
  final String gameId;
  final String friendUid;

  const WaitingRoomScreen({
    super.key,
    required this.gameId,
    required this.friendUid,
  });

  @override
  _WaitingRoomScreenState createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  Map<String, dynamic>? currentUserData;
  Map<String, dynamic>? opponentUserData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _listenForGameStart();
  }

  Future<void> _fetchUserData() async {
    try {
      final userService = Provider.of<UserService>(context, listen: false);
      final userUid = userService.uid!;
      final friendUid = widget.friendUid;

      currentUserData = await GameManager.instance.fetchUserData(userUid);
      opponentUserData = await GameManager.instance.fetchUserData(friendUid);

      setState(() {
        isLoading = false;
      });

      if (currentUserData == null || opponentUserData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(currentUserData == null
                ? 'Deine Benutzerdaten konnten nicht geladen werden.'
                : 'Die Benutzerdaten des Gegners konnten nicht geladen werden.'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _listenForGameStart() {
    GameManager.instance.startListeningToGameStatus(
      gameId: widget.gameId,
      onGameStatusChanged: (status, gameData) {
        if (status == 'ongoing') {
          final userService = Provider.of<UserService>(context, listen: false);
          final userUid = userService.uid!;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DuelGameScreen(
                gameId: widget.gameId,
                playerUid: userUid,
              ),
            ),
          );
        } else if (status == 'declined') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Dein Gegner hat das Spiel abgelehnt.')),
          );
          Navigator.pop(context);
        }
      },
    );
  }


  Future<void> _cancelGame() async {
    await GameManager.instance.deleteGameSession(widget.gameId);
    Navigator.pop(context);
  }

  Widget _buildUserInfo(Map<String, dynamic>? userData,
      {bool isCurrentUser = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          child: userData?['avatarUrl'] != null
              ? qAvatar(avatar: userData?['avatarUrl'])
              : null,
        ),
        const SizedBox(height: 10),
        QText(
          text: isCurrentUser ? 'Du' : userData?['name'] ?? 'Spieler',
          fontSize: 16,
          weight: FontWeight.bold,
          color: QColors.primaryColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return QLayout(
      child: isLoading
          ? QWidgets().progressIndicator
          : (currentUserData != null && opponentUserData != null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildUserInfo(currentUserData, isCurrentUser: true),
                        const SizedBox(width: 20),
                        const QText(
                          text: 'VS',
                          fontSize: 24,
                          weight: FontWeight.bold,
                          color: QColors.primaryColor,
                        ),
                        const SizedBox(width: 20),
                        _buildUserInfo(opponentUserData),
                      ],
                    ),
                    const SizedBox(height: 40),
                    QText(
                      text:
                          'Warte auf ${opponentUserData?['name'] ?? 'den anderen Spieler'}...',
                      fontSize: 18,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    QButton(
                      buttonText: 'Abbrechen',
                      onPressed: _cancelGame,
                    ),
                  ],
                )
              : const Center(
                  child: Text('Fehler beim Laden der Benutzerdaten.')),
    );
  }
}
