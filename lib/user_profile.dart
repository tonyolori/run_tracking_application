import 'dart:math';

class UserProfile {
  String name;
  int age;
  double height;
  double weight;
  bool liveTrackingEnabled = true;
  

  late double BMI;

  UserProfile({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
  }) {
    BMI = weight / pow(height / 100, 2);
  }
}
