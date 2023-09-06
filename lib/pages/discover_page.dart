import 'package:fit_work/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firestore.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  bool isInYourAreaSelected = true;
  bool isMostActiveSelected = false;
  List<bool> isRequestSentList = [];
  List<Map<String, dynamic>> friendRequests = [];
  final userID = Auth().currentUser!.uid;
  List<String> friendsList = ['hafhdhasf']; //TODO:check this out later
  final noneFriendsList = <String>[];
  bool friendsListFetched = false;

  void fetchFriendsList() async {
    friendsList = await Firestore().fetchFriendIds(userID);

    if (mounted) {
      setState(() {
        friendsListFetched = true;
      });
    }
  }

  void fetchfriendRequests() async {
    friendRequests =
        await Firestore().fetchFriendRequestsList(Auth().currentUser!.uid);
  }

  @override
  void initState() {
    super.initState();
    fetchFriendsList();
    fetchfriendRequests();
  }

  void _showFriendRequestsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Friend Requests'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: friendRequests.length,
              itemBuilder: (BuildContext context, int index) {
                final request = friendRequests[index];
                String username = request[fusername];
                String profileImageUrl = request[fprofileImageURL] ??
                    "gs://fitwork-maps.appspot.com/profile_images/ZF0ynO7YykVpxBf6EvEDmr1YJBl1-1685534265718";
                String receiverId = request[fid];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(profileImageUrl),
                  ),
                  title: Text(username),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          // Accept friend request
                          Firestore().acceptFriendRequest(userID, receiverId);
                          setState(() {
                            friendRequests.removeAt(index);
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          // Reject friend request
                          Firestore().removeFriend(userID, receiverId);
                          setState(() {
                            friendRequests.removeAt(index);
                            Navigator.of(context).pop();
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
              child: const Text('Close'),
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
        title: const Text('Find friends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
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
                style: ButtonStyle(
                  backgroundColor: isInYourAreaSelected
                      ? MaterialStateProperty.all(Colors.blue)
                      : MaterialStateProperty.all(Colors.grey),
                ),
                child: const Text('In Your Area'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isInYourAreaSelected = false;
                    isMostActiveSelected = true;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: isMostActiveSelected
                      ? MaterialStateProperty.all(Colors.blue)
                      : MaterialStateProperty.all(Colors.grey),
                ),
                child: const Text('Most Active'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore()
                  .users
                  .orderBy(isInYourAreaSelected ? 'area' : 'topRunKm',
                      descending: isMostActiveSelected)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting ||
                    !friendsListFetched) {
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
                    Map<String, dynamic> userData =
                        document.data() as Map<String, dynamic>;
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

                    // make a long enough list
                    if (isRequestSentList.length <= index) {
                      isRequestSentList.add(false);
                    }

                    // This filters for only people not in the friends list
                    if (friendsList.contains(receiverId) ||
                        receiverId == senderId) {
                      return const SizedBox.shrink();
                    } else {
                      noneFriendsList.add(receiverId);
                    }
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(profileImageUrl),
                      ),
                      title: Text(username),
                      subtitle: isInYourAreaSelected
                          ? Text('Area: $area')
                          : Text('Top Run: $topRunKms km'),
                      trailing: IconButton(
                        icon: isRequestSentList[index]
                            ? const Icon(Icons
                                .check) // Icon to show when request is sent
                            : const Icon(Icons.person_add),
                        onPressed: () {
                          setState(() {
                            if (!isRequestSentList[index]) {
                              Firestore()
                                  .sendFriendRequest(senderId, receiverId);
                            } else {
                              Firestore().removeFriend(senderId, receiverId);
                            }
                            isRequestSentList[index] =
                                !isRequestSentList[index];
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          //?figure this out in the demo
          // noneFriendsList.isEmpty && friendsListFetched
          //     /? const Center(child: Text("All Users Added"))
          //     : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
