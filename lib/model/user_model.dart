import 'dart:math';

class UserModel {
  String name;
  double height;
  double weight;
  DateTime birthday;
  String gender;

  late double BMI;
  late int age;

  UserModel({
    required this.name,
    required this.gender,
    required this.birthday,
    required this.height,
    required this.weight,
  }) {
    BMI = weight / pow(height / 100, 2);
    final now = DateTime.now();
    age = now.difference(birthday).inDays ~/ 365;

  }
}
