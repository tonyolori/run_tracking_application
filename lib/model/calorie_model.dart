import 'storable_object.dart';

const String tableName = 'CalorieTable';
const String columnCalorieCount = 'caloriesBurned';
const String columnTime = 'time';
const String columnYear = 'year';
const String columnMonth = 'month';
const String columnDay = 'day';

class Calorie implements StorableObject {
  final int calorieCount;
  
  Calorie({
    required this.calorieCount,
    required this.time,
  }) {
    year = time.year;
    month = time.month;
    day = time.day;
  }

  //DateTime get timeStamp => _timeStamp;

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  @override
  Map<String, dynamic> toMap() {
    // if (time == null) {
    //   return {
    //     columnStepCount: stepCount,
    //   };
    // }
    year = time.year;
    month = time.month;
    day = time.day;
    return {
      columnCalorieCount: calorieCount,
      columnTime: time.toString(),
      columnYear: year,
      columnMonth: month,
      columnDay: day,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Step{$columnCalorieCount: $calorieCount, $columnTime: $time,$columnYear: $year, $columnMonth: $month, $columnDay: $day\n}';
  }
  
  @override
  late int day;
  
  @override
  late int month;
  
  @override
  late int year;

  @override
  late DateTime time;
  
  
}
