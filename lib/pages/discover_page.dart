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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
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
                  .orderBy(isInYourAreaSelected ? 'area' : 'topRunKm',
                      descending: isMostActiveSelected)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator()));
                }

                if (snapshot.data == null) {
                  return const Text('Error: No Data found.');
                }

                if (snapshot.data!.docs.isEmpty) {
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
                    int topRunKms = userData[fTopRun];
                    String receiverId = document.id;
                    String senderId = Auth().currentUser!.uid;

                    // //?change this to be dynamically generated and show the ones on pending
                    // bool isRequestSent = isRequestSentList.length > index &&
                    //     isRequestSentList[index] == true;
                    // isRequestSentList.add(isRequestSent);
                    //?change this to be dynamically generated and show the ones on pending
                    bool isRequestSent = isRequestSentList.length > index &&
                        isRequestSentList[index] == true;
                    isRequestSentList.add(isRequestSent);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(profileImageUrl),
                      ),
                      title: Text(username),
                      subtitle: Text('Top Run: $topRunKms km'),
                      trailing: IconButton(
                        icon: isRequestSent
                            ? const Icon(Icons
                                .check) // Icon to show when request is sent
                            : const Icon(Icons.person_add),
                        onPressed: () {
                          if (!isRequestSent) {
                            Firestore().sendFriendRequest(senderId, receiverId);
                            setState(() {
                              isRequestSentList[index] = true;
                              isRequestSent = true;
                            });
                          } else {
                            Firestore()
                                .cancelFriendRequest(senderId, receiverId);
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
        ],
      ),
    );
  }
}
