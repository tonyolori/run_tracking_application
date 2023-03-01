const String tableName = 'stepTable';
const String columnStepCount = 'steps';
const String columnTime = 'time';
const String columnYear = 'year';
const String columnMonth = 'month';
const String columnDay = 'day';

class Step {
  final int stepCount;
  DateTime? time;
  int? year;
  int? month;
  int? day;

  Step({
    required this.stepCount,
    this.time,
    this.year,
    this.month,
    this.day,
  }) {
    if (time == null) {
      time = DateTime.now();
      year = time?.year;
      month = time?.month;
      day = time?.day;
    }
  }

  //DateTime get timeStamp => _timeStamp;

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    if (time == null) {
      return {
        columnStepCount: stepCount,
      };
    }
    year = time?.year;
    month = time?.month;
    day = time?.day;
    return {
      columnStepCount: stepCount,
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
    return 'Step{$columnStepCount: $stepCount, $columnTime: $time,$columnYear: $year, $columnMonth: $month, $columnDay: $day\n}';
  }
}
