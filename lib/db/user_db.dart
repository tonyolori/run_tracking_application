import '../model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  bool readyState = false;
  User() {
    getUserValuesSF();
  }

  static Future<UserModel> getUserValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String name = prefs.getString('name') ?? '';
    String gender = prefs.getString("gender") ?? "Male";// this whole part is bug causing as changes here need to reflect in ui dropdown button
    // int age = prefs.getInt('age') ?? 0;
    String birthday = prefs.getString("birthday") ?? DateTime.now().toString();
    double height = prefs.getDouble("height") ?? 0;
    double weight = prefs.getDouble("weight") ?? 0;

    // readyState = true;

    return UserModel(
        name: name,
        gender: gender,
        birthday: DateTime.parse(birthday),
        height: height,
        weight: weight);
  }

  Future<String> getBmiSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String name = prefs.getString('name') ?? '';
    String gender = prefs.getString("gender") ?? "male";
    // int age = prefs.getInt('age') ?? 0;
    String birthday = prefs.getString("birthday") ?? DateTime.now().toString();
    double height = prefs.getDouble("height") ?? 0;
    double weight = prefs.getDouble("weight") ?? 0;
    return UserModel(
            name: name,
            gender: gender,
            birthday: DateTime.parse(birthday),
            height: height,
            weight: weight)
        .BMI
        .toString();
  }

  Future<void> setUserValuesSF(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance()
      ..setString('name', user.name)
      ..setInt('age', user.age)
      ..setDouble("height", user.height)
      ..setDouble("weight", user.weight)
      ..setString("gender", user.gender)
      ..setString("birthday", user.birthday.toString());
  }
}
