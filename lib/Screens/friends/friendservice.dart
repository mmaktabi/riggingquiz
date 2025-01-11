import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FriendService {
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('users');

  // Auf die Antwort warten
  final DatabaseReference _duelRequestsRef =
      FirebaseDatabase.instance.ref().child('game_sessions');

  // Prüfe, ob ein Spieler gerade aktiv ist
  Future<bool> isPlayerActive(String userId) async {
    final snapshot = await _usersRef.child(userId).child('activeGameId').get();
    return snapshot.exists && snapshot.value != null;
  }

  // Anfrage senden
  Future<void> sendDuelRequest({
    required String currentUserUid,
    required String friendUid,
    required String categoryId,
  }) async {
    try {
      final ref =
          FirebaseDatabase.instance.ref().child('game_sessions/$friendUid');
      final data = {
        'from': currentUserUid,
        'categoryId': categoryId,
        'status': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
      };
      await ref.set(data);
    } catch (e) {
      print('Fehler beim Senden der Spielanfrage: $e');
      throw Exception('Fehler beim Senden der Spielanfrage: $e');
    }
  }

  // Methode, um die Anzahl der Freundschaftsanfragen als Stream bereitzustellen
  Stream<int> getFriendRequestsCountStream(String userUid) {
    return _usersRef.child('$userUid/friends').onValue.map((event) {
      if (event.snapshot.exists) {
        final friendsMap =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        // Zähle die Anzahl der Einträge mit status 'request_received'
        int count = friendsMap.values
            .where((value) => value['status'] == 'request_received')
            .length;
        return count;
      }
      return 0;
    }).handleError((error) {
      print('Fehler beim Abrufen der Freundschaftsanfragen: $error');
      return 0;
    });
  }

  Future<bool> awaitDuelResponse(String friendUid) async {
    final responseRef =
        FirebaseDatabase.instance.ref().child('game_sessions/$friendUid');
    final completer = Completer<bool>();

    responseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        try {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          if (data['status'] == 'accepted') {
            completer.complete(true);
          } else if (data['status'] == 'declined') {
            completer.complete(false);
          }
        } catch (e) {
          completer.completeError("Fehler: $e");
        }
      } else {
        completer.completeError("Keine Daten vorhanden.");
      }
    });

    return completer.future;
  }

// Methode zur Suche von Freunden mit case-insensitive Suche
  Future<List<Map<String, dynamic>>> searchFriends(String searchText) async {
    if (searchText.isEmpty) {
      return [];
    }

    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    String lowercasedSearchText =
        searchText.toLowerCase(); // Suchtext in Kleinbuchstaben

    try {
      final snapshot = await _usersRef
          .orderByChild('searchName')
          .startAt(lowercasedSearchText)
          .endAt('$lowercasedSearchText\uf8ff')
          .limitToFirst(10) // Begrenze die Ergebnisse auf 10
          .get();

      if (snapshot.exists) {
        final Map<dynamic, dynamic> usersMap =
            snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> results = [];

        usersMap.forEach((key, value) {
          if (key != currentUserId) {
            // Ausschluss des aktuellen Benutzers
            final userData = Map<String, dynamic>.from(value);
            results.add({
              'id': key,
              'name': userData['name'] ?? 'Unbekannter Name',
              'avatarUrl': userData['avatarUrl'] ?? '',
            });
          }
        });

        return results;
      }
    } catch (e) {
      print("Fehler bei der Suche: $e");
      throw Exception('Fehler bei der Suche: $e');
    }

    return [];
  }

  // Send a friend request
  Future<void> sendFriendRequest(String friendId) async {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await _usersRef
        .child(currentUserId)
        .child('friends')
        .child(friendId)
        .set({'status': 'request_sent'});

    await _usersRef
        .child(friendId)
        .child('friends')
        .child(currentUserId)
        .set({'status': 'request_received'});
  }

  // Accept a friend request
  Future<void> acceptFriendRequest(String friendId) async {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await _usersRef
        .child(currentUserId)
        .child('friends')
        .child(friendId)
        .set({'status': 'accepted'});

    await _usersRef
        .child(friendId)
        .child('friends')
        .child(currentUserId)
        .set({'status': 'accepted'});
  }

  // Decline a friend request
  Future<void> declineFriendRequest(String friendId) async {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await _usersRef
        .child(currentUserId)
        .child('friends')
        .child(friendId)
        .remove();

    await _usersRef
        .child(friendId)
        .child('friends')
        .child(currentUserId)
        .remove();
  }

  Future<Map<String, dynamic>> getFriendData(String userId) async {
    try {
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userId)
          .get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return {
          'name': data['name'] ?? 'Unbekannter Name',
          'avatarUrl': data['avatarUrl'] ?? '',
        };
      } else {
        throw Exception('Benutzer nicht gefunden.');
      }
    } catch (e) {
      throw Exception('Fehler beim Abrufen der Freund-Daten: $e');
    }
  }

  // Fetch friends and friend requests
  Future<Map<String, dynamic>> fetchFriendsAndRequests() async {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final snapshot =
        await _usersRef.child(currentUserId).child('friends').get();
    List<Map<String, dynamic>> friendRequests = [];
    List<Map<String, dynamic>> sentRequests = [];
    List<Map<String, dynamic>> friends = [];

    if (snapshot.exists && snapshot.value != null) {
      final friendsMap = Map<String, dynamic>.from(snapshot.value as Map);

      for (var entry in friendsMap.entries) {
        final friendId = entry.key;
        final friendData = Map<String, dynamic>.from(entry.value);
        final friendStatus = friendData['status'];

        final userSnapshot = await _usersRef.child(friendId).get();

        if (userSnapshot.exists && userSnapshot.value != null) {
          final userData = Map<String, dynamic>.from(userSnapshot.value as Map);
          final friendInfo = {
            'id': friendId,
            'name': userData['name'] ?? 'Unbekannter Name',
            'avatarUrl': userData['avatarUrl'] ?? '',
          };

          if (friendStatus == 'request_received') {
            friendRequests.add(friendInfo);
          } else if (friendStatus == 'request_sent') {
            sentRequests.add(friendInfo);
          } else if (friendStatus == 'accepted') {
            friends.add(friendInfo);
          }
        }
      }
    }

    return {
      'friendRequests': friendRequests,
      'sentRequests': sentRequests,
      'friends': friends,
    };
  }
}
