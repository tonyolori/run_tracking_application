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
      await createTable();
      maps = await _db!.rawQuery(
          'SELECT * FROM $tableName WHERE $columnYear = $year and $columnMonth = $month and  $columnDay = $day');
    }

    return convertToStepList(maps);
  }

  static Future<List<Step>> getStepsInMonth(int month) async {

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> unFilteredMaps = await _db!.query(tableName);
    final List<Map<String, dynamic>> filteredMaps = unFilteredMaps.where((map) {
      DateTime stepTime = DateTime.parse(map[columnTime]);
      return stepTime.month == month;
    }).toList();

    // Convert the List<Map<String, dynamic> into a List<step>.
    return convertToStepList(filteredMaps);
  }

  /// you write quotes like this `yup yup`
  static Future<List<Step>> getStepsInWeek(int month, int day) async {

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> unFilteredMaps = await _db!.query(tableName);
    final List<Map<String, dynamic>> filteredMaps = unFilteredMaps.where((map) {
      DateTime stepTime = DateTime.parse(map[columnTime]);

      if (stepTime.month == month) {
        //greater than 7 then we can safely minus 7
        // return true for the days within that
        if (day > 6) {
          //the difference between the day we are comparing with and the given day is less than 7
          int difference = stepTime.day - day;

          if (difference.abs() < 7) {
            return true;
          } else {
            return false;
          }
        }
        //minusing 7 will leader to the former month for now we return true
        else {
          return true;
        }
      } else {
        return false;
      }
    }).toList();

    // Convert the List<Map<String, dynamic> into a List<step>.
    return convertToStepList(filteredMaps);
  }

  // Convert the Liste<Map<String, dynamic> into a List<step>.
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

// Future<void> updateStep(Step step) async {
//   // Get a reference to the database.
//   final db = await openDatabase(
//     join(await getDatabasesPath(), 'fitwork_database.db'),
//     version: 1,
//   );

//   // Update the given Dog.
//   await db.update(
//     'Steps',
//     step.toMap(),
//     // Ensure that the Dog has a matching id.
//     where: 'id = ?',
//     // Pass the Dog's id as a whereArg to prevent SQL injection.
//     whereArgs: [step.id],
//   );
// }
