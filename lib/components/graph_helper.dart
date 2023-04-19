import 'dart:math';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../db/step_db.dart';
import '../model/step_model.dart' as step;
import 'package:pedometer/pedometer.dart';
import 'dummy_data.dart';

//enum TimeFrame {year,month, week }
final List<String> timeframe = <String>[
  'Monthly',
  'Daily',
];

class GraphHelper with ChangeNotifier {
  bool databasefilled =
      false; //change this to be gotten from shared preferences
  String choice = "Monthly";
  List<Map<String, dynamic>> constructedbar = dummyBarData;
  List<Map<String, dynamic>> constructedbarweekly = dummyBarDataWeekly;
  List<Map<String, Object>> barData = dummyBarData[0]['data'];
  List<step.Step> availableSteps = [];
  //db
  int todaysteps = 0;
  String steps = "0";

  //get barData ->

  GraphHelper() {
    _innit();
  }
  _innit() async {
    await StepDatabase.innit().then((value) => fillStepData());
    if (!databasefilled) {
      fillDatabase();
    }
  }

  //****************** db functions */

  //this gets the values from db so it can be displayed in progress page
  fillStepData() async {
    await fillDatabase();

    availableSteps = await StepDatabase.getAllSteps();

    await constructBarData(choice);
  }

  Future<void> constructBarData(String choice) async {
    barData = [];
    DateTime time = DateTime.now();

    //Monthly
    if (choice == timeframe[0]) {
      for (int i = 0; i < 11; i++) {
        Map<String, Object> entry = {
          'domain': toMonthSt(i + 1),
          'measure': await _getStepCountInMonth(time, i)
        };
        barData.add(entry);
      }
    }
    //Daily
    else if (choice == timeframe[1]) {
      List<DateTime> dates = getDaysInWeek(from: DateTime.now());

      for (int i = 0; i < dates.length; i++) {
        Map<String, Object> entry = {
          'domain': toDaySt(dates[i].weekday),
          'measure': await _getStepCountInDay(dates[i])
        };

        barData.add(entry);
      }
    }
    constructedbar[0]['data'] = barData;

    notifyListeners();
  }

  _getStepCountInMonth(DateTime date, int month) async {
    int stepcount = 0;

    var stepsInMonth = await StepDatabase.getStepsInMonth(date, month);
    for (int i = 0; i < stepsInMonth.length; i++) {
      stepcount = stepcount + stepsInMonth[i].stepCount;
    }
    return stepcount;
  }

  _getStepCountInWeek(DateTime date, int month) async {
    int stepcount = 0;

    var stepsInMonth =
        await StepDatabase.getStepsInMonth(DateTime.now(), month);
    for (int i = 0; i < stepsInMonth.length; i++) {
      stepcount = stepcount + stepsInMonth[i].stepCount;
    }
    return stepcount;
  }

  _getStepCountInDay(DateTime date) async {
    int stepcount = 0;
    List<DateTime> dates = getDaysInWeek(from: date);

    var stepsInMonth = await StepDatabase.getStepsInDay(date);
    for (int i = 0; i < stepsInMonth.length; i++) {
      stepcount = stepcount + stepsInMonth[i].stepCount;
    }

    if (stepcount == 0) {
      return Random().nextInt(5000) + 3000;
    }
    return stepcount;
  }

  Future<void> fillDatabase() async {
    var steps = StepDatabase.convertToStepList(maps);

    for (int i = 0; i < steps.length; i++) {
      StepDatabase.insertStep(steps[i]);
    }

    databasefilled = true;
    return;
  }
}
