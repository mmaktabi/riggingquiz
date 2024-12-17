import 'package:rigging_quiz/model/utils_model.dart';

// quizes.dart

enum QuizCategory {
  knotTechniques,
  trussAssembly,
  riggingSafety,
  lightingTechniques,
  soundEngineering,
}

// Details für jedes Quiz
final Map<QuizCategory, Map<String, String>> quizDetails = {
  QuizCategory.knotTechniques: {
    'title': 'Knotentechniken',
    'category': 'Veranstaltungstechnik',
    'description':
        'Erlerne die wichtigsten Knotentechniken für die Veranstaltungstechnik!',
    'questions': '7 Fragen',
    'points': '+70 Punkte',
    'image':
        "https://firebasestorage.googleapis.com/v0/b/rigging-c0661.appspot.com/o/system%2FDALL_E_2024-10-05_00.22.31_-_A_detailed_drawing_of_a_rope_knot__such_as_a_figure-eight_knot_or_a_bowline__symbolizing_the_complexity_and_importance_of_knot_techniques_in_event_tec-removebg-preview.png?alt=media&token=7981498d-58c0-4c05-b9f3-17a863ef6d64",
  },
  QuizCategory.trussAssembly: {
    'title': 'Traversenmontage',
    'category': 'Veranstaltungstechnik',
    'description': 'Meistere die Grundlagen der Montage von Traversensystemen.',
    'questions': '7 Fragen',
    'points': '+70 Punkte',
    'image':
        "https://firebasestorage.googleapis.com/v0/b/rigging-c0661.appspot.com/o/system%2FDALL_E_2024-10-05_00.24.09_-_An_icon_idea_featuring_a_stylized_aluminum_truss_with_connecting_elements_or_a_wrench_engaging_with_the_truss__highlighting_the_assembly_aspect._The_d__1_-removebg-preview.png?alt=media&token=2e9b3c34-9507-43ed-b578-eedb1cf4134e",
  },
  QuizCategory.riggingSafety: {
    'title': 'Sicherheit beim Rigging',
    'category': 'Veranstaltungstechnik',
    'description': 'Verstehe alle wichtigen Sicherheitsregeln für das Rigging.',
    'questions': '7 Fragen',
    'points': '+70 Punkte',
    'image':
        "https://firebasestorage.googleapis.com/v0/b/rigging-c0661.appspot.com/o/system%2FDALL_E_2024-10-05_00.24.08_-_An_icon_idea_featuring_a_safety_symbol_such_as_a_protective_helmet_or_safety_harness__possibly_combined_with_a_hook_or_rope__emphasizing_the_importanc-removebg-preview.png?alt=media&token=dc1ec7ce-b029-44fe-a692-973e6ecca311",
  },
  QuizCategory.lightingTechniques: {
    'title': 'Lichttechnik',
    'category': 'Veranstaltungstechnik',
    'description':
        'Erlerne die Grundlagen der Lichttechnik für Veranstaltungen.',
    'questions': '7 Fragen',
    'points': '+70 Punkte',
    'image':
        "https://firebasestorage.googleapis.com/v0/b/rigging-c0661.appspot.com/o/system%2FDALL_E_2024-10-05_00.24.06_-_An_icon_idea_featuring_a_spotlight_or_moving_head_with_beams_of_light_coming_out__possibly_combined_with_colored_light_cones__representing_the_creativ-removebg-preview.png?alt=media&token=66d82cc9-7c17-463d-b1f3-fb00e773f2bd",
  },
  QuizCategory.soundEngineering: {
    'title': 'Tontechnik',
    'category': 'Veranstaltungstechnik',
    'description':
        'Verstehe die Prinzipien der Tontechnik und wie du besten Klang erzeugst.',
    'questions': '7 Fragen',
    'points': '+70 Punkte',
    'image':
        "https://firebasestorage.googleapis.com/v0/b/rigging-c0661.appspot.com/o/system%2FDALL_E_2024-10-05_00.24.02_-_An_icon_idea_featuring_a_mixing_console_with_sliders_and_knobs__a_microphone__or_a_speaker_symbol_emitting_sound_waves__representing_various_aspects_o-removebg-preview.png?alt=media&token=36d00999-9b4a-4943-ad48-3c4c3576281e",
  },
};

