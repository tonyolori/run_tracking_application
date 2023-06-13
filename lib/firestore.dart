import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

const fname = "name";
const fusername = "nickname";
const fTopRun = "topRunKm";
const fArea = "area";
const fprofileImageURL = "profileImageURL";
const friendsCollection = "friends";
const fstatus = "status";
const fblocked = "blocked";
const faccecpted = "accepted";
const fpending = "pending";
const frejected = "rejected";
const fsenderId = "senderId";
const fnone = "none";
const fid = "id";

enum RequestStatus {
  pending,
  rejected,
  accepted,
  none,
}

class Firestore {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  CollectionReference get users => _firebaseFirestore.collection('users');
  CollectionReference get leaderboard =>
      _firebaseFirestore.collection('leaderboard');

  dynamic retrievedName;

  Future<List<Map<String, dynamic>>> fetchLeaderboardData() async {
    List<Map<String, dynamic>> leaderboardData = [];

    await leaderboard
        .orderBy(fTopRun, descending: true)
        .limitToLast(20)
        .get()
        .then((event) {
      //QueryDocumentSnapshot data = event.docs[0] as Map<String, dynamic>;
      leaderboardData =
          event.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
    return leaderboardData; // Assign the data to the leaderboard future
  }

  Future<void> sendFriendRequest(
      String senderUserId, String receiverUserId) async {
    // Update for sender
    CollectionReference senderFriends =
        users.doc(senderUserId).collection(friendsCollection);

    // Update for receiver
    CollectionReference receiverRequests =
        users.doc(receiverUserId).collection(friendsCollection);

    // Create a map with the friend request data
    Map<String, dynamic> request = {
      'timestamp': DateTime.now(),
      fstatus: fpending,
      fsenderId: senderUserId
    };

    // Store the friend request in Firestore for sender
    await senderFriends.doc(receiverUserId).set(request);

    // Store the friend request in Firestore for receiver
    await receiverRequests.doc(senderUserId).set(request);
  }

  Future<void> removeFriend(String senderUserId, String receiverUserId) async {
    // Update for sender
    CollectionReference senderFriends =
        users.doc(senderUserId).collection(friendsCollection);

    // Update for receiver
    CollectionReference receiverRequests =
        users.doc(receiverUserId).collection(friendsCollection);

    // delete the friend doc in Firestore for sender
    await senderFriends.doc(receiverUserId).delete();

    // delete the friend doc in Firestore for receiver
    await receiverRequests.doc(senderUserId).delete();
  }

  Future<RequestStatus> checkFriendStatus(String userId, String otherId) async {
    // Check if a friend request has already been sent from sender to receiver
    CollectionReference userFriends =
        users.doc(userId).collection(friendsCollection);
    DocumentSnapshot otherDoc = await userFriends.doc(otherId).get();
    if (otherDoc.exists) {
      String status = otherDoc.get(fstatus);
      return convertToRequest(status);
    }

    // No friend request found
    return convertToRequest(fnone);
  }

  Future<List<String>> fetchFriendIds(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('friends')
        .get();

    //final friendsList = snapshot.docs.map((doc) => doc.id).toList();
    final friendsList = snapshot.docs
        .where((doc) => doc[fstatus] == faccecpted)
        .map((doc) => doc.id)
        .toList();
    return friendsList;
  }

  Future<List<String>> _fetchRequestIds(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('friends')
        .get();

    final requestList = snapshot.docs
        .where((doc) => doc[fstatus] == fpending && doc[fsenderId] != userId)
        .map((doc) => doc.id)
        .toList();

    return requestList;
  }

  Future<List<Map<String, dynamic>>> fetchFriendRequestsList(
      String userId) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final userList = snapshot.docs.toList();
    final requestIds = await _fetchRequestIds(userId);

    //get profiles of users who have sent a request
    final requestList =
        userList.where((doc) => requestIds.contains(doc.id)).map((doc) {
      final data = doc.data();
      data[fid] = doc.id;
      return data;
    }).toList();

    return requestList;
  }

// final friendRequestsList = userFriendsList.where((user) => user[]);
//  return friendRequestsList;
  static RequestStatus convertToRequest(String stringValue) {
    RequestStatus status;
    switch (stringValue) {
      case fpending:
        status = RequestStatus.pending;
        break;
      case frejected:
        status = RequestStatus.rejected;
        break;
      case faccecpted:
        status = RequestStatus.accepted;
        break;
      default:
        // Handle any other cases or set a default value
        status = RequestStatus.none;
    }
    return status;
  }

  Future<void> acceptFriendRequest(
      String receiverUserId, String senderUserId) async {
    // Update the friend request status to 'accepted' in the receiver's friends subcollection
    CollectionReference receiverFriends =
        users.doc(receiverUserId).collection(friendsCollection);
    DocumentReference requestDoc = receiverFriends.doc(senderUserId);
    await requestDoc.update({fstatus: faccecpted});
    // Add the receiver to the sender's friends subcollection with 'status' set to 'accepted'
    CollectionReference senderFriends =
        users.doc(senderUserId).collection(friendsCollection);
    DocumentReference friendDoc = senderFriends.doc(receiverUserId);
    await friendDoc.update({fstatus: faccecpted});
  }

  Future<void> blockFriend(String userId, String friendUserId) async {
    // Update the friend status to 'blocked' in both users' friends subcollections
    CollectionReference userFriends =
        users.doc(userId).collection(friendsCollection);
    DocumentReference friendDoc = userFriends.doc(friendUserId);
    await friendDoc.update({'status': 'blocked'});
    CollectionReference friendFriends =
        users.doc(friendUserId).collection(friendsCollection);
    DocumentReference userDoc = friendFriends.doc(userId);
    await userDoc.update({'status': 'blocked'});
  }
}
//