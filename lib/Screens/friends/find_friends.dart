import 'package:flutter/material.dart';
import 'package:rigging_quiz/game_utils/friendservice.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/animatedlogowithshare.dart';
import 'package:rigging_quiz/widgets/avatar.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/textfield.dart';

class FindFriend extends StatefulWidget {
  const FindFriend({super.key});

  @override
  _FindFriendState createState() => _FindFriendState();
}

class _FindFriendState extends State<FindFriend> {
  final TextEditingController _searchController = TextEditingController();
  final FriendService _friendService = FriendService();

  List<Map<String, dynamic>> _searchResults = [];
  List<String> _sentRequests = [];
  List<String> _friends = [];
  bool _hasSearched =
      false; // Zustand, der verfolgt, ob eine Suche durchgeführt wurde

  @override
  void initState() {
    super.initState();
    _loadFriendsAndRequests();
  }

  Future<void> _loadFriendsAndRequests() async {
    try {
      final result = await _friendService.fetchFriendsAndRequests();

      setState(() {
        _sentRequests = result['sentRequests']
                ?.map<String>((req) => req['id'].toString())
                .toList() ??
            [];
        _friends = result['friends']
                ?.map<String>((friend) => friend['id'].toString())
                .toList() ??
            [];
      });
    } catch (e) {
      print("Fehler beim Laden von Freunden und Anfragen: $e");
      setState(() {
        _sentRequests = [];
        _friends = [];
      });
    }
  }

  Future<void> _searchFriends(String searchText) async {
    if (searchText.trim().isEmpty) {
      // Wenn das Suchfeld leer ist, leere die Ergebnisse und setze _hasSearched auf false
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    try {
      final results = await _friendService.searchFriends(searchText);
      setState(() {
        _searchResults = results;
        _hasSearched = true; // Eine Suche wurde durchgeführt
      });
    } catch (e) {
      print("Fehler bei der Suche: $e");
      setState(() {
        _searchResults = [];
        _hasSearched =
            true; // Auch bei Fehler wird _hasSearched auf true gesetzt
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler bei der Suche: $e')),
      );
    }
  }

  Future<void> _sendFriendRequest(String userId) async {
    try {
      await _friendService.sendFriendRequest(userId);
      setState(() {
        _sentRequests.add(userId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Freundschaftsanfrage gesendet!')),
      );
    } catch (e) {
      print("Fehler beim Senden der Anfrage: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Senden der Anfrage: $e')),
      );
    }
  }

  Widget _buildFriendTile(Map<String, dynamic> user) {
    final isRequestSent = _sentRequests.contains(user['id']);
    final isFriend = _friends.contains(user['id']);

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
            avatar: user['avatarUrl'],
          ),
          title: QText(text: user['name']),
          trailing: isFriend
              ? const QText(
                  text: "Bereits befreundet",
                  fontSize: 13,
                )
              : isRequestSent
                  ? Card(
                      color: QColors.primaryColor.withOpacity(0.1),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 6.0),
                        child: QText(
                          text: "Anfrage gesendet",
                          fontSize: 13,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 160,
                      child: QButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        fontSize: 12,
                        icon: Icons.person_add,
                        buttonText: "Hinzufügen",
                        onPressed: () => _sendFriendRequest(user['id']),
                      ),
                    ),
        ),
      ),
    );
  }

  // Widget für den leeren Zustand der Suche
  Widget _buildEmptySearchState() {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QText(
            text:
                "Leider wurden keine Freunde gefunden. Überprüfe deine Suche oder lade Freunde ein, ein Quiz mit dir zu spielen!",
            textAlign: TextAlign.center,
            fontSize: 15,
            color: QColors.white,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QLayout(
      backButton: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Eingabefeld und Suchbutton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: QTextField(
                      labelText: "Freund suchen",
                      controller: _searchController,
                      onSubmitted: (_) =>
                          _searchFriends(_searchController.text),
                    ),
                  ),
                  QButton(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 32),
                    buttonText: "Suchen",
                    backgroundColor: QColors.white,
                    textColor: QColors.primaryColor,
                    onPressed: () {
                      _searchFriends(_searchController.text);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Ergebnisliste oder leere Nachricht
            if (_hasSearched)
              _searchResults.isNotEmpty
                  ? Column(
                      children: _searchResults.map(_buildFriendTile).toList(),
                    )
                  : _buildEmptySearchState(),
            const SizedBox(height: 20),
            // Animiertes Logo unten
            const AnimatedLogoWithShare(shareButton: true),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
