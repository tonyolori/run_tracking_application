import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../firestore.dart';
import '../auth.dart';

List<String> acceptedOptions = [
  'Lefke',
  'Lefkosa',
  'Gönyeli',
  'Girne',
  'Güzelyurt',
  'İskele',
];

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final myController = TextEditingController();
  final name = "name";
  final topRun = "total_distance_run";
  final User? user = Auth().currentUser;
  List<String> friendsList = [''];
  String selectedArea =
      acceptedOptions[0]; // provide default area, change later to users option
  bool showMostActiveOnly = false; // Flag for showing most active only

  bool friendsListFetched = false;
  void fetchFriendsList() async {
    friendsList = await Firestore().fetchFriendIds(user!.uid);

    if (mounted) {
      setState(() {
        friendsListFetched = true;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchFriendsList();
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
          _buildFilters(),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: leaderboardList,
              builder: (context, snapshot) {
                if (!friendsListFetched) {
                  return const Center(child: CircularProgressIndicator());
                }
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
          // DropdownButton<String>(
          //   value: selectedArea,
          //   onChanged: (String? newValue) {
          //     setState(() {
          //       selectedArea = newValue!;
          //     });
          //   },
          //   items:
          //       acceptedOptions.map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          // ),
          Checkbox(
            value: showMostActiveOnly,
            onChanged: (bool? newValue) {
              setState(() {
                showMostActiveOnly = newValue!;
              });
            },
          ),
          const Text('Show Most Active Only'),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> data) {
    // Apply filters based on selectedArea and showMostActiveOnly
    List<Map<String, dynamic>> filteredData = data;
    if (selectedArea.isNotEmpty) {
      filteredData = filteredData
          .where((item) =>
              friendsList.contains(item['id'])) //&&item['area'] == selectedArea
          .toList();
    }
    if (showMostActiveOnly) {
      filteredData.sort((a, b) => b['topRunKm'].compareTo(a['topRunKm']));
      filteredData =
          filteredData.take(3).toList(); // Show top 10 most active only
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Top Run: ${item[fTopRun] ?? 0} KM",
            style: const TextStyle(fontSize: 14),
          ),
        );
      },
    );
  }

  Widget _title() {
    return const Text('Your Friends');
  }
}
