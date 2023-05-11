import 'package:flutter/material.dart';
import '../db/step_db.dart';
import '../db/calorie_db.dart';
import '../model/step_model.dart' as step;
import 'calorie_worker.dart';
import 'dummy_data.dart';
import 'step_worker.dart';

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
  

  StepWorker stepWorker = StepWorker();
  List<Map<String, dynamic>> stepBarData = dummyBarData;

  CalorieWorker calorieWorker = CalorieWorker();
  List<Map<String, dynamic>> calorieBarData = dummyCalorieData;

  GraphHelper() {
    _innit();
  }
  _innit() async {
    await StepDatabase.innit().then((value) => fillStepData());
    await CalorieDatabase.innit().then((value) => fillCalorieData());

    constructBarData(choice);
  }

  //this gets the values from db so it can be displayed in progress page
  fillStepData() async {
    if (!stepDatabasefilled) {
      await stepWorker.fillDatabase();
    }
    stepDatabasefilled = true;
  }

  fillCalorieData() async {
    if (!calorieDatabasefilled) {
      await calorieWorker.fillDatabase();
    }
    calorieDatabasefilled = true;
  }

  constructBarData(String choice) async {
    stepBarData = await stepWorker.constructBarData(choice);
    calorieBarData = await calorieWorker.constructBarData(choice);

    notifyListeners();
  }
}
