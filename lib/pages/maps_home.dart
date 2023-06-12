import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_work/auth.dart';
import 'package:flutter/material.dart';
import '../db/run_db.dart';
import '../model/entry.dart';
import 'map_page.dart';
import '../widgets/entry_card.dart';
import '../firestore.dart';

class MapHomePage extends StatefulWidget {
  MapHomePage({Key? key}) : super(key: key);

  @override
  _MapHomePageState createState() => _MapHomePageState();
}

class _MapHomePageState extends State<MapHomePage> {
  late List<Entry> _data;
  List<Dismissible> _cards = [];

  void initState() {
    super.initState();
    DB.init().then((value) => _fetchEntries());
  }

  void _fetchEntries() async {
    _cards = [];
    final user = Auth().currentUser;
    if (user == null) {
      return;
    }

    final filteredResults = await DB.getRunListForUser(user.uid);

    _data = filteredResults.map((item) => Entry.fromMap(item)).toList();
    for (int i = 0; i < _data.length; i++) {
      _cards.add(
        _dismissableWidget(i),
      );
    }
    if (mounted) setState(() {});
  }

  Dismissible _dismissableWidget(int i) {
    return Dismissible(
      key: UniqueKey(), //Key(_data[i].id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Please Confirm "),
            content: Text("Are you sure you want to delete?"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Confirm")),
            ],
          ),
        );
      },
      onDismissed: ((direction) async {
        if (direction == DismissDirection.endToStart) {
          await DB.delete(Entry.table, _data[i].rid);
          setState(() {
            _cards.removeAt(i);
            _data.removeAt(i);
          });
        }
      }),
      child: EntryCard(entry: _data[i]),
    );
  }

  Future<Map<String, String>> _getImageUrlAndArea() async {
    final user = Auth().currentUser;
    DocumentSnapshot snapshot = await Firestore().users.doc(user!.uid).get();

    Map<String, String> temp = {
      'area': snapshot['area'],
      'profileImageURL': snapshot['profileImageURL'],
    };
    return temp;
  }

  void pushRunToFirebase(Entry en) async {
    final user = Auth().currentUser;
    if (user == null) {
      return;
    }

    //get the profile image url
    final imageUrlandArea = await _getImageUrlAndArea();
    //push the run to leaderboard
    Firestore().leaderboard.doc(user.uid).set({
      'email': user.email,
      'name': user.displayName,
      'area': imageUrlandArea['area'],
      'topRunKm': en.distance,
      'profileImageURL': imageUrlandArea['profileImageURL'],
      'id': user.uid,
    });

    Firestore()
        .users
        .doc(user.uid)
        .update({'topRunKm': (en.distance * 1000).toInt()});
  }

  void _addEntries(Entry? en) async {
    if (en == null) {
      return;
    }

    await DB.insert(Entry.table, en);
    _fetchEntries();

    final currentContext = context; // Capture the current context

    final user = Auth().currentUser;
    if (user == null) {
      return;
    }

    List<Map<String, dynamic>> filteredResults =
        await DB.getRunListForUser(user.uid);
    for (var run in filteredResults) {
      if (run["distance"] > en.distance) {
        return;
      }
    }
    showDialog(
      context: currentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Upload'),
          content: Text(
              'You got a new top run. Do you want to Upload the run to the server?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(currentContext).pop(); // Use the captured context
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                Navigator.of(currentContext).pop(); // Use the captured context
                pushRunToFirebase(en);
              },
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
        title: const Text("Run History"),
      ),
      body: _cards.isNotEmpty
          ? ListView.builder(
              itemCount: _cards.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _cards[index];
              })
          : const Center(
              child: Text(
                "You can add your first run by clicking on the + button",
                textAlign: TextAlign.center,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        // onPressed: () {
        //   Map<String, dynamic> map = {
        //     'uid': "2Id8cK0ovHf88ZWzoScRF2dj5Kk2",
        //     'rid': "hgjhkgkgk",
        //     'date': "June 11, 2023 7:41:00 PM",
        //     'duration': "0:3:21",
        //     'speed': 6.2,
        //     'distance': 7.0,
        //   };
        //   _addEntries(Entry.fromMap(map));
        // },
        onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MapTrackingPage()))
            .then((value) => _addEntries(value)),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
