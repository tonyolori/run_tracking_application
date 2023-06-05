import 'package:fit_work/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firestore.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  bool isInYourAreaSelected = false;
  bool isMostActiveSelected = false;
  List<bool> isRequestSentList = [];
  List<RequestStatus> requestStatus = [];
  final userID = Auth().currentUser!.uid;
  List<String> friendsList = [];
  final noneFriendsList = <String>[];
  bool friendsListFetched = false;

  void fetchFriendsList() async {
    friendsList = await Firestore().fetchFriendsList(userID);
    
    setState(() {
      friendsListFetched = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFriendsList();
  }

  void _showFriendRequestsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Friend Requests'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: requestStatus.length,
              itemBuilder: (BuildContext context, int index) {
                RequestStatus status = requestStatus[index];
                return ListTile(
                  //title: Text(status.username),
                  title: Text("one"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          // Accept friend request
                          //Firestore().acceptFriendRequest(status.senderId, userID);
                          setState(() {
                            requestStatus.removeAt(index);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          // Reject friend request
                          //Firestore().rejectFriendRequest(status.senderId, userID);
                          setState(() {
                            requestStatus.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              _showFriendRequestsDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isInYourAreaSelected = true;
                    isMostActiveSelected = false;
                  });
                },
                child: Text('In Your Area'),
                style: ButtonStyle(
                  backgroundColor: isInYourAreaSelected
                      ? MaterialStateProperty.all(Colors.blue)
                      : null,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isInYourAreaSelected = false;
                    isMostActiveSelected = true;
                  });
                },
                child: Text('Most Active'),
                style: ButtonStyle(
                  backgroundColor: isMostActiveSelected
                      ? MaterialStateProperty.all(Colors.blue)
                      : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore()
                  .users
                  .orderBy(isInYourAreaSelected ? 'area' : 'topRunKm', descending: isMostActiveSelected)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting || !friendsListFetched) {
                  return const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No users found.');
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
                    String username = userData[fusername];
                    String profileImageUrl = userData[fprofileImageURL];
                    String receiverId = document.id;
                    String senderId = Auth().currentUser!.uid;
                    int topRunKms = 0;
                    String area = "lefke";
                    if (!isInYourAreaSelected) {
                      topRunKms = userData[fTopRun];
                    } else {
                      area = userData[fArea];
                    }

                    // This filters for only people not in the friends list
                    if (friendsList.contains(receiverId) || receiverId == senderId) {
                      return const SizedBox.shrink();
                    } else {
                      noneFriendsList.add(receiverId);
                    }

                    // Check if friend request has been sent
                    bool isRequestSent = isRequestSentList.length > index && isRequestSentList[index] == true;
                    isRequestSentList.add(isRequestSent);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(profileImageUrl),
                      ),
                      title: Text(username),
                      subtitle: isInYourAreaSelected
                          ? Text('Area: $area')
                          : Text('Top Run: $topRunKms km'),
                      trailing: IconButton(
                        icon: isRequestSent
                            ? const Icon(Icons.check) // Icon to show when request is sent
                            : const Icon(Icons.person_add),
                        onPressed: () {
                          if (!isRequestSent) {
                            Firestore().sendFriendRequest(senderId, receiverId);
                            setState(() {
                              isRequestSentList[index] = true;
                              isRequestSent = true;
                            });
                          } else {
                            Firestore().cancelFriendRequest(senderId, receiverId);
                            setState(() {
                              isRequestSentList[index] = false;
                              isRequestSent = false;
                            });
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          noneFriendsList.isEmpty
              ? const Center(child: Text("All Users Added"))
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
