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
  String selectedArea = ''; // Store the selected area
  bool showMostActiveOnly = false; // Flag for showing most active only



  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> leaderboardList = Firestore().fetchLeaderboardData();
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Column(
        children: <Widget>[
          _buildFilters(),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: leaderboardList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  List<Map<String, dynamic>> data = snapshot.data!;
                  List<Map<String, dynamic>> filteredData = _filterData(data);
                  return _buildLeaderboard(filteredData);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DropdownButton<String>(
            value: selectedArea,
            onChanged: (String? newValue) {
              setState(() {
                selectedArea = newValue!;
              });
            },
            items: <String>[
              'lefke',
              'Area 2',
              'Area 3',
              // Add more areas from the list stored in Firebase
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Checkbox(
            value: showMostActiveOnly,
            onChanged: (bool? newValue) {
              setState(() {
                showMostActiveOnly = newValue!;
              });
            },
          ),
          Text('Show Most Active Only'),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> data) {
    // Apply filters based on selectedArea and showMostActiveOnly
    List<Map<String, dynamic>> filteredData = data;
    if (selectedArea.isNotEmpty) {
      filteredData = filteredData
          .where((item) => item['area'] == selectedArea)
          .toList();
    }
    if (showMostActiveOnly) {
      filteredData.sort((a, b) => b['activityLevel'].compareTo(a['activityLevel']));
      filteredData = filteredData.take(10).toList(); // Show top 10 most active only
    }
    return filteredData;
  }

  Widget _buildLeaderboard(List<Map<String, dynamic>> data) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        var item = data[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              item['profileImageURL'] ??
                  "gs://fitwork-maps.appspot.com/profile_images/ZF0ynO7YykVpxBf6EvEDmr1YJBl1-1685534265718",
            ),
          ),
          title: Text(
            item['name'] ?? '',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Top Run: ${item['topRun'] ?? 0} KM",
            style: TextStyle(fontSize: 14),
          ),
        );
      },
    );
  }

  Widget _title() {
    return Text('Your App Title');
  }

}