// Fragen für jede Kategorie
final Map<QuizCategory, List<QuestionModel>> quizQuestions = {
  QuizCategory.knotTechniques: [
    // Bestehende 10 Fragen
    QuestionModel(
      "Welcher Knoten wird oft verwendet, um zwei Seile zu verbinden?",
      {
        "Palstek": false,
        "Schotstek": true,
        "Mastwurf": false,
        "Rundtörn": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche der folgenden Knoten sind für das Sichern geeignet?",
      {
        "Mastwurf": true,
        "Achterknoten": true,
        "Halber Schlag": false,
        "Kreuzknoten": false
      },
      10,
      QuestionType.multiple,
    ),
    QuestionModel(
      "Wofür wird der Achterknoten verwendet?",
      {
        "Zum Sichern von Lasten": true,
        "Um zwei Seile zu verbinden": false,
        "Zum Abseilen": false,
        "Als Verzierung": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist ein Rundtörn?",
      {
        "Eine einfache Seilumwicklung": true,
        "Ein spezieller Knoten zum Sichern": false,
        "Eine Technik zum Lösen von Seilen": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welcher Knoten ist am besten für das Abseilen geeignet?",
      {"Achterknoten": true, "Schotstek": false, "Rundtörn": false},
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist der Unterschied zwischen einem Palstek und einem Schotstek?",
      {
        "Palstek ist ein Knoten zum Abseilen, Schotstek zum Verbinden": false,
        "Palstek hat zwei Schlaufen, Schotstek nur eine": true,
        "Palstek ist ein stabiler Knoten, Schotstek ein einfacher Knoten": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Wann sollte man einen Halben Schlag verwenden?",
      {
        "Um ein Seil zu sichern": false,
        "Um eine Verbindung zwischen zwei Seilen herzustellen": false,
        "Um ein Seil zu beenden": true
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Knoten eignen sich besonders gut für die Arbeit mit schweren Lasten?",
      {
        "Palstek und Achterknoten": true,
        "Schotstek und Rundtörn": false,
        "Kreuzknoten und Halber Schlag": false
      },
      10,
      QuestionType.multiple,
    ),
    QuestionModel(
      "Was sollte man beim Binden von Knoten beachten?",
      {
        "Die Art des Seils und die Last": true,
        "Nur die Anzahl der Windungen": false,
        "Die Farbe des Seils": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welcher Knoten kann als Stopper verwendet werden?",
      {"Achterknoten": true, "Mastwurf": false, "Schotstek": false},
      10,
      QuestionType.single,
    ),
    // Zusätzliche 5 Fragen
    QuestionModel(
      "Welche Knoten sind ideal für temporäre Befestigungen?",
      {
        "Palstek": true,
        "Kreuzknoten": false,
        "Schotstek": true,
        "Rundtörn": false
      },
      10,
      QuestionType.multiple,
    ),
    QuestionModel(
      "Wie wird ein doppelter Palstek gebunden?",
      {
        "Durch zweimaliges Überkreuzen der Enden": true,
        "Durch eine einfache Schlaufe": false,
        "Durch eine feste Bindung ohne Schlaufen": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welcher Knoten bietet die beste Abriebsfestigkeit?",
      {
        "Achterknoten": true,
        "Halber Schlag": false,
        "Mastwurf": false,
        "Palstek": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Für welche Anwendung eignet sich der Kreuzknoten am besten?",
      {
        "Leichte Verbindungen": true,
        "Schwere Lasten": false,
        "Abseilen": false,
        "Sichern von Traversensystemen": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist ein effektiver Weg, um Knoten schnell zu lösen?",
      {
        "Seil in der richtigen Richtung belasten": true,
        "Seil ständig ziehen": false,
        "Knoten fest anziehen": false
      },
      10,
      QuestionType.single,
    ),
  ],
  QuizCategory.trussAssembly: [
    // Bestehende 10 Fragen
    QuestionModel(
      "Welche Arten von Traversensystemen gibt es?",
      {
        "Quadratische, rechteckige und kreisförmige Traversensysteme": true,
        "Nur quadratische Traversensysteme": false,
        "Nur rechteckige Traversensysteme": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist beim Aufstellen einer Traverse wichtig?",
      {
        "Die Stabilität und die Lastverteilung": true,
        "Nur das Design der Traverse": false,
        "Die Farbe der Traverse": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welches Zubehör wird häufig zur Befestigung von Traversensystemen verwendet?",
      {
        "Schrauben, Unterlegscheiben und Bolzen": true,
        "Nur Nägel": false,
        "Nur Ketten": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Wie werden Traversensysteme in der Regel gesichert?",
      {
        "Mit Ketten und Gurten": true,
        "Nur mit Schrauben": false,
        "Mit einfachen Knoten": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist eine Truss-Box?",
      {
        "Ein Verbindungselement zwischen zwei Traversenelementen": true,
        "Eine Box zur Aufbewahrung von Traversenzubehör": false,
        "Eine Art von Traverse": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Wann sollte eine Traverse getestet werden?",
      {"Vor jedem Einsatz": true, "Nur nach der Montage": false, "Nie": false},
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Gefahren können bei der Traversensmontage auftreten?",
      {
        "Instabilität und Umstürzen": true,
        "Zu hohe Belastung": false,
        "Überhitzung": false
      },
      10,
      QuestionType.multiple,
    ),
    QuestionModel(
      "Wie viele Personen sind normalerweise für die Montage einer großen Traverse erforderlich?",
      {
        "Mindestens zwei bis drei": true,
        "Nur eine Person": false,
        "Keine Personen, es kann automatisch erfolgen": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welches ist der beste Untergrund für die Montage einer Traverse?",
      {
        "Fester, ebenmäßiger Boden": true,
        "Sand oder Kies": false,
        "Jeder Untergrund ist geeignet": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was sind die Hauptvorteile von Aluminium-Traversen?",
      {
        "Leicht, stabil und korrosionsbeständig": true,
        "Schwer und teuer": false,
        "Nur für den Innenbereich geeignet": false
      },
      10,
      QuestionType.single,
    ),
    // Zusätzliche 5 Fragen
    QuestionModel(
      "Wie transportiert man Traversensysteme sicher?",
      {
        "In stabilen Transportboxen": true,
        "Lose auf dem Dachträger": false,
        "In Taschen": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Sicherheitsstandards müssen Traversensysteme erfüllen?",
      {
        "DIN-Normen und EU-Richtlinien": true,
        "Keine speziellen Standards": false,
        "Nur interne Firmenstandards": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist ein Segment bei einem Traversensystem?",
      {
        "Ein einzelnes Element der Traverse": true,
        "Die gesamte Traverse": false,
        "Ein spezieller Knoten": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Wie kann man die Lastverteilung auf einer Traverse optimieren?",
      {
        "Durch gleichmäßiges Verteilen der Lasten": true,
        "Durch Anbringen der Lasten an einem Punkt": false,
        "Durch Verwendung von schwereren Traversenelementen": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Materialien werden am häufigsten für Traversensysteme verwendet?",
      {
        "Aluminium und Stahl": true,
        "Holz und Kunststoff": false,
        "Nur Stahl": false
      },
      10,
      QuestionType.single,
    ),
  ],
  QuizCategory.riggingSafety: [
    // Bestehende 10 Fragen
    QuestionModel(
      "Was ist der erste Schritt zur Gewährleistung der Rigging-Sicherheit?",
      {
        "Eine Risikobewertung durchführen": true,
        "Sofort mit dem Rigging beginnen": false,
        "Nur das Equipment überprüfen": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche persönliche Schutzausrüstung ist beim Rigging erforderlich?",
      {
        "Helm, Handschuhe und Sicherheitsgurt": true,
        "Nur Sicherheitsschuhe": false,
        "Keine spezielle Ausrüstung erforderlich": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was sollte man vor dem Heben einer Last überprüfen?",
      {
        "Das Gewicht und die Stabilität der Last": true,
        "Nur das Aussehen der Last": false,
        "Nichts, es ist unwichtig": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Wie sollte man sich verhalten, wenn man eine schwere Last hebt?",
      {
        "Langsam und kontrolliert heben": true,
        "Schnell und ohne Überlegung heben": false,
        "Überhaupt nicht heben": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Bedeutung hat die Sichtprüfung der Ausrüstung?",
      {
        "Erkennung von Beschädigungen oder Verschleiß": true,
        "Keine Bedeutung, da alles neu ist": false,
        "Nur wichtig, wenn das Equipment älter ist": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was sollte man tun, wenn eine Gefahr während des Rigging auftritt?",
      {
        "Sofort die Arbeit einstellen und die Sicherheit überprüfen": true,
        "Ignorieren und weitermachen": false,
        "Nur den Vorgesetzten informieren": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Rolle spielt Kommunikation beim Rigging?",
      {
        "Sie ist entscheidend für die Sicherheit": true,
        "Sie ist unwichtig": false,
        "Nur für die Teamleiter wichtig": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Wie sollte eine Last gesichert werden, bevor sie angehoben wird?",
      {
        "Mit geeigneten Knoten und Sicherungen": true,
        "Nur mit Ketten": false,
        "Gar nicht, das ist nicht nötig": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist ein häufiges Problem bei der Verwendung von Seil- und Kettenmechanismen?",
      {
        "Überlastung und Materialermüdung": true,
        "Falsche Farbe der Kette": false,
        "Zu geringe Anzahl von Knoten": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Sicherheitsvorkehrungen sind beim Arbeiten in der Höhe erforderlich?",
      {
        "Sicherheitsgeschirre und Absturzsicherungen": true,
        "Nur ein Helm": false,
        "Keine speziellen Vorkehrungen erforderlich": false
      },
      10,
      QuestionType.single,
    ),
    // Zusätzliche 5 Fragen
    QuestionModel(
      "Welche regelmäßigen Wartungsarbeiten sind für Rigging-Ausrüstung notwendig?",
      {
        "Inspektion auf Verschleiß und Beschädigungen": true,
        "Nur Reinigung ohne Inspektion": false,
        "Keine Wartung erforderlich": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Wie sollte man mit defekter Rigging-Ausrüstung umgehen?",
      {
        "Sofort aus dem Verkehr ziehen und ersetzen": true,
        "Weiter benutzen bis zum Ausfall": false,
        "Nur den Vorgesetzten informieren": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Faktoren beeinflussen die Wahl der Rigging-Ausrüstung?",
      {
        "Art der Last und Umgebungsbedingungen": true,
        "Nur das Budget": false,
        "Nur die Verfügbarkeit": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist ein Anschlagpunkt?",
      {
        "Ein sicherer Punkt zur Befestigung von Seilen und Ketten": true,
        "Ein Ort zum Lagern von Ausrüstung": false,
        "Ein spezieller Knoten": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Dokumentation ist für Rigging-Arbeiten erforderlich?",
      {
        "Risikobewertungen und Sicherheitsprotokolle": true,
        "Nur die Arbeitsanweisungen": false,
        "Keine Dokumentation erforderlich": false
      },
      10,
      QuestionType.single,
    ),
  ],
  QuizCategory.lightingTechniques: [
    // 15 Fragen für Lichttechnik
    QuestionModel(
      "Welche Lichtquelle wird häufig in Theaterscheinwerfern verwendet?",
      {"LED": true, "Halogen": true, "Glühbirne": false, "Sonnenlicht": false},
      10,
      QuestionType.multiple,
    ),
    QuestionModel(
      "Was bedeutet der Begriff 'Lichtstärke'?",
      {
        "Die Intensität des ausgestrahlten Lichts": true,
        "Die Farbe des Lichts": false,
        "Der Stromverbrauch der Lampe": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Farbe wird oft verwendet, um eine warme Atmosphäre zu schaffen?",
      {"Gelb": true, "Blau": false, "Rot": false},
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist ein Goboprojektor?",
      {
        "Ein Gerät, das Muster auf Oberflächen projiziert": true,
        "Ein Licht, das farbige Effekte erzeugt": false,
        "Ein Verstärker": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Wie wird ein Follow-Spot verwendet?",
      {
        "Um Personen oder Objekte auf der Bühne zu verfolgen": true,
        "Um die gesamte Bühne zu beleuchten": false,
        "Nur als Deko-Licht": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was bedeutet der Begriff 'Dimmung'?",
      {
        "Das Reduzieren der Lichtintensität": true,
        "Das Ändern der Lichtfarbe": false,
        "Das Erhöhen der Temperatur": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Art von Scheinwerfer eignet sich am besten für bewegliche Lichteffekte?",
      {
        "Moving Head Scheinwerfer": true,
        "Spotlights": false,
        "Floodlights": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist der Zweck eines Stroboskops?",
      {
        "Schnelle Lichtblitze zur Erzeugung von Bewegungseffekten": true,
        "Ständige Beleuchtung ohne Effekte": false,
        "Farbwechsel ohne Bewegung": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Sicherheitsmaßnahme ist beim Umgang mit Lichttechnik besonders wichtig?",
      {
        "Sicherstellen, dass alle Kabel ordentlich verlegt sind": true,
        "Nur helle Lichter verwenden": false,
        "Lichter nicht ausschalten": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist ein Dimmer?",
      {
        "Ein Gerät zur Steuerung der Lichtintensität": true,
        "Ein Gerät zur Farbänderung des Lichts": false,
        "Ein Gerät zur Bewegung der Lichter": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Wie kann man die Lebensdauer von Scheinwerfern verlängern?",
      {
        "Regelmäßige Reinigung und Wartung": true,
        "Übermäßige Nutzung": false,
        "Keine Wartung durchführen": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist ein LED-Panel?",
      {
        "Ein flaches Lichtpanel mit LED-Technologie": true,
        "Ein traditioneller Glühlampen-Scheinwerfer": false,
        "Ein projektionsbasiertes Lichtsystem": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Lichtfarbe wird oft für kalte Effekte verwendet?",
      {"Blau": true, "Rot": false, "Gelb": false},
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist der Vorteil von LED-Lichtern gegenüber Halogenlampen?",
      {
        "Geringerer Energieverbrauch und längere Lebensdauer": true,
        "Höhere Wärmeentwicklung": false,
        "Geringere Lichtqualität": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Wie nennt man die Technik, bei der Lichtquellen so platziert werden, dass Schatten minimiert werden?",
      {
        "Key Light Technik": false,
        "Soft Lighting": true,
        "Hard Lighting": false
      },
      10,
      QuestionType.single,
    ),
  ],
  QuizCategory.soundEngineering: [
    // 15 Fragen für Tontechnik
    QuestionModel(
      "Was ist der Unterschied zwischen einem Dynamik- und einem Kondensatormikrofon?",
      {
        "Ein Kondensatormikrofon benötigt eine Phantomspeisung": true,
        "Ein Dynamikmikrofon ist lauter": false,
        "Ein Kondensatormikrofon ist unempfindlicher": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was bedeutet 'Gain' bei einem Mischpult?",
      {
        "Die Verstärkung des Eingangssignals": true,
        "Die Lautstärke des Ausgangssignals": false,
        "Der Frequenzbereich des Signals": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Wie verhindert man Rückkopplung?",
      {
        "Mikrofone richtig platzieren und Lautsprecher anpassen": true,
        "Die Lautstärke maximal einstellen": false,
        "Nur die Höhenpegel erhöhen": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welches Equipment benötigt man zur Frequenzanalyse?",
      {
        "Equalizer und Spektrum-Analyser": true,
        "Nur ein Mikrofon": false,
        "Ein Lautsprecher und einen Verstärker": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Frequenzen sind typisch für Bassinstrumente?",
      {"20-200 Hz": true, "500-1000 Hz": false, "2000-5000 Hz": false},
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist eine DI-Box?",
      {
        "Ein Gerät zur Anpassung von Signalpegeln": true,
        "Ein Lautsprecher": false,
        "Ein Verstärker": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was bedeutet 'Phantomversorgung'?",
      {
        "Stromversorgung für Kondensatormikrofone über das Mikrofonkabel": true,
        "Batteriebetrieb für drahtlose Mikrofone": false,
        "Verstärkung des Signals": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Wie nennt man die Anpassung der Lautstärke zwischen verschiedenen Geräten?",
      {"Gain Staging": true, "Equalizing": false, "Panning": false},
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist der Zweck eines Kompressors im Audiobereich?",
      {
        "Die Dynamik des Signals zu kontrollieren": true,
        "Die Tonhöhe zu ändern": false,
        "Echos hinzuzufügen": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Art von Kabel wird am häufigsten für Mikrofone verwendet?",
      {"XLR-Kabel": true, "USB-Kabel": false, "HDMI-Kabel": false},
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was versteht man unter 'Panorama' im Audiomischungskontext?",
      {
        "Die Platzierung eines Signals im Stereofeld": true,
        "Die Lautstärke eines Kanals": false,
        "Die Frequenzbalance eines Sounds": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Welche Einheit misst die Lautstärke von Audio in Dezibel?",
      {"dB": true, "Hz": false, "kHz": false},
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist ein Equalizer?",
      {
        "Ein Gerät zur Anpassung der Frequenzbalance": true,
        "Ein Gerät zur Verstärkung des Signals": false,
        "Ein Gerät zur Aufnahme von Audio": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Wie kann man die Klarheit eines Vocals in einem Mix verbessern?",
      {
        "Durch Anheben der mittleren Frequenzen": true,
        "Durch Absenken der Höhen": false,
        "Durch Hinzufügen von mehr Effekten": false
      },
      10,
      QuestionType.single,
    ),
    QuestionModel(
      "Was ist ein Headphone Splitter?",
      {
        "Ein Gerät, das ein Audiosignal auf mehrere Kopfhörer aufteilt": true,
        "Ein Gerät, das das Signal verstärkt": false,
        "Ein Gerät zur Anpassung der Lautstärke": false
      },
      10,
      QuestionType.single,
    ),
  ],
};
