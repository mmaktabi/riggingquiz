import 'package:flutter/material.dart';

// Enum zur Repräsentation der Tageszeiten
enum DayTime { Morning, Afternoon, Evening }

class GreetingService {
  // Bestimmt die aktuelle Tageszeit
  DayTime get currentDayTime {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return DayTime.Morning;
    } else if (hour >= 12 && hour < 18) {
      return DayTime.Afternoon;
    } else {
      return DayTime.Evening;
    }
  }

  // Gibt die passende Begrüßung als String zurück
  String get greeting {
    switch (currentDayTime) {
      case DayTime.Morning:
        return "Guten Morgen";
      case DayTime.Afternoon:
        return "Guten Tag";
      case DayTime.Evening:
        return "Guten Abend";
    }
  }

  // Gibt das passende Icon basierend auf der Tageszeit zurück
  IconData get icon {
    switch (currentDayTime) {
      case DayTime.Morning:
        return Icons.wb_sunny; // Sonnensymbol für den Morgen
      case DayTime.Afternoon:
        return Icons.wb_sunny; // Sonnensymbol für den Tag
      case DayTime.Evening:
        return Icons.nights_stay; // Mondsymbol für den Abend
    }
  }
}
