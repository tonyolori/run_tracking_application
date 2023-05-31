import 'package:fit_work/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? _user;
  String? _name;
  String? _nickname;
  String? _area;
  String? _profileImageURL;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _areaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  void _getUserProfile() async {
    _user = _auth.currentUser;
    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(_user!.uid)
        .get();

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

  Future<void> _updateUserProfile() async {
    _name = _nameController.text;
    _nickname = _nicknameController.text;
    _area = _areaController.text;

    await _firestore.collection('users').doc(_user!.uid).update({
      'name': _name,
      'nickname': _nickname,
      'area': _area,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileImageURL != null
                ? Image.network(
                    _profileImageURL!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : Placeholder(
                    fallbackHeight: 100,
                    fallbackWidth: 100,
                  ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: 'Nickname',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _areaController,
              decoration: InputDecoration(
                labelText: 'Area',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}


class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // Declare variables to store user input
  String? name;
  DateTime? birthday;
  double? height;
  String? gender = 'Male';
  double? weight;

  //user details
  UserModel? userModel;
  // Declare a global key for the form
  final _formKey = GlobalKey<FormState>();

  // Declare controllers for the text fields
  final _bMIController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setModel();
  }

  setModel() async {
    userModel = await User.getUserValuesSF();
    _bMIController.text =
        userModel!.BMI.toStringAsFixed(2); //toStringAsPrecision(4);
    _nameController.text = userModel!.name;
    _birthdayController.text = userModel!.birthday.toString();
    _heightController.text = userModel!.height.toString();
    _weightController.text = userModel!.weight.toString();
    gender = userModel!.gender;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // Dispose the controllers when the state is disposed
    _bMIController.dispose();
    _nameController.dispose();
    _birthdayController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
