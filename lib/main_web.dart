import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/Screens/live_quiz_screen/quiz_manager.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/main.dart';
import 'package:rigging_quiz/utils/score_service.dart';
import 'firebase_options.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => ScoreService()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),

      ],
      child: MyApp(),
    ),
  );
}


