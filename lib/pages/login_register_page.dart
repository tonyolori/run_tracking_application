import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import '../firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

File? _imageFile;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerNickname = TextEditingController();
  final TextEditingController _controllerArea = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  void _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImageToFirebase(File imageFile, String userId) async {
    String fileName =
        "$userId-${DateTime.now().millisecondsSinceEpoch.toString()}";
    Reference reference =
        FirebaseStorage.instance.ref().child('profile_images/$fileName');

    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot storageTaskSnapshot = await uploadTask;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<String> _uploadImage() async {
    if (_imageFile != null) {
      final user = Auth().currentUser;

      String userId =
          user!.uid; // Replace with your logic to get the current user's ID

      String imageUrl = await uploadImageToFirebase(_imageFile!, userId);
      return imageUrl;
      // Save the image URL to the user's profile data in Firestore
      //   await Firestore().users.doc(userId).update({
      //     'profileImageUrl': imageUrl,
      //   });
      // }
    } else {
      //TODO: write a function that gives the imaeg url as a default one
      return '';
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createuserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
    final user = Auth().currentUser;
    //create a new firestore document with the users name
    if (user == null) {
      return;
    }

    String uid = user.uid;
    await user.updateDisplayName(_controllerNickname.text);
    final imageUrl = await _uploadImage();
    try {
      await Firestore().users.doc(uid).set({
        'email': _controllerEmail.text,
        'name': _controllerName.text,
        'nickname': _controllerNickname.text,
        'area': _controllerArea.text,
        'topRunKM': 0,
        'profileImageURL': imageUrl,
      });
    } catch (e) {
      print(e);
    }
    try {} catch (e) {
      print(e);
    }
  }

  Widget _title() {
    return const Text('firebase Auth');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : '$errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'login' : 'register'),
    );
  }

  Widget _loginOrRegsiterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'register' : 'login'),
    );
  }

  Widget _buildNameTextField() {
    return _entryField('Name', _controllerName);
  }

  Widget _buildUserNameTextField() {
    return _entryField('Username', _controllerNickname);
  }

  Widget _buildAreaTextField() {
    return _entryField('Area', _controllerArea);
  }

  Widget _buildEmailTextField() {
    return _entryField('Email', _controllerEmail);
  }

  Widget _buildPasswordTextField() {
    return _entryField('Password', _controllerPassword);
  }

  Widget _buildProfileImage() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
        ),
        TextButton(
          onPressed: _selectImage,
          child: Text('Choose Profile Image'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isLogin) _buildProfileImage(),
              if (!isLogin) _buildNameTextField(),
              if (!isLogin) _buildUserNameTextField(),
              if (!isLogin) _buildAreaTextField(),
              _buildEmailTextField(),
              _buildPasswordTextField(),
              _errorMessage(),
              SizedBox(height: 20),
              _submitButton(),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                    isLogin ? 'Create an account' : 'Already have an account?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
