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
    List<Map<String, dynamic>> _results = await DB.query(Entry.table);
    _data = _results.map((item) => Entry.fromMap(item)).toList();
    for (int i = 0; i < _data.length; i++) {
      _cards.add(
        Dismissible(
          key: Key(i.toString()),
          direction: DismissDirection.endToStart,
          child: EntryCard(entry: _data[i]),
          background: Container(
            color: Colors.redAccent,
            child: const Icon(Icons.delete,color: Colors.white,),
          ),
          confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (context)=> AlertDialog(title: Text("Please Confirm "),
                content: Text("Are you sure you want to delete?"),
                actions: [
                  ElevatedButton(onPressed: (){
                    Navigator.of(context).pop(false);
                  }, child: Text("Cancel")),
                  ElevatedButton(onPressed: (){
                    Navigator.of(context).pop(true);
                  }, child: Text("Cancel")),
                ],
                ),);
          },
          onDismissed: ((direction) {
            if (direction == DismissDirection.endToStart) {
            }
            }
          )
        ),
      );
    }
    if (mounted) setState(() {});
  }

  void pushRunToFirebase(String email, String name) async {
    await Firestore()
        .users
        .doc('9999')
        .get()
        .then((value) => null)
        .onError((error, stackTrace) {
      print("print:");
      print(error);
    });
    Firestore().users.doc('ajf').set({'name': 'test'});
  }

  void _addEntries(Entry? en) async {
    if (en == null) {
      return;
    }
    DB.insert(Entry.table, en);
    pushRunToFirebase('ggg', 'yyyy');
    _fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Runs"),
      ),
      body: ListView(
        children: _cards,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MapTrackingPage()))
            .then((value) => _addEntries(value)),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
