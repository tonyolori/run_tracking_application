import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fit_work/constants.dart';
import 'package:flutter/material.dart';

class FirebasePage extends StatefulWidget {
  const FirebasePage({super.key});

  @override
  State<FirebasePage> createState() => _FirebasePageState();
}

class _FirebasePageState extends State<FirebasePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final myController = TextEditingController();
  final name = "Name";
  late StreamSubscription _streamSubscription;
  dynamic retrievedName;

  // final leaderboardList = [
  //   {"name": "Nancy hill", "score": "9000"},
  //   {"name": "Jonah hill", "score": "90090"}
  // ];


  Future<List<Map<String, dynamic>>> fetchLeaderboardData() async {
    await Future.delayed(const Duration(seconds: 5)); // Wait for 5 seconds

    // Simulating the data retrieval
    List<Map<String, dynamic>> leaderboardData = [
      {'name': 'John', 'score': "100"},
      {'name': 'Jane', 'score': "200"},
      {'name': 'Alex', 'score': "150"},
    ];

    return leaderboardData; // Assign the data to the leaderboard future
  }

  @override
  void initState() {
    super.initState();
    //_activateListerners();
  }

  // _activateListerners() {
  //   const RUNDATA_PATH = "Name";
  //   _streamSubscription = fb.ref().child(RUNDATA_PATH).onValue.listen((event) {
  //     //final data = new Map<dynamic, dynamic>.from(event.snapshot.value);
  //     setState(() {
  //       retrievedName = event.snapshot.value as String;
  //     });
  //   });
  // }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    //_streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  Future<List<Map<String, dynamic>>> leaderboardList = fetchLeaderboardData();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(name),
              SizedBox(width: 20),
              Expanded(child: TextField(controller: myController)),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              users
                  .add({
                    'full_name': myController.text,
                    'last_name': myController.text,
                  })
                  .then((value) => print("User Added"))
                  .catchError((error) => print("Failed to add user: $error"));
            },
            child: Text("Submit"),
          ),
          ElevatedButton(
            onPressed: () {
              users
                  .orderBy("full_name", descending: true)
                  .limitToLast(20)
                  .get()
                  .then((event) {
                //QueryDocumentSnapshot data = event.docs[0] as Map<String, dynamic>;
                final String data = event.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList()[0]['full_name'];
                setState(() {
                  retrievedName = data;
                });
              });
            },
            child: const Text("Get"),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future:
                leaderboardList, // Assuming leaderboardList is a Future<List<Map<String, dynamic>>>
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                List<Map<String, dynamic>> data =
                    snapshot.data!; // Retrieve the data from the snapshot

                return Table(
                  columnWidths: {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Name",
                              style: labelBold,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Score",
                              style: labelBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (var item in data) // Iterate over the retrieved data
                      customTableRow(item['name']!, item['score']!),
                  ],
                );
              }
              return const Text("Loading");
            },
          ),

          // FutureBuilder(
          //     future: users.doc("users").get(),
          //     builder: ((BuildContext context, snapshot) {
          //       if (snapshot.hasError) {
          //         return Text("Something went wrong");
          //       }
          //       // if (snapshot.hasData && !snapshot.data!.exists) {
          //       //   return Text("Document does not exist");
          //       // }

          //       if (snapshot.connectionState == ConnectionState.done) {

          //             users.orderBy("full_name", descending: true).get().then((event) {
          //       QueryDocumentSnapshot data = event.docs[0];
          //       setState(() {
          //         Map<String, dynamic> data = retrievedName data.data();
          //       });
          //     });

          //         return Text(
          //             "Full Name: ${data['full_name']} ${data['last_name']}");
          //       }

          //       return const Text("loading");
          //     })),
          Text(retrievedName ?? ""),
        ],
      ),
    );
  }

  TableRow customTableRow(String name, String score) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: graphLabel,
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                score,
                style: graphLabel,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LeaderboardModel {
  final String name;
  final int score;

  LeaderboardModel({
    required this.name,
    required this.score,
  });

  factory LeaderboardModel.fromJson(Map json, bool isUser) {
    return LeaderboardModel(
      name: isUser ? 'You' : json['name'],
      score: json['score'],
    );
  }
}
