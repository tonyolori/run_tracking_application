import 'dart:math';

class UserModel {
  String name;
  int age;
  double height;
  double weight;

  late double BMI;

  UserModel({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
  }) {
    BMI = weight / pow(height / 100, 2);
  }
}
