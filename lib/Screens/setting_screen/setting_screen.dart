import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/Screens/setting_screen/edit_email/edit_email.dart';
import 'package:rigging_quiz/Screens/setting_screen/edit_name/editName.dart';
import 'package:rigging_quiz/SignInPage.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/avatar.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? selectedDifficulty;
  String? selectedNotification;

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

    return QLayout(
      backButton: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSectionTitle('Konto'),
            _buildAccountOption(
              iconAsset: userService.avatarUrl,
              title: 'Dein Profil, dein Style',
              subtitle: 'Lass uns sehen, wer hinter den Moves steckt!',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const EditProfile()));
              },
            ),
            _buildAccountOption(
              icon: Icons.lock_outline_rounded,
              title: 'Zugangsdaten festlegen',
              subtitle: 'Sorge dafür, dass dein Fortschritt immer sicher bleibt!',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditEmailPassword()));
              },
            ),
            _buildAccountOption(
              icon: Icons.privacy_tip_rounded,
              title: 'Datenschutz',
              subtitle: 'Deine Daten sind bei uns stets sicher und geschützt!',
              onTap: () async {
                const url = 'https://rigging-quiz.de/datenschutz';
                if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                } else {
                throw 'Konnte den Link nicht öffnen: $url';
                }
              },
            ),
            _buildAccountOption(
              icon: Icons.support_agent_outlined,
              title: 'Support',
              subtitle: 'Deine Daten sind bei uns stets sicher und geschützt!',
              onTap: () async {
                const url = 'https://rigging-quiz.de/support';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                } else {
                  throw 'Konnte den Link nicht öffnen: $url';
                }
              },
            ),
            _buildDeleteAccount(userService),

            _buildLogoutButton(userService),
            const SizedBox(height: 16),

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
        color: QColors.white,
        fontSize: 18,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildAccountOption({
    required String title,
    Widget? subtitleWidget,
    String? subtitle,
    IconData? icon,
    String? iconAsset,
    void Function()? onTap,
  }) {
    double iconSize = 40.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(top: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: QColors.primaryColor,
            boxShadow: [
              BoxShadow(
                color: QColors.primaryColor.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: icon != null
                      ? const BoxDecoration(
                    color: QColors.white,
                    shape: BoxShape.circle,
                  )
                      : null,
                  margin: const EdgeInsets.all(8.0),
                  child: icon != null
                      ? Icon(icon, color: QColors.primaryColor)
                      : iconAsset != null
                      ? qAvatar(
                    avatar: iconAsset,
                    width: iconSize / 2,
                    height: iconSize / 2,
                  )
                      : Container(),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QText(
                        text: title,
                        color: QColors.white,
                        fontSize: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: subtitle != null
                            ? QText(
                          text: subtitle,
                          style: primaryTextStyle(
                            fontSize: 14,
                            weight: FontWeight.w400,
                            color: ColorsHelpers.grey2,
                          ),
                        )
                            : subtitleWidget,
                      ),
                    ],
                  ),
                ),
                if (subtitle != null)
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.arrow_forward_ios,
                        color: QColors.accentColor, size: 20),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccount(UserService userService) {
    return Column(
      children: [
        _buildAccountOption(
          icon: Icons.delete,
          title: 'Konto löschen',
          subtitle: 'Durch das Löschen deines Kontos werden all deine Daten dauerhaft entfernt.',
          onTap: () async {
            bool confirmed = await _showDeleteConfirmationDialog();
            if (!confirmed) return;

            try {
              final user = FirebaseAuth.instance.currentUser;
              final uid = user?.uid;

              if (user == null || uid == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Benutzer nicht gefunden.')),
                );
                return;
              }

              // Lösche den Benutzer aus der Realtime Database
              await FirebaseDatabase.instance.ref('users/$uid').remove();

              // Lösche den Benutzer aus Firebase Auth
              await user.delete();

              // Melde den Benutzer ab und navigiere zur Login-Seite
              await userService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fehler beim Löschen des Kontos: $e')),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildLogoutButton(UserService userService) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: QButton(
        onPressed: () async {
          await userService.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
          );
        },
        buttonText: 'Ausloggen',
        fontSize: 18,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        textColor: Colors.red,
        textButton: true,
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konto löschen'),
        content: const Text(
            'Bist du sicher, dass du dein Konto unwiderruflich löschen möchtest?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Löschen',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }
}
