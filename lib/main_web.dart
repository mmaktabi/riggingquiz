import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rigging_quiz/Screens/management_system.dart/category_list_screen.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/SignInPage.dart';
import 'package:rigging_quiz/Screens/home_page.dart';
import 'package:rigging_quiz/main.dart';
import 'package:rigging_quiz/setUrlStrategy.dart';
import 'package:rigging_quiz/utils/admin_auth/auth_screen.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/utils/score_service.dart';
import 'package:rigging_quiz/utils/widget_package.dart';

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
      ],
      child: MyApp(),
    ),
  );
}


