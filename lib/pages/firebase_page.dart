import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
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
              users.orderBy("full_name", descending: true).get().then((event) {
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
}
