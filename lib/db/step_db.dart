import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/step_model.dart';

abstract class StepDatabase {
  static Database? _db;
  static int get _version => 1;

  static Future<void> innit() async {
    _db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'step_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: onCreate,
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: _version,
    );
  }

  static Future<void> deleteStep(int id) async {
    // Get a reference to the database.
    final db = await openDatabase(
      join(await getDatabasesPath(), 'fitwork_database.db'),
      version: 1,
    );

    // Remove a step entry from the database.
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static onCreate(db, version) {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      '''
      CREATE TABLE $tableName(
        $columnStepCount INT,
        $columnYear INT,
        $columnMonth INT,
        $columnDay INT,
        $columnTime DATETIME default CURRENT_TIMESTAMP,
        primary key ($columnYear,$columnMonth,$columnDay)
        );
  ''',
    );
  }

  static void dropTable() async {
    _db!.execute('drop table $tableName');
  }

  static Future<bool> createTable() async {
    onCreate(_db, 1);

    return true;
  }

  // Define a function that inserts dogs into the database
  static Future<bool> insertStep(Step stepdata) async {
    List<Step> duplicateStep =
        await getStep(stepdata.year, stepdata.month, stepdata.day);

    if ((duplicateStep.isNotEmpty) &&
        (duplicateStep[0].stepCount >= stepdata.stepCount)) {
      return false;
    }

    await _db!.insert(
      tableName,
      stepdata.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  static Future<List<Step>> getAllSteps() async {
    // Get a reference to the database.
    //final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await _db!.query(tableName);

    // Convert the List<Map<String, dynamic> into a List<step>.
    return convertToStepList(maps);
  }

  static Future<List<Step>> getStep(int year, int month, int day) async {
    List<Map<String, dynamic>> maps = [];
    try {
      maps = await _db!.rawQuery(
          'SELECT * FROM $tableName WHERE $columnYear = $year and $columnMonth = $month and  $columnDay = $day');
    } on Exception catch (e) {
      print(e);
    } catch (e) {
      // await createTable();
      // maps = await _db!.rawQuery(
      //     'SELECT * FROM $tableName WHERE $columnYear = $year and $columnMonth = $month and  $columnDay = $day');
    }

    return convertToStepList(maps);
  }

  ///Date is used for year, its dateTime for future expansion
  static Future<List<Step>> getStepsInMonth(DateTime date, int month) async {
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> unFilteredMaps =
        await _db!.query(tableName);
    final List<Map<String, dynamic>> filteredMaps = unFilteredMaps.where((map) {
      DateTime stepTime = DateTime.parse(map[columnTime]);
      return stepTime.year == date.year && stepTime.month == month;
    }).toList();

    // Convert the List<Map<String, dynamic> into a List<step>.
    return convertToStepList(filteredMaps);
  }

  /// you write quotes like this `yup yup`
  /// Return a list of steps that match, down to the month
  static Future<List<Step>> getStepsInWeek(DateTime date) async {
    final List<Map<String, dynamic>> unFilteredMaps =
        await _db!.query(tableName);
    final List<Map<String, dynamic>> filteredMaps = unFilteredMaps.where((map) {
      DateTime stepTime = DateTime.parse(map[columnTime]);
      //monday has a value of 1
      //i want to display, starting from this monday to next monday, all steps

      return true;
    }).toList();

    // Convert the List<Map<String, dynamic> into a List<step>.
    return convertToStepList(filteredMaps);
  }

  /// Return a list of steps that match, down to the day
  static Future<List<Step>> getStepsInDay(DateTime date) async {
    final List<Map<String, dynamic>> unFilteredMaps =
        await _db!.query(tableName);
    final List<Map<String, dynamic>> filteredMaps = unFilteredMaps.where((map) {
      DateTime stepTime = DateTime.parse(map[columnTime]);

      return date.year == stepTime.year &&
          date.month == stepTime.month &&
          date.day == stepTime.day;
    }).toList();

    // Convert the List<Map<String, dynamic> into a List<step>.
    return convertToStepList(filteredMaps);
  }

  // Convert the List <Map<String, dynamic> into a List<step>.
  static List<Step> convertToStepList(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      DateTime time = DateTime.parse(maps[i][columnTime]);
      return Step(
        stepCount: maps[i][columnStepCount] ?? -1,
        time: time,
      );
    });
  }
}

DateTime _findPreviousDay({required DateTime from}) {
  //// Get the number of days to go back to find a saturday
  ////final daysFromSaturday = (from.weekday - DateTime.saturday) % 7;

  return from.subtract(const Duration(days: 1));
}

List<DateTime> findPreviousDays({
  required int count,
  DateTime? from,
}) {
  // End recursion
  if (count == 0) {
    return [];
  }

  // Defaults to now
  final date = from ?? DateTime.now();

  return [_findPreviousDay(from: date)] +
      findPreviousDays(
        count: count - 1,
        from: date.subtract(Duration(days: 1)),
      );
}

///monday  == 1     | Sunday == 7
///
///if we are at wednesday which is [3], i want to receive, both the forward 4 and the backward 2 days
List<DateTime> getDaysInWeek({
  DateTime? from,
}) {
  // Defaults to now
  final date = from ?? DateTime.now();

  return _daySincePreviousMonday(from: date) +
      _daysTillNextMonday(from: date.add(const Duration(days: 1)));
}

List<DateTime> _daySincePreviousMonday({required DateTime from}) {
  // Get the number of days to go back to find a monday
  final daysFromMonday = (from.weekday - DateTime.monday) % 7;
  if (daysFromMonday == 0) return [from];

  return _daySincePreviousMonday(
        from: from.subtract(const Duration(days: 1)),
      ) +
      [from];
}

List<DateTime> _daysTillNextMonday({required DateTime from, int? count}) {
  // Get the number of days to go back to find a monday
  final daysFromMonday = (from.weekday - DateTime.monday) % 7;
  // if count is equal to null then this is not the first time the function has been called
  if (daysFromMonday == 0 && count != null) return [from];

  return [from] +
      _daysTillNextMonday(from: from.add(const Duration(days: 1)), count: 1);
}
