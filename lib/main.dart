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
import 'package:rigging_quiz/utils/admin_auth/auth_screen.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/utils/score_service.dart';
import 'package:rigging_quiz/utils/widget_package.dart';

import 'firebase_options.dart';

void main() async {
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
      // Weitere Routen können hier hinzugefügt werden
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
          routerConfig: _router, // Verwende den GoRouter
        );
      },
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Stream<User?> _authStream;
  IdTokenResult? _tokenResult;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _authStream = FirebaseAuth.instance.authStateChanges();

    // Lauschen auf Authentifizierungsänderungen und Token abrufen
    _authStream.listen((user) async {
      if (user != null) {
        try {
          IdTokenResult token = await user.getIdTokenResult(true);
          setState(() {
            _tokenResult = token;
            _isLoading = false;
          });
        } catch (e) {
          setState(() {
            _tokenResult = null;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _tokenResult = null;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return _indicator(height);
    } else {
      // Falls _tokenResult vorhanden ist, wurde der Benutzer authentifiziert
      if (_tokenResult != null) {
        return const HomeScreen();
      } else {
        return const SignInPage();
      }
    }
  }

  Widget _indicator(double height) {
    return QLayout(
      child: SizedBox(
        height: height,
        child: QWidgets().progressIndicator,
      ),
    );
  }
}

class AdminAccessGuard extends StatelessWidget {
  final Widget child;

  const AdminAccessGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Wenn der Benutzer nicht eingeloggt ist, leite zur Anmeldeseite weiter
      return AuthAdminScreen(child: child);
    }

    // Prüfe die Claims des eingeloggten Benutzers
    return FutureBuilder<IdTokenResult>(
      future: user.getIdTokenResult(true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return QWidgets().progressIndicator;
        }

        if (snapshot.hasData) {
          final claims = snapshot.data!.claims;
          final isAdmin = claims?['admin'] == true;

          if (isAdmin) {
            return child;
          } else {
            return AuthAdminScreen(child: child);
          }
        } else {
          return AuthAdminScreen(child: child);
        }
      },
    );
  }
}
