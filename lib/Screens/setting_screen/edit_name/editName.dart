import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/avatar.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/textfield.dart';
import 'package:random_avatar/random_avatar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  String? selectedAvatar;
  List<String> avatars = [];
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    // Initialisiere den Name Controller mit dem aktuellen Namen des Benutzers
    nameController.text = userService.name ?? '';
    generateAvatars(); // Die Avatare generieren, was auch 'selectedAvatar' initialisiert
  }

  void generateAvatars() {
    setState(() {
      avatars = List.generate(
        19,
        (index) {
          int random = Random().nextInt(4294967295);
          return RandomAvatarString("avatar$random", trBackground: true);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return QLayout(
      backButton: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Großer Avatar oben
          qAvatar(
            avatar: selectedAvatar ??
                userService.avatarUrl ??
                RandomAvatarString("avatar", trBackground: true),
            height: 120,
            width: 120,
          ),
          const SizedBox(height: 20),
          QTextField(
            controller: nameController,
            labelText: 'Dein Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Der Name darf nicht leer sein';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          const QText(
            text: "Wähle einen Avatar aus:",
            color: QColors.accentColor,
            weight: FontWeight.w500,
          ),
          const SizedBox(height: 10),
          // Wrap für die Avatare
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              // Avatar aus dem Provider als erstes Element
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAvatar = userService.avatarUrl ?? avatars[0];
                    });
                  },
                  child: userService.avatarUrl != null
                      ? qAvatar(
                          avatar: userService.avatarUrl ?? "",
                          height: 80,
                          width: 80,
                        )
                      : Container(),
                ),
              ),
              // Generierte Avatare danach
              ...avatars.map((avatar) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAvatar = avatar;
                      });
                    },
                    child: qAvatar(
                      avatar: avatar,
                      height: 80,
                      width: 80,
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 10),
          // Button zum erneuten Generieren von Avataren
          QButton(
            onPressed: generateAvatars,
            textButton: true,
            buttonText: 'Neu generieren',
          ),
          QButton(
            onPressed: () async {
              await userService.changeNameAndAvatar(
                nameController.text,
                selectedAvatar ??
                    RandomAvatarString("avatar", trBackground: true),
              );
              Navigator.pop(context);
            },
            buttonText: 'Profil aktualisieren',
          ),
        ],
      ),
    );
  }
}
