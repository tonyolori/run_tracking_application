import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_work/constants.dart';
import 'package:flutter/material.dart';

class FirebasePage extends StatefulWidget {
  const FirebasePage({super.key});

  @override
  State<FirebasePage> createState() => _FirebasePageState();
}

class _FirebasePageState extends State<FirebasePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference leaderboard =
      FirebaseFirestore.instance.collection('leaderboard');
  final myController = TextEditingController();
  final name = "name";
  final distanceRun = "total_distance_run";

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
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
              const SizedBox(width: 20),
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
          // ElevatedButton(
          //   onPressed: () {
          //     users
          //         .orderBy("full_name", descending: true)
          //         .limitToLast(20)
          //         .get()
          //         .then((event) {
          //       final String data = event.docs
          //           .map((doc) => doc.data() as Map<String, dynamic>)
          //           .toList()[0]['full_name'];
          //       setState(() {
          //         retrievedName = data;
          //       });
          //     });
          //   },
          //   child: const Text("Get"),
          // ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future:
                leaderboardList, // leaderboardList is a Future<List<Map<String, dynamic>>>
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
                              "Distance Ran this week",
                              style: labelBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (var item in data) // Iterate over the retrieved data
                      customTableRow(item[name] ?? '', item[distanceRun] ?? 0),
                  ],
                );
              }
              return const Text("Loading");
            },
          ),
          Text(retrievedName ?? ""),
        ],
      ),
    );
  }

  TableRow customTableRow(String name, int score) {
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
                score.toString(),
                style: graphLabel,
              ),
            ),
          ),
        ),
      ],
    );
  }
}