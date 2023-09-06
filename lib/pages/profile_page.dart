import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  String? _name;
  String? _nickname;
  String? _area;
  String? _profileImageURL;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  void _getUserProfile() async {
    _user = _auth.currentUser;
    DocumentSnapshot snapshot = await Firestore().users.doc(_user!.uid).get();

    if (mounted) {
      setState(() {
        _name = snapshot['name'];
        _nickname = snapshot['nickname'];
        _area = snapshot['area'];
        _profileImageURL = snapshot['profileImageURL'];
        _nameController.text = _name!;
        _nicknameController.text = _nickname!;
        _areaController.text = _area!;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    _name = _nameController.text;
    _nickname = _nicknameController.text;
    _area = _areaController.text;

    await Firestore().users.doc(_user!.uid).update({
      'name': _name,
      'nickname': _nickname,
      'area': _area,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImageURL != null
                    ? NetworkImage(_profileImageURL!)
                    : null,
                child: _profileImageURL == null
                    ? const Placeholder(fallbackHeight: 100, fallbackWidth: 100)
                    : null,
              ),
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
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(
                labelText: 'Area',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
