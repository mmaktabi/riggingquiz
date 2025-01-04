import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/Screens/friends/duel_game_screen.dart';
import 'package:rigging_quiz/Screens/friends/game_service.dart';
import 'package:rigging_quiz/Screens/friends/find_friends.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/images.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/avatar.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/carousel_quizes.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/score/list_history.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    listenForDuelRequests();
  }

  StreamSubscription<DatabaseEvent>? _duelRequestSubscription;
  final GameService _gameService = GameService();

  void listenForDuelRequests() {
    final userService = Provider.of<UserService>(context, listen: false);
    final userUid = userService.uid;

    if (userUid == null) return;

    // Listen to 'game_sessions' where 'friendUid' is equal to current user and status is 'pending'
    _duelRequestSubscription = FirebaseDatabase.instance
        .ref()
        .child('game_sessions')
        .orderByChild('friendUid')
        .equalTo(userUid)
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final children = event.snapshot.children;
        for (final child in children) {
          final data = Map<String, dynamic>.from(child.value as Map);

          if (data['status'] == 'pending') {
            _showDuelRequestDialog(
              fromUid: data['requesterUid'],
              categoryId: data['categoryId'],
              gameId: data['gameId'],
            );
          }
        }
      }
    }, onError: (error) {
      debugPrint("Fehler beim Abonnieren des Streams: $error");
    });
  }

  void _showDuelRequestDialog({
    required String fromUid,
    required String categoryId,
    required String gameId,
  }) async {
    if (!mounted) return; // Überprüfen Sie, ob das Widget noch montiert ist

    // Load user data of the requester
    final userRef = FirebaseDatabase.instance.ref().child('users/$fromUid');
    final userSnapshot = await userRef.get();

    if (!userSnapshot.exists) {
      print("User data for $fromUid not found.");
      return;
    }

    final userData = Map<String, dynamic>.from(userSnapshot.value as Map);

    String requesterName = userData['name'] ?? 'Unknown User';
    String requesterAvatar = userData['avatarUrl'] ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const QText(text: 'Spiel Anfrage'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  child: requesterAvatar.isEmpty
                      ? const Icon(Icons.person)
                      : qAvatar(avatar: requesterAvatar),
                ),
                const SizedBox(height: 10),
                QText(
                    text:
                        '$requesterName glaubt, er hätte eine Chance gegen dich. Beweise das Gegenteil und zeig, was in dir steckt! Gewinne das Duell und sichere dir 5 zusätzliche Schäkel!'),
              ],
            ),
          ),
          actions: [
            QButton(
              onPressed: () async {
                final userService =
                    Provider.of<UserService>(context, listen: false);
                await _gameService.declineDuelRequest(gameId, userService.uid!);
                Navigator.of(context).pop();
              },
              buttonText: "Ablehnen",
            ),
            QButton(
              buttonText: "Annehmen",
              onPressed: () async {
                final userService =
                    Provider.of<UserService>(context, listen: false);
                await _gameService.acceptDuelRequest(gameId, userService.uid!);
                // Start game session
                await _gameService.startGameSession(gameId);
                Navigator.of(context).pop();

                // Navigate to DuelGameScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DuelGameScreen(
                      gameId: gameId,
                      playerUid: userService.uid ?? "",
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _duelRequestSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    return QLayout(
      showScore: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Letztes Spiel Abschnitt
            Container(
              decoration: BoxDecoration(
                color: QColors.primaryColor.withOpacity(0.5),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      QText(
                          text: 'SPIELE JETZT',
                          color: QColors.white,
                          weight: FontWeight.w500,
                          fontSize: 14,
                          textAlign: TextAlign.center,
                          letterSpacing: 4),
                      SizedBox(height: 8),
                      QText(
                          text:
                              'Erhalte einen zusätzlichen Schäkel, wenn du alle Fragen richtig beantwortest.',
                          fontSize: 13,
                          textAlign: TextAlign.center,
                          weight: FontWeight.w500,
                          color: QColors.backgroundColor)
                    ],
                  ),
                ),
              ),
            ),
        
            const Padding(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              child: CarouselQuizes(),
            ),
            // Duell mit Freunden Abschnitt
            Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 49, 94, 0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                )
              ], color: QColors.secondaryColor),
              child: Stack(
                children: [
                  Positioned(
                      left: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20)),
                        child: SvgPicture.asset(
                          Images.ovalWithOutlineBottomHomeScreen,
                          width: 160,
                        ),
                      )),
                  Positioned(
                      right: 1,
                      top: 0,
                      child: RotationTransition(
                        turns: const AlwaysStoppedAnimation(180 / 360),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20)),
                          child: SvgPicture.asset(
                            Images.ovalWithOutlineBottomHomeScreen,
                            width: 160,
                          ),
                        ),
                      )),
                  Positioned(
                      left: 16,
                      top: 16,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20)),
                        child: SvgPicture.asset(
                          QImages.pana,
                          height: 120,
                        ),
                      )),
                  Positioned(
                      right: 15,
                      bottom: 42,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20)),
                        child: SvgPicture.asset(
                          QImages.amico,
                          width: 120,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: const QText(
                                  text: 'Gemeinsam',
                                  weight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 5),
                            ),
                            const QText(
                                text: 'Lade deine Freunde zu \neinem Duell ein!',
                                weight: FontWeight.w500,
                                textAlign: TextAlign.center,
                                fontSize: 18),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: QButton(
                                icon: Icons.search_rounded,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const FindFriend(),
                                      ));
                                },
                                buttonText: "Finde deine Freunde",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
        
            // Quiz Kategorien auflisten
            HistoryList(
              uid: userService.uid ?? "",
              maxItems: 4,
            ),
          ],
        ),
      ),
    );
  }
}
