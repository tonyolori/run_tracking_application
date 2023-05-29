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
    
    final filteredResults =  await DB.getRunListForUser(user.uid);

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

  void pushRunToFirebase(Entry en) async {
    final user = Auth().currentUser;
    if (user == null) {
      return;
    }
    
    List<Map<String, dynamic>> filteredResults =  await DB.getRunListForUser(user.uid);
    for (var run in filteredResults) {
      if (run["distance"]>en.distance){
        return;
      }
    }

    //to possibly get first before pushing
    // await Firestore()
    //     .users
    //     .doc(user.uid)
    //     .get()
    //     .then((value) => null)
    //     .onError((error, stackTrace) {
    //   print("print:");
    //   print(error);
    // });

    //just push the run to firebase
    Firestore().leaderboard.doc(user.uid).set({
      'email': user.email,
      'name': user.displayName,
      'total_distance_run': (en.distance*1000).toInt()
    });
  }

  void _addEntries(Entry? en) async {
    if (en == null) {
      return;
    }
    await DB.insert(Entry.table, en);
    pushRunToFirebase(en);
    _fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Runs"),
      ),
      body: ListView.builder(
          itemCount: _cards.length,
          itemBuilder: (context, index) {
            return _cards[index];
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MapTrackingPage()))
            .then((value) => _addEntries(value)),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
