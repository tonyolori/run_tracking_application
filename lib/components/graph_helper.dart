import 'package:flutter/material.dart';
import '../db/calorie_db.dart';
import 'calorie_worker.dart';
import 'dummy_data.dart';

//enum TimeFrame {year,month, week }
final List<String> timeframe = <String>[
  'Monthly',
  'Daily',
];

class GraphHelper with ChangeNotifier {
  bool stepDatabasefilled =
      false; //change this to be gotten from shared preferences
  bool calorieDatabasefilled = false;
  String choice = "Monthly";

  //List<step.Step> availableSteps = [];
  

  List<Map<String, dynamic>> stepBarData = dummyBarData;

  CalorieWorker calorieWorker = CalorieWorker();
  List<Map<String, dynamic>> calorieBarData = dummyCalorieData;

  GraphHelper() {
    _innit();
  }
  _innit() async {
    await CalorieDatabase.innit().then((value) => fillCalorieData());

    constructBarData(choice);
  }

  //this gets the values from db so it can be displayed in progress page
  

  fillCalorieData() async {
    if (!calorieDatabasefilled) {
      await calorieWorker.fillDatabase();
    }
    calorieDatabasefilled = true;
  }

  constructBarData(String choice) async {
    calorieBarData = await calorieWorker.constructBarData(choice);

    notifyListeners();
  }
}
