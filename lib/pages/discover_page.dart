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
              stream: Firestore().users
                  .orderBy(
                      isInYourAreaSelected
                          ? 'area' 
                          : 'activity',
                      descending: isMostActiveSelected)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: SizedBox(height:20,width:20,child: CircularProgressIndicator()));
                }

                if (snapshot.data ==null) {
                  return const Text('Error: No Data found.');
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Text('No users found.');
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> userData =
                        document.data() as Map<String, dynamic>;
                    String username = userData[
                        'username']; // Change 'username' to the actual field name for username in your user data
                    String profileImageUrl = userData[
                        'profileImageUrl']; // Change 'profileImageUrl' to the actual field name for profile image URL in your user data
                    double topRunKms = userData[
                        'topRunKms']; // Change 'topRunKms' to the actual field name for top run in kms in your user data

                    return ListTile(
                      leading: Image.network(profileImageUrl),
                      title: Text(username),
                      subtitle: Text('Top Run: $topRunKms km'),
                      trailing: IconButton(
                        icon: Icon(Icons.person_add),
                        onPressed: () {
                          // Add friend functionality here
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
