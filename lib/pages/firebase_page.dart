import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../firestore.dart';
import '../auth.dart';

class FirebasePage extends StatefulWidget {
  const FirebasePage({super.key});

  @override
  State<FirebasePage> createState() => _FirebasePageState();
}

class _FirebasePageState extends State<FirebasePage> {
  final myController = TextEditingController();
  final name = "name";
  final topRun = "total_distance_run";
  final User? user = Auth().currentUser;

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

  Widget _title() {
    return const Text('Top Runs');
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> leaderboardList =
        Firestore().fetchLeaderboardData();
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder<List<Map<String, dynamic>>>(
            future: leaderboardList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                List<Map<String, dynamic>> data = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var item = data[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(item['profileImageURL']?? const NetworkImage("gs://fitwork-maps.appspot.com/profile_images/ZF0ynO7YykVpxBf6EvEDmr1YJBl1-1685534265718")),
                      ),
                      title: Text(
                        item[name] ?? '',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Top Run: ${item[topRun] ?? 0} KM",
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
