import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rigging_quiz/Screens/live_quiz_screen/quiz_manager.dart';
import 'package:rigging_quiz/Screens/management_system.dart/category_list_screen.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/SignInPage.dart';
import 'package:rigging_quiz/Screens/home_page.dart';
import 'package:rigging_quiz/main_web.dart';
import 'package:rigging_quiz/utils/admin_auth/auth_screen.dart';
import 'package:rigging_quiz/utils/score_service.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rigging_quiz/SignInPage.dart';
import 'package:rigging_quiz/Screens/home_page.dart';
import 'package:rigging_quiz/Screens/friends/duel_game_screen.dart';
import 'package:rigging_quiz/Screens/friends/game_service.dart';
void main() async {
  setPathUrlStrategy();
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

class MyApp extends StatefulWidget {
  final GoRouter _router;

  MyApp({super.key})
      : _router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) {
          return const AuthAdminScreen(
              child: CategoryListScreen());
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RiggingQuiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: widget._router,
    );
  }
}




class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  User? _user;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<DatabaseEvent>? _duelSubscription;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GameService _gameService = GameService();

  @override
  void initState() {
    super.initState();
    // Authentifizierungsstatus abonnieren
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
      if (_user != null) {
        _startDuelListener();
      } else {
        _duelSubscription?.cancel();
      }
    });
  }

  void _startDuelListener() {
    final userUid = _user?.uid;
    if (userUid == null) return;

    _duelSubscription = FirebaseDatabase.instance
        .ref()
        .child('game_sessions')
        .orderByChild('friendUid')
        .equalTo(userUid)
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        for (final child in event.snapshot.children) {
          final data = Map<String, dynamic>.from(child.value as Map);
          if (data['status'] == 'pending') {
            _showDuelRequestDialog(
              fromUid: data['requesterUid'],
              categoryId: data['categoryId'],
              gameId: data['gameId'],
            );
          }
        }
      }
    }, onError: (error) {
      debugPrint("Fehler beim Abonnieren des Streams: $error");
    });
  }

  Future<void> _showDuelRequestDialog({
    required String fromUid,
    required String categoryId,
    required String gameId,
  }) async {
    if (!mounted) return;

    final userRef = FirebaseDatabase.instance.ref().child('users/$fromUid');
    final userSnapshot = await userRef.get();

    if (!userSnapshot.exists) {
      debugPrint("User-Daten für $fromUid nicht gefunden.");
      return;
    }

    final userData = Map<String, dynamic>.from(userSnapshot.value as Map);
    String requesterName = userData['name'] ?? 'Unknown User';
    String requesterAvatar = userData['avatarUrl'] ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Spiel Anfrage'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  child: requesterAvatar.isEmpty
                      ? const Icon(Icons.person)
                      : Text(requesterAvatar[0].toUpperCase()),
                ),
                const SizedBox(height: 10),
                Text(
                  '$requesterName glaubt, er hätte eine Chance gegen dich. Beweise das Gegenteil!',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_user != null) {
                  await _gameService.declineDuelRequest(gameId, _user!.uid);
                }
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Ablehnen'),
            ),
            TextButton(
              onPressed: () async {
                if (_user != null) {
                  await _gameService.acceptDuelRequest(gameId, _user!.uid);
                  await _gameService.startGameSession(gameId);
                }
                Navigator.of(dialogContext).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DuelGameScreen(
                      gameId: gameId,
                      playerUid: _user?.uid ?? "",
                    ),
                  ),
                );
              },
              child: const Text('Annehmen'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _duelSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_user != null) {
      return const HomeScreen();
    } else {
      return const SignInPage();
    }
  }
}
