import '../db/calorie_db.dart';
import 'dummy_data.dart';

//enum TimeFrame {year,month, week }
final List<String> timeframe = <String>[
  'Monthly',
  'Daily',
];

class CalorieWorker {
  List<Map<String, dynamic>> constructedbar = dummyCalorieData;
  List<Map<String, Object>> barData = dummyCalorieData[0]['data'];

  CalorieWorker();

  Future<List<Map<String, dynamic>>> constructBarData(String choice) async {
    barData = [];
    DateTime time = DateTime.now();

    //Monthly
    if (choice == timeframe[0]) {
      for (int i = 1; i <= 12; i++) {
        Map<String, Object> entry = {
          'domain': toMonthSt(i),
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

    for (int i = 0; i < calories.length; i++) {
      CalorieDatabase.insertCalorie(calories[i]);
    }

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

    var caloriesInDay = await CalorieDatabase.getCaloriesInDay(date);
    for (int i = 0; i < caloriesInDay.length; i++) {
      caloriecount = caloriecount + caloriesInDay[i].calorieCount;
    }

    return caloriecount;
  }
}
