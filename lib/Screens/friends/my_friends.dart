import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/Screens/friends/friendservice.dart';
import 'package:rigging_quiz/Screens/friends/game_service.dart';
import 'package:rigging_quiz/Screens/friends/waiting_room_screen.dart';
import 'package:rigging_quiz/Screens/home_page.dart';
import 'package:rigging_quiz/data/user_provider.dart';
import 'package:rigging_quiz/model/quiz_model.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/animatedlogowithshare.dart';
import 'package:rigging_quiz/widgets/avatar.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class MyFriends extends StatefulWidget {
  final QuizCategory? quizCategory;
  const MyFriends({super.key, this.quizCategory});

  @override
  _MyFriendsState createState() => _MyFriendsState();
}

class _MyFriendsState extends State<MyFriends> {
  final FriendService _friendService = FriendService();
  final GameService _gameService = GameService();

  List<Map<String, dynamic>> _friendRequests = [];
  List<Map<String, dynamic>> _friends = [];

  @override
  void initState() {
    super.initState();
    _fetchFriendsAndRequests();
  }

  Future<void> _fetchFriendsAndRequests() async {
    try {
      final data = await _friendService.fetchFriendsAndRequests();
      setState(() {
        _friendRequests =
            List<Map<String, dynamic>>.from(data['friendRequests'] ?? []);
        _friends = List<Map<String, dynamic>>.from(data['friends'] ?? []);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Freunde: $e')),
      );
    }
  }

  Future<void> _acceptRequest(String userId) async {
    try {
      setState(() {
        // Ladeanimation starten
        _friendRequests = _friendRequests.map((request) {
          if (request['id'] == userId) {
            request['isLoading'] = true;
          }
          return request;
        }).toList();
      });

      await _friendService.acceptFriendRequest(userId);

      final friendData = await _friendService.getFriendData(userId);

      setState(() {
        _friendRequests.removeWhere((request) => request['id'] == userId);
        _friends.add({
          'id': userId,
          'name': friendData['name'],
          'avatarUrl': friendData['avatarUrl'] ?? '',
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Annehmen der Anfrage: $e')),
      );
    } finally {
      setState(() {
        // Ladeanimation stoppen
        _friendRequests = _friendRequests.map((request) {
          if (request['id'] == userId) {
            request['isLoading'] = false;
          }
          return request;
        }).toList();
      });
    }
  }

  Future<void> _declineRequest(String userId) async {
    try {
      await _friendService.declineFriendRequest(userId);

      // Lokalen Zustand aktualisieren
      setState(() {
        _friendRequests.removeWhere((request) => request['id'] == userId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Ablehnen der Anfrage: $e')),
      );
    }
  }

  void _sendDuelRequest(String friendUid, String categoryId) async {
    final userService = Provider.of<UserService>(context, listen: false);
    final requesterUid = userService.uid;

    try {
      if (categoryId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bitte wähle eine Kategorie aus.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        return;
      }

      final gameId = await _gameService.sendDuelRequest(
        requesterUid: requesterUid!,
        friendUid: friendUid,
        categoryId: categoryId,
      );

      // Navigate to WaitingRoomScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WaitingRoomScreen(
            gameId: gameId,
            friendUid: friendUid,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Senden der Spielanfrage: $e')),
      );
    }
  }

  Widget _buildFriendRequestTile(Map<String, dynamic> request) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: QColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: QColors.primaryColor,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(6),
          leading: qAvatar(
            avatar: request['avatarUrl'] ?? '',
          ),
          title: QText(text: request['name'] ?? 'Unbekannter Benutzer'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              QButton(
                buttonText: "Annehmen",
                onPressed: () => _acceptRequest(request['id']),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                fontSize: 12,
              ),
              const SizedBox(width: 8),
              QButton(
                buttonText: "Ablehnen",
                onPressed: () => _declineRequest(request['id']),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                fontSize: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendTile(Map<String, dynamic> friend) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: QColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: QColors.primaryColor,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(6),
          leading: qAvatar(
            avatar: friend['avatarUrl'] ?? '',
          ),
          title: QText(text: friend['name'] ?? 'Unbekannter Name'),
          trailing: QButton(
            buttonText: "Spiel starten",
            onPressed: () {
              _sendDuelRequest(friend['id'], widget.quizCategory?.id ?? '');
            },
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QText(
            text:
                "Du hast noch keine Freunde hinzugefügt. Finde deine Freunde und fordere sie zu einem spannenden Quiz heraus!",
            textAlign: TextAlign.center,
            fontSize: 15,
            color: QColors.primaryColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasFriends = _friends.isNotEmpty;
    bool hasFriendRequests = _friendRequests.isNotEmpty;

    return QLayout(
      backButton: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AnimatedLogoWithShare(),
            const SizedBox(height: 20),
            if (hasFriendRequests) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: QText(
                    text: "Freundschaftsanfragen",
                    fontSize: 20,
                    weight: FontWeight.bold,
                    color: QColors.primaryColor,
                  ),
                ),
              ),
              ..._friendRequests.map(_buildFriendRequestTile),
            ],
            const SizedBox(height: 20),
            if (hasFriends) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: QText(
                    text: "Meine Freunde",
                    fontSize: 20,
                    weight: FontWeight.bold,
                    color: QColors.primaryColor,
                  ),
                ),
              ),
              ..._friends.map(_buildFriendTile),
            ] else if (!hasFriendRequests) ...[
              // Leerer Zustand nur anzeigen, wenn keine Freunde und keine Anfragen vorhanden sind
              _buildEmptyState(),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
