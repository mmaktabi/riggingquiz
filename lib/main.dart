import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rigging_quiz/Screens/live_quiz_screen/quiz_manager.dart';
import 'package:rigging_quiz/Screens/management_system.dart/category_list_screen.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/SignInPage.dart';
import 'package:rigging_quiz/Screens/home_page.dart';
import 'package:rigging_quiz/main_web.dart';
import 'package:rigging_quiz/utils/admin_auth/auth_screen.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/utils/score_service.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'firebase_options.dart';

void main() async {
  if (kIsWeb) {
    mainWeb();
  }
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

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminAccessGuard(
          child: CategoryListScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MaterialApp.router(
          title: 'RiggingQuiz',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routerConfig: _router,
        );
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authStream = FirebaseAuth.instance.authStateChanges();

    return StreamBuilder<User?>(
      stream: authStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingIndicator();
        }

        if (snapshot.hasData) {
          return FutureBuilder<bool>(
            future: _checkAdminClaims(snapshot.data!),
            builder: (context, claimsSnapshot) {
              if (claimsSnapshot.connectionState == ConnectionState.waiting) {
                return _loadingIndicator();
              }

              if (claimsSnapshot.data == true) {
                return const HomeScreen();
              } else {
                return const SignInPage();
              }
            },
          );
        } else {
          return const SignInPage();
        }
      },
    );
  }

  Widget _loadingIndicator() {
    return QLayout(
      child: Center(
        child: QWidgets().progressIndicator,
      ),
    );
  }

  Future<bool> _checkAdminClaims(User user) async {
    try {
      final idTokenResult = await user.getIdTokenResult(true);
      return idTokenResult.claims?['admin'] == true;
    } catch (e) {
      return false;
    }
  }
}

class AdminAccessGuard extends StatelessWidget {
  final Widget child;

  const AdminAccessGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return AuthAdminScreen(child: child);
    }

    return FutureBuilder<bool>(
      future: _checkAdminClaims(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return QWidgets().progressIndicator;
        }

        if (snapshot.data == true) {
          return child;
        } else {
          return AuthAdminScreen(child: child);
        }
      },
    );
  }

  Future<bool> _checkAdminClaims(User user) async {
    try {
      final idTokenResult = await user.getIdTokenResult(true);
      return idTokenResult.claims?['admin'] == true;
    } catch (e) {
      return false;
    }
  }
}
