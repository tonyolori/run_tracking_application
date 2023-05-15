import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const FirebasePage(),
    );
  }
}

class FirebasePage extends StatefulWidget {
  const FirebasePage({super.key});



  @override
  State<FirebasePage> createState() => _FirebasePageState();
}

class _FirebasePageState extends State<FirebasePage> {
  final fb = FirebaseDatabase.instance;
  final myController = TextEditingController();
  final name = "Name";
  dynamic retrievedName;
  @override
  Widget build(BuildContext context) {
    final ref = fb.ref();
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
              ref.child(name).set(myController.text);
            },
            child: Text("Submit"),
          ),
          ElevatedButton(
            onPressed: () {
              ref.child("Name").once().then((event) {
                DataSnapshot data = event.snapshot;
                print(data.value);
                print(data.key);
                setState(() {
                  retrievedName = data.value;
                });
              });
            },
            child: const Text("Get"),
          ),
          Text(retrievedName ?? ""),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
}
