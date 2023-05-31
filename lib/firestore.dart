import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  CollectionReference get users => _firebaseFirestore.collection('users');
  CollectionReference get leaderboard =>
      _firebaseFirestore.collection('leaderboard');
  final name = "name";
  final distanceRun = "topRunKm";

  dynamic retrievedName;

  Future<List<Map<String, dynamic>>> fetchLeaderboardData() async {
    List<Map<String, dynamic>> leaderboardData = [];

    await leaderboard
        .orderBy(distanceRun, descending: true)
        .limitToLast(20)
        .get()
        .then((event) {
      //QueryDocumentSnapshot data = event.docs[0] as Map<String, dynamic>;
      leaderboardData =
          event.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
    return leaderboardData; // Assign the data to the leaderboard future
  }
}
