import 'package:flutter/material.dart';
import 'package:rigging_quiz/Screens/friends/find_friends.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/share_button.dart';

class AnimatedLogoWithShare extends StatefulWidget {
  final bool shareButton;

  const AnimatedLogoWithShare({super.key, this.shareButton = false});
  @override
  _AnimatedLogoWithShareState createState() => _AnimatedLogoWithShareState();
}

class _AnimatedLogoWithShareState extends State<AnimatedLogoWithShare>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Startet die Animation automatisch beim Initialisieren
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: child,
              );
            },
            child: Image.asset(
              "assets/app_logo_leer.png",
              height: 220,
            ),
          ),
          const SizedBox(height: 20),
          widget.shareButton
              ? const ShareButton()
              : Container(
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
    );
  }
}
