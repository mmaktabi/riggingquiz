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
  final List<UserBadge> badges;

  const ScoreHeader({
    Key? key,
    required this.badges,
  }) : super(key: key);

  @override
  _ScoreHeaderState createState() => _ScoreHeaderState();
}

class _ScoreHeaderState extends State<ScoreHeader> {
  int _score = 0;
  bool isLoading = true;
  final ScoreService scoreService = ScoreService();
  final GreetingService greetingService = GreetingService();
  final FriendService friendService = FriendService();
  late StreamSubscription<int> _scoreSubscription;
  late StreamSubscription<int> _friendRequestsSubscription;
  int _friendRequestsCount = 0;

  @override
  void initState() {
    super.initState();

    final userService = Provider.of<UserService>(context, listen: false);

    if (userService.uid != null) {
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
    _scoreSubscription.cancel();
    _friendRequestsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final double width = MediaQuery.of(context).size.width;
// Berechne proportionale Größen basierend auf der Bildschirmbreite
    double iconSize;
    double friendsIconSize;
    double greetingFontSize;
    double nameFontSize;
    double scoreFontSize;
    double schaekelSize;
    double trophySize;
    double imgSize;
    if (width > 600) {
      // Für größere Bildschirme (z.B. Tablets, Laptops)
      iconSize = 16;
      friendsIconSize = 30;
      greetingFontSize = 11;
      nameFontSize = 22;
      scoreFontSize = 22;
      schaekelSize = 45;
      trophySize =  55;
      imgSize =  80;
    } else {
      // Für kleinere Bildschirme (Handys)
      iconSize = width * 0.05;
      friendsIconSize = width * 0.05;
      greetingFontSize = width * 0.020;
      nameFontSize = width * 0.042;
      scoreFontSize = width * 0.035;
      schaekelSize = width * 0.09;
      trophySize = width * 0.12;
      imgSize = width * 0.15;
    }




    return  Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
            child: Row(
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
                                size: iconSize,
                                color: QColors.accentColor,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: QText(
                                  text: greetingService.greeting,
                                  weight: FontWeight.w700,
                                  fontSize: greetingFontSize,
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
                              fontSize: nameFontSize,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        QImages.schaekel,
                        width: schaekelSize,
                        height: schaekelSize,
                      ),
                      const SizedBox(width: 12),
                      isLoading
                          ? QWidgets().progressIndicator
                          : Text(
                        '$_score',
                        style: TextStyle(
                          color: QColors.white,
                          fontSize: scoreFontSize,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Image.asset(
                        Images.illustrationTrophy,
                        width: trophySize,
                        height: trophySize,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _navigateToMyFriends(),
                          child: Stack(
                            children: [
                              Icon(Icons.group, color: QColors.white, size: friendsIconSize),
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
                            MaterialPageRoute(builder: (context) => const SettingScreen()),
                          );
                        },
                        child: userService.avatarUrl != null
                            ? SizedBox(
                          width: imgSize ,
                          child: qAvatar(avatar: userService.avatarUrl ?? ""),
                        )
                            : CircleAvatar(
                          backgroundColor: QColors.accentColor,
                          radius: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }



  void _navigateToMyFriends() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const MyFriends()));
  }

  void _showBadgesModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: QColors.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      buttonText: 'Schließen',
                    ),
                  ),
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
