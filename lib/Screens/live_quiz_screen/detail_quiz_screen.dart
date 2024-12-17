import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rigging_quiz/Screens/friends/my_friends.dart';
import 'package:rigging_quiz/Screens/live_quiz_screen/live_quiz_screen.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/images.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class DetailQuizScreen extends StatelessWidget {
  final String? categoryId;
  final QuizCategory quizCategory;

  const DetailQuizScreen({
    super.key,
    this.categoryId,
    required this.quizCategory,
  });

  @override
  Widget build(BuildContext context) {
    return QLayout(
      backButton: true,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 50,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(180 / 360),
              child: SvgPicture.asset(
                Images.ovalWithOutlineBottomOnboarding,
                height: 200,
                width: 200,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                quizCategory.iconImage != ""
                    ? Image.network(quizCategory.iconImage,
                        fit: BoxFit.cover, height: 250)
                    : const SizedBox(height: 250),
                const SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Kategorie'),
                      QText(
                        text: quizCategory.name,
                        weight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 16),
                      _buildQuizInfoSection(
                        quizCategory.quizzes.length.toString(),
                        quizCategory.quizzes.length.toString(),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('BESCHREIBUNG'),
                      QText(
                        text: quizCategory.description,
                        fontSize: 16,
                        weight: FontWeight.w400,
                      ),
                      const SizedBox(height: 60),
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: QText(
        text: title,
        color: ColorsHelpers.grey2,
        fontSize: 14,
        weight: FontWeight.w500,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildQuizInfoSection(String questions, String points) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: QColors.primaryColor.withOpacity(0.2),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const CircleAvatar(
              backgroundColor: QColors.primaryColor,
              child: Icon(
                Icons.question_mark_rounded,
                color: QColors.white,
              )),
          QText(
            text: '$questions Fragen',
            weight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black,
          ),
          Image.asset(
            QImages.schaekel,
            height: 33,
          ),
          QText(
            text: '$points Schäkel',
            weight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      children: [
        QButton(
          buttonText: "Allein spielen",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiveQuizScreen(
                  quizCategory: quizCategory,
                ),
              ),
            );
          },
        ),
        QButton(
          buttonText: "Duell mit Freunden",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyFriends(
                          quizCategory: quizCategory,
                        )));
          },
        ),
      ],
    );
  }
}
