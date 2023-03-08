
import 'package:flutter/material.dart';
import '../database/step_data.dart';
import '../database/step.dart' as step;

class StepHelper with ChangeNotifier {
  bool databasefilled = true;
  List<Map<String, dynamic>> constructedbar = _dummyBarData;
  List<Map<String, Object>> barData = _dummyBarData[0]['data'];
  List<step.Step> availableSteps = [];
  late DatabaseCrud database;

  //get barData ->

  StepHelper() {
    database = DatabaseCrud();

    if (!databasefilled) {
      fillDatabase();
    }
  }

  //this gets the values from db so it can be displayed in progress page
  fillStepData() async {
    availableSteps = await database.getAllSteps();

    for (int i = 0; i < availableSteps.length; i++) {
      barData[i]['domain'] = _toMonthSt(availableSteps[i].month);
      barData[i]['measure'] = availableSteps[i].stepCount;
    }
    constructedbar[0]['data'] = barData;
    notifyListeners();
  }

  Future<void> fillDatabase() async {
    var steps = database.convertToStepList(maps);

    for (int i = 0; i < steps.length; i++) {
      database.insertStep(steps[i]);
    }

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
      case 1:
        return "Sunday";

      case 2:
        return "Monday";

      case 3:
        return "Tuesday";

      case 4:
        return "Wednesday";
      case 5:
        return "Thursday";

      case 6:
        return "Friday";
      case 7:
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
    step.columnStepCount: 13000,
    step.columnTime: "2023-01-01 18:08:46.385056",
  },
  {
    step.columnStepCount: 1400,
    step.columnTime: "2023-02-01 18:08:46.385056",
  },
  {
    step.columnStepCount: 11000,
    step.columnTime: "2023-03-01 18:08:46.385056",
  },
  {
    step.columnStepCount: 13400,
    step.columnTime: "2023-03-02 18:08:46.385056",
  },
  {
    step.columnStepCount: 13500,
    step.columnTime: "2023-03-03 18:08:46.385056",
  },
  {
    step.columnStepCount: 13600,
    step.columnTime: "2023-03-04 18:08:46.385056",
  },
];
