import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:rigging_quiz/utils/constant.dart';

Widget qAvatar({String? avatar, double? height, double? width, bool? asset}) {
  try {
    if (asset == true && avatar != null) {
      // Falls asset auf true gesetzt ist, lade das SVG-Asset vom lokalen Pfad.
      return SvgPicture.asset(
        avatar,
        height: height ?? 80,
        width: width ?? 80,
      );
    } else if (avatar != null && avatar.startsWith('http')) {
      // Falls avatar eine URL ist, lade das SVG von der URL.
      return SvgPicture.network(
        avatar,
        height: height ?? 80,
        width: width ?? 80,
        placeholderBuilder: (context) => const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              color: QColors.primaryColor,
              strokeWidth: 0.8,
            )), // Optional: Platzhalter während des Ladens
      );
    } else {
      // Falls avatar ein SVG-String ist, rendere den String.
      return SvgPicture.string(
        avatar ?? RandomAvatarString("fallback_avatar", trBackground: true),
        height: height ?? 80,
        width: width ?? 80,
      );
    }
  } catch (e) {
    // Falls ein Fehler auftritt, zeige ein Standard-Icon an.
    return const Icon(
      Icons.account_circle,
      size: 80,
      color: QColors.secondaryColor,
    );
  }
}
