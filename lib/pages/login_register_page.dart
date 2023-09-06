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
      print(imageUrl);
      return imageUrl;
      // Save the image URL to the user's profile data in Firestore
      //   await Firestore().users.doc(userId).update({
      //     'profileImageUrl': imageUrl,
      //   });
      // }
    } else {
      String imageUrl = "https://firebasestorage.googleapis.com/v0/b/fitwork-maps.appspot.com/o/profile_images%2FzWIbt5rPNXNKtvpad9xz3KSsaXs1-1686219268146?alt=media&token=0cfc0e38-5b95-4d28-a6fe-863470009dce";
      return imageUrl;
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
        'id': uid,
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
          child: const Text('Choose Profile Image'),
        ),
      ],
    );
  }

  List<String> acceptedOptions = [
    'Lefke',
    'Lefkosa',
    'Gönyeli',
    'Girne',
    'Güzelyurt',
    'İskele',
  ];

  Widget _buildAreaTextField() {
    _controllerArea.text = acceptedOptions[0];
    return _areaField('Area', _controllerArea);
  }

  Widget _areaField(
    String title,
    TextEditingController controller,
  ) {
    String? selectedValue = controller.text;
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: title,
      ),
      items: acceptedOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          controller.text = newValue;
        }
      },
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
              const SizedBox(height: 20),
              _submitButton(),
              const SizedBox(height: 20),
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
