import '../model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<UserModel> getBoolValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String name = prefs.getString('name') ?? '';
  int age = prefs.getInt('age') ?? 0;
  double height = prefs.getDouble("height") ?? 0;
  double weight = prefs.getDouble("weight") ?? 0;
  return UserModel(name: name, age: age, height: height, weight: weight);
}

Future<void> setValuesSF(UserModel user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance()
  ..setString('name', user.name)
  ..setInt('age', user.age)
  ..setDouble("height", user.height)
  ..setDouble("weight", user.weight);
}
