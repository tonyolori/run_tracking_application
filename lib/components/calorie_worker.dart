import 'dart:math';
import '../db/calorie_db.dart';
import 'dummy_data.dart';

//enum TimeFrame {year,month, week }
final List<String> timeframe = <String>[
  'Monthly',
  'Daily',
];

class CalorieWorker {
  bool databasefilled =
      false; //change this to be gotten from shared preferences
  List<Map<String, dynamic>> constructedbar = dummyCalorieData;
  List<Map<String, Object>> barData = []; //dummyBarData[0]['data'];

  CalorieWorker();

  Future<List<Map<String, dynamic>>> constructBarData(String choice) async {
    barData = [];
    DateTime time = DateTime.now();

    //Monthly
    if (choice == timeframe[0]) {
      for (int i = 0; i < 11; i++) {
        Map<String, Object> entry = {
          'domain': toMonthSt(i + 1),
          'measure': await _getCalorieCountInMonth(time, i)
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
          'measure': await _getCalorieCountInDay(dates[i])
        };

        barData.add(entry);
      }
    }
    constructedbar[0]['data'] = barData;

    return constructedbar;
  }

  ///this only puts in dummy values for month
  Future<void> fillDatabase() async {
    var calories = CalorieDatabase.convertToCalorieList(calorieMaps);

    /// i have an idea, change the function name to generic. conv to list

    for (int i = 0; i < calories.length; i++) {
      CalorieDatabase.insertCalorie(calories[i]);
    }

    databasefilled = true;
    return;
  }

  _getCalorieCountInMonth(DateTime date, int month) async {
    int caloriecount = 0;

    var caloriesInMonth = await CalorieDatabase.getCaloriesInMonth(date, month);
    for (int i = 0; i < caloriesInMonth.length; i++) {
      caloriecount = caloriecount + caloriesInMonth[i].calorieCount;
    }
    return caloriecount;
  }

  _getCalorieCountInDay(DateTime date) async {
    int caloriecount = 0;
    //List<DateTime> dates = getDaysInWeek(from: date);

    var caloriesInMonth = await CalorieDatabase.getCaloriesInDay(date);
    for (int i = 0; i < caloriesInMonth.length; i++) {
      caloriecount = caloriecount + caloriesInMonth[i].calorieCount;
    }

    if (caloriecount == 0) {
      return Random().nextInt(5000) + 3000;
    }
    return caloriecount;
  }
}
