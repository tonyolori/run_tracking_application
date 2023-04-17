import 'dart:math';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../db/step_db.dart';
import '../model/step_model.dart' as step;
import 'package:pedometer/pedometer.dart';

//enum TimeFrame {year,month, week }
final List<String> timeframe = <String>[
  'Monthly',
  'Daily',
];

class StepHelper with ChangeNotifier {
  bool databasefilled =
      false; //change this to be gotten from shared preferences
  String choice = "Monthly";
  List<Map<String, dynamic>> constructedbar = _dummyBarData;
  List<Map<String, dynamic>> constructedbarweekly = _dummyBarDataWeekly;
  List<Map<String, Object>> barData = _dummyBarData[0]['data'];
  List<step.Step> availableSteps = [];
  //db
  late Stream<StepCount> _pedometer;
  late var _subscription;
  int todaysteps = 0;
  String steps = "0";

  //get barData ->

  StepHelper() {
    _innit();
  }
  _innit() async {
    await StepDatabase.innit().then((value) => fillStepData());
    if (!databasefilled) {
      fillDatabase();
    }

    startListening();
  }

  void startListening() async {
    await Permission.activityRecognition.request().isGranted;
    _pedometer = Pedometer.stepCountStream;
    _subscription = _pedometer.listen(
      _onStepCount,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: true,
    );
  }

  void stopListening() {
    _subscription.cancel();
  }

  void _onDone() => print("Finished pedometer tracking");
  void _onError(error) => print("Flutter Pedometer Error: $error");

  void _onStepCount(StepCount event) {
    steps = event.steps.toString();
    print("Stephelper:$steps");
    notifyListeners();
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
          'domain': _toMonthSt(i + 1),
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
          'domain': _toDaySt(dates[i].weekday),
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

  String _toMonthSt(int month) {
    switch (month) {
      case 1:
        return "jan";

      case 2:
        return "feb";

      case 3:
        return "mar";

      case 4:
        return "apr";

      case 5:
        return "may";

      case 6:
        return "jun";

      case 7:
        return "jul";

      case 8:
        return "aug";

      case 9:
        return "sept";

      case 10:
        return "oct";

      case 11:
        return "nov";

      case 12:
        return "dec";

      default:
        return "invalid";
    }
  }

  String _toDaySt(int day) {
    switch (day) {
      case 7:
        return "Sunday";

      case 1:
        return "Monday";

      case 2:
        return "Tuesday";

      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";

      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      default:
        return " invalid entry";
    }
  }
}

List<Map<String, dynamic>> _dummyBarData = [
  {
    'id': 'Bar',
    'data': [
      {'domain': 'jan', 'measure': 3},
      {'domain': 'feb', 'measure': 4},
      {'domain': 'march', 'measure': 6},
      {'domain': 'april', 'measure': 0.3},
      {'domain': 'may', 'measure': 3},
      {'domain': 'june', 'measure': 4},
      {'domain': 'july', 'measure': 6},
      {'domain': 'Aug', 'measure': 0.3},
      {'domain': 'Sept', 'measure': 3},
      {'domain': 'Oct', 'measure': 4},
      {'domain': 'Nov', 'measure': 6},
      {'domain': 'Dec', 'measure': 0.3},
    ],
  },
];

List<Map<String, dynamic>> maps = [
  {
    step.columnStepCount: 1900,
    step.columnTime: "2023-01-01 18:08:46.385056",
  },
  {
    step.columnStepCount: 1400,
    step.columnTime: "2023-02-01 18:08:46.385056",
  },
  {
    step.columnStepCount: 1100,
    step.columnTime: "2023-03-01 18:08:46.385056",
  },
  {
    step.columnStepCount: 1340,
    step.columnTime: "2023-03-02 18:08:46.385056",
  },
  {
    step.columnStepCount: 1300,
    step.columnTime: "2023-03-03 18:08:46.385056",
  },
  {
    step.columnStepCount: 1400,
    step.columnTime: "2023-03-04 18:08:46.385056",
  },
  {
    step.columnStepCount: 2500,
    step.columnTime: "2023-03-05 18:08:46.385056",
  },
  {
    step.columnStepCount: 1900,
    step.columnTime: "2023-03-06 18:08:46.385056",
  },
  {
    step.columnStepCount: 2000,
    step.columnTime: "2023-03-07 18:08:46.385056",
  },
  {
    step.columnStepCount: 2500,
    step.columnTime: "2023-03-08 18:08:46.385056",
  },
  {
    step.columnStepCount: 3000,
    step.columnTime: "2023-03-09 18:08:46.385056",
  },
  {
    step.columnStepCount: 2000,
    step.columnTime: "2023-03-10 18:08:46.385056",
  },
  {
    step.columnStepCount: 1500,
    step.columnTime: "2023-03-11 18:08:46.385056",
  },
  {
    step.columnStepCount: 1100,
    step.columnTime: "2023-03-12 18:08:46.385056",
  },
  {
    step.columnStepCount: 2300,
    step.columnTime: "2023-03-13 18:08:46.385056",
  },
  {
    step.columnStepCount: 1400,
    step.columnTime: "2023-03-14 18:08:46.385056",
  },
  {
    step.columnStepCount: 1900,
    step.columnTime: "2023-03-15 18:08:46.385056",
  },
  {
    step.columnStepCount: 1000,
    step.columnTime: "2023-03-16 18:08:46.385056",
  },
  {
    step.columnStepCount: 3000,
    step.columnTime: "2023-03-17 18:08:46.385056",
  },
  {
    step.columnStepCount: 1200,
    step.columnTime: "2023-04-01 18:08:46.385056",
  },
  {
    step.columnStepCount: 1900,
    step.columnTime: "2023-05-01 18:08:46.385056",
  },
  {
    step.columnStepCount: 2100,
    step.columnTime: "2023-06-01 18:08:46.385056",
  },
];

List<Map<String, dynamic>> _dummyBarDataWeekly = [
  {
    'id': 'Bar',
    'data': [
      {'domain': 'Sun', 'measure': 6},
      {'domain': 'Mon', 'measure': 3},
      {'domain': 'Tues', 'measure': 4},
      {'domain': 'Wed', 'measure': 6},
      {'domain': 'Thur', 'measure': 0.3},
      {'domain': 'Fri', 'measure': 3},
      {'domain': 'Sat', 'measure': 4},
    ],
  },
];
