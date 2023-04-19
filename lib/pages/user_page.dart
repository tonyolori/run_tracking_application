import 'package:fit_work/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../db/user_db.dart';

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
    _nameController.dispose();
    _birthdayController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //! String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    //! Format the date as a string
    //! final formatter = DateFormat('yyyy-MM-dd');
    //! final dateString = formatter.format(date);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Form'),
      ),
      body: SingleChildScrollView(
        // Wrap the form with a SingleChildScrollView to avoid render overflow
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                  controller:
                      _nameController, // Use the controller to get or set the text
                  validator: (value) {
                    // Validate that the input is a positive double
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Save the input to the name variable
                    setState(() {
                      name = value!;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                // Birthday field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Birthday',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        // Show a date picker to select the birthday
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          // Save the input to the birthday variable
                          setState(() {
                            birthday = date;
                          });
                          // Format the date as a string
                          final formatter = DateFormat('yyyy-MM-dd');
                          final dateString = formatter.format(date);
                          // Update the text field with the selected date
                          _birthdayController.text =
                              dateString; // Use the controller to set the text
                        }
                      },
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  controller:
                      _birthdayController, // Use the controller to get or set the text
                  validator: (value) {
                    // Validate that the input is not null or empty
                    if (value == null || value.isEmpty) {
                      return 'Please enter your birthday';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Do nothing as the input is already saved to the birthday variable
                  },
                ),
                const SizedBox(height: 16.0),
                // Height field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller:
                      _heightController, // Use the controller to get or set the text
                  validator: (value) {
                    // Validate that the input is a positive double
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    final doubleValue = double.tryParse(value);
                    if (doubleValue == null || doubleValue <= 0) {
                      return 'Please enter a valid height';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Save the input to the height variable
                    setState(() {
                      height = double.parse(value!);
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                //Gender field
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  value: gender,
                  items: ['Male', 'Female', 'Other']
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  validator: (value) {
                    // Validate that the input is not null
                    if (value == null) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Save the input to the gender variable
                    setState(() {
                      gender = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                // Weight field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller:
                      _weightController, // Use the controller to get or set the text
                  validator: (value) {
                    // Validate that the input is a positive double
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    final doubleValue = double.tryParse(value);
                    if (doubleValue == null || doubleValue <= 0) {
                      return 'Please enter a valid weight';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Save the input to the weight variable
                    setState(() {
                      weight = double.parse(value!);
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                // Submit button
                ElevatedButton(
                  onPressed: () {
                    // Validate and save the form fields
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (gender == null ||
                          name == null ||
                          birthday == null ||
                          height == null ||
                          weight == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Null value for  $birthday, your height is $height cm, your gender is $gender and your weight is $weight kg.'),
                          ),
                        );
                        return;
                      }
                      context.read<User>().setUserValuesSF(UserModel(
                          name: name!,
                          gender: gender!,
                          birthday: birthday ?? DateTime.now(),
                          height: height!,
                          weight: weight!));
                      // Show a snackbar with the user input
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Your birthday is $birthday, your height is $height cm, your gender is $gender and your weight is $weight kg.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
