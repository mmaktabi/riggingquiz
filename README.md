# RiggingQuiz - Veranstaltungstechnik-Quiz

**RiggingQuiz** ist ein interaktives Quizspiel für den Bereich **Veranstaltungstechnik**. Spieler können Fragen zu verschiedenen Themen wie Rigging, Knotentechniken, Traversenmontage und Sicherheit beantworten und ihre Kenntnisse testen. Die App wurde mit **Flutter** entwickelt und nutzt **Firebase** für Hosting und Datenmanagement.

---

## Features
- **Kategorien**: Fragen sind in verschiedene Themenbereiche der Veranstaltungstechnik unterteilt.
- **Fragen-Management**: CRUD-Funktionalitäten für Fragen und Kategorien (Erstellen, Bearbeiten, Löschen).
- **Scoring-System**: Punktevergabe basierend auf richtigen Antworten.
- **Firebase-Integration**: Realtime Database und Authentifizierung über Firebase.
- **Responsives Design**: Die App läuft auf Web, iOS und Android.
- **Hosting**: Die Webversion der App wird über Firebase Hosting bereitgestellt.

---

## Technologien
- **Frontend**: Flutter (Dart)
- **Backend**: Firebase Realtime Database, Firebase Auth
- **Hosting**: Firebase Hosting

---

## Installation und Setup

### Voraussetzungen
- [Flutter SDK](https://flutter.dev/docs/get-started/install) muss installiert sein.
- Ein Firebase-Projekt mit aktiven Diensten:
    - Firebase Realtime Database
    - Firebase Authentication
    - Firebase Hosting
- Node.js und Firebase CLI müssen installiert sein.

### Lokale Entwicklung

1. **Repository klonen**:
   ```bash
   git clone <repo-link>
   cd riggingquiz
   ```

2. **Abhängigkeiten installieren**:
   ```bash
   flutter pub get
   ```

3. **Firebase CLI konfigurieren**:
   Melde dich mit Firebase CLI an und verknüpfe dein Projekt:
   ```bash
   firebase login
   firebase use --add
   ```

4. **Firebase-Konfiguration einrichten**:
   Erstelle eine `google-services.json` (für Android) und `GoogleService-Info.plist` (für iOS), die du aus der Firebase Console herunterladen kannst. Lege die Dateien in den entsprechenden Verzeichnissen ab:
    - `android/app`
    - `ios/Runner`

5. **Starten der App**:
   ```bash
   flutter run
   ```

---

## Firebase Hosting - Deployment

1. **Build für Web erstellen**:
   ```bash
   flutter build web
   ```

2. **Deployment über Firebase CLI**:
   ```bash
   firebase deploy --only hosting
   ```

3. **Live-URL anzeigen**:
   Nach dem Deployment wird die Live-URL angezeigt, z. B. `https://riggingquiz.web.app`

---

## Datenbankstruktur

Die Firebase Realtime Database verwendet folgende Struktur:
```json
{
  "categories": {
    "category_id": {
      "name": "Knotentechniken",
      "description": "Fragen zu Knotentechniken",
      "questions": [
        {
          "question": "Welcher Knoten eignet sich zur Sicherung?",
          "answers": ["Achterknoten", "Palstek", "Kreuzknoten"],
          "correctAnswer": "Achterknoten"
        }
      ]
    }
  }
}
```

---

## App-Struktur

- **lib/**: Hauptverzeichnis für den Flutter-Code
    - `main.dart`: Einstiegspunkt der App
    - `screens/`: Enthält die UI-Seiten
        - `categories_screen.dart`
        - `quiz_screen.dart`
    - `data/`: Enthält Logik zur Datenbank- und Authentifizierungs-Interaktion
    - `model/`: Datenmodelle für Fragen und Kategorien

---

## Autor
- **Name**: Moheeb Maktabi
- **Projekt**: RiggingQuiz
- **Technologien**: Flutter, Firebase

---

## Lizenz
Dieses Projekt steht unter der MIT-Lizenz. Weitere Informationen findest du in der [LICENSE](LICENSE)-Datei.
