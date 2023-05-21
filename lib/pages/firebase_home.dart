import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import 'package:flutter/material.dart';

class FirebaseHomePage extends StatelessWidget {
  FirebaseHomePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> signout() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signout,
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _userUid(),
            _signOutButton(),

          ],
        ),
      ),
    );
  }
}
