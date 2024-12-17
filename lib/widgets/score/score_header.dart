// In ScoreHeader.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/Screens/friends/friendservice.dart';
import 'package:rigging_quiz/Screens/friends/my_friends.dart';
import 'package:rigging_quiz/Screens/setting_screen/setting_screen.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/greeting_service.dart';
import 'package:rigging_quiz/utils/images.dart';
import 'package:rigging_quiz/utils/score_service.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/avatar.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'dart:async';

class ScoreHeader extends StatefulWidget {
  final List<UserBadge> badges; // Ändere hier den Typ

  const ScoreHeader({
    super.key,
    required this.badges,
  });

  @override
  _ScoreHeaderState createState() => _ScoreHeaderState();
}

class _ScoreHeaderState extends State<ScoreHeader> {
  int _score = 0;
  bool isLoading = true;
  final ScoreService scoreService = ScoreService();
  final GreetingService greetingService = GreetingService();
  final FriendService friendService =
      FriendService(); // Instanz von FriendService
  late StreamSubscription<int> _scoreSubscription;
  late StreamSubscription<int>
      _friendRequestsSubscription; // Subscription für Freundschaftsanfragen
  int _friendRequestsCount = 0;

  @override
  void initState() {
    super.initState();

    final userService = Provider.of<UserService>(context, listen: false);

    if (userService.uid != null) {
      // Abonniere den Score-Stream
      _scoreSubscription =
          scoreService.getScoreStream(userService.uid!).listen((newScore) {
        if (mounted) {
          setState(() {
            _score = newScore;
          });
        }
      }, onError: (error) {
        print('Fehler beim Abonnieren des Score-Streams: $error');
      });

      // Abonniere den FriendRequestsCount-Stream
      _friendRequestsSubscription = friendService
          .getFriendRequestsCountStream(userService.uid!)
          .listen((count) {
        if (mounted) {
          setState(() {
            _friendRequestsCount = count;
          });
        }
      }, onError: (error) {
        print('Fehler beim Abonnieren der Freundschaftsanfragen: $error');
      });
    }

    // Simuliere eine kurze Ladezeit und setze isLoading danach auf false
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // Beende die Subscriptions, wenn das Widget aus dem Baum entfernt wird
    _scoreSubscription.cancel();
    _friendRequestsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => _showBadgesModal(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                greetingService.icon,
                                size: 24.0,
                                color: QColors.accentColor,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: QText(
                                  text: greetingService.greeting,
                                  weight: FontWeight.w700,
                                  fontSize: 14,
                                  color: QColors.accentColor,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: QText(
                              text: userService.name ?? "",
                              weight: FontWeight.w500,
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        QImages.schaekel,
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(width: 12),
                      // Zeige den Score an (ohne Animation)
                      isLoading
                          ? QWidgets().progressIndicator
                          : Text(
                              '$_score',
                              style: primaryTextStyle(
                                color: QColors.white,
                                fontSize: 22,
                              ),
                            ),
                      const SizedBox(width: 24),
                      Image.asset(
                        Images.illustrationTrophy,
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _navigateToMyFriends(),
                        child: Stack(
                          children: [
                            const Icon(Icons.group, color: QColors.white, size: 25),
                            Positioned(
                              right: 0,
                              child: customBadge(_friendRequestsCount),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingScreen()));
                      },
                      child: userService.avatarUrl != null
                          ? SizedBox(
                              width: 60,
                              child:
                                  qAvatar(avatar: userService.avatarUrl ?? ""))
                          : const CircleAvatar(
                              backgroundColor: QColors.accentColor,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMyFriends() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyFriends()));
  }

  void _showBadgesModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: QColors.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Abzeichen',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: QColors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    child: Column(
                      children: widget.badges.map((badge) {
                        return ListTile(
                          leading: Image.asset(
                            badge.imagePath,
                            width: 40,
                            height: 40,
                          ),
                          title: Text(
                            badge.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (widget.badges.isEmpty)
                    const QText(
                      text: "Keine Abzeichen vorhanden.",
                      color: QColors.white,
                    ),
                  const SizedBox(height: 100),
                  Align(
                      alignment: Alignment.centerRight,
                      child: QButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          buttonText: 'Schließen')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserBadge {
  // Umbenannte Klasse
  final String name;
  final String imagePath;

  UserBadge({required this.name, required this.imagePath});
}

Widget customBadge(int count) {
  return count > 0
      ? Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          constraints: const BoxConstraints(
            minWidth: 16,
            minHeight: 16,
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        )
      : const SizedBox.shrink();
}
