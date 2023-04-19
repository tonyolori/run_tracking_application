import 'dart:math';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../db/step_db.dart';
import '../model/step_model.dart' as step;
import 'package:pedometer/pedometer.dart';
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
  String choice = "Monthly";

  //List<step.Step> availableSteps = [];
  //db
  int todaysteps = 0;
  String steps = "0";

  StepWorker stepWorker = StepWorker();
  List<Map<String, dynamic>> stepBarData = dummyBarData;

  GraphHelper() {
    _innit();
  }
  _innit() async {
    await StepDatabase.innit().then((value) => fillStepData());
  }

  //this gets the values from db so it can be displayed in progress page
  fillStepData() async {
    if (!stepDatabasefilled) {
      await stepWorker.fillDatabase();
    }
    stepDatabasefilled = true;

    constructBarData(choice);
    await stepWorker.constructBarData(choice);
  }

  constructBarData(String choice) async {
    stepBarData = await stepWorker.constructBarData(choice);

    notifyListeners();
  }
}
