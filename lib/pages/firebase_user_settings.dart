import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firestore.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _auth = FirebaseAuth.instance;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();

  String _email = '';
  String _name = '';
  String _nickname = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userData = await Firestore().users.doc(user.uid).get();
      setState(() {
        _email = user.email ?? '';
        _name = userData['name'];
        _nickname = userData['nickname'];
      });
    }
  }

  Future<void> _updateUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      await Firestore().users.doc(user.uid).update({
        'name': _nameController.text,
        'nickname': _nicknameController.text,
      });
      setState(() {
        _name = _nameController.text;
        _nickname = _nicknameController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _nameController = TextEditingController(text: _name);
    _nicknameController = TextEditingController(text: _nickname);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Email'),
              subtitle: Text(_email),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'Nickname',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateUserData,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
