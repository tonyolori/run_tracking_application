import 'dart:math';
import '../db/step_db.dart';
import 'dummy_data.dart';

//enum TimeFrame {year,month, week }
final List<String> timeframe = <String>[
  'Monthly',
  'Daily',
];

class StepWorker {
  bool databasefilled =
      false; //change this to be gotten from shared preferences
  List<Map<String, dynamic>> constructedbar = dummyBarData;
  List<Map<String, Object>> barData = []; //dummyBarData[0]['data'];

  StepWorker();

  Future<List<Map<String, dynamic>>> constructBarData(String choice) async {
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

    return constructedbar;
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

    var stepsInMonth = await StepDatabase.getStepsInDay(date);
    for (int i = 0; i < stepsInMonth.length; i++) {
      stepcount = stepcount + stepsInMonth[i].stepCount;
    }

    if (stepcount == 0) {
      return Random().nextInt(5000) + 3000;
    }
    return stepcount;
  }

  Future<bool> fillDatabase() async {
    var steps = StepDatabase.convertToStepList(stepMaps);

    for (int i = 0; i < steps.length; i++) {
      StepDatabase.insertStep(steps[i]);
    }

    databasefilled = true;
    return true;
  }
}
