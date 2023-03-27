import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'step.dart';

//const String columnDate = 'date';

void main() {
  // Open the database and store the reference.
  // getAllSteps();
  // getStepsInMonth(5);
}

class DatabaseCrud {
  bool readyState = false;
  late Future<Database> database;

  DatabaseCrud() {
    innit();
  }

  Future<void> innit() async {
    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'fitwork_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: _oncreate,
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    readyState = true;
  }

  Future<void> deleteStep(int id) async {
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

  _oncreate(db, version) {
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

  void dropTable() async {
    var db = await database;
    db.execute('drop table $tableName');
  }

  Future<bool> createTable() async {
    var db = await database;

    _oncreate(db, 1);

    return true;
  }

  // Define a function that inserts dogs into the database
  Future<bool> insertStep(Step stepdata) async {
    if (!readyState) {
      await innit();
    }

    // Get a reference to the database.
    final db = await database;

    List<Step> duplicateStep =
        await getStep(stepdata.year, stepdata.month, stepdata.day);

    if ((duplicateStep.isNotEmpty) &&
        (duplicateStep[0].stepCount >= stepdata.stepCount)) {
      return false;
    }

    await db.insert(
      tableName,
      stepdata.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  Future<List<Step>> getAllSteps() async {
    if (!readyState) {
      await innit();
    }
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    // Convert the List<Map<String, dynamic> into a List<step>.
    return convertToStepList(maps);
  }

  Future<List<Step>> getStep(int year, int month, int day) async {
    final db = await database;
    List<Map<String, dynamic>> maps = [];
    try {
      maps = await db.rawQuery(
          'SELECT * FROM $tableName WHERE $columnYear = $year and $columnMonth = $month and  $columnDay = $day');
    } on Exception catch (e) {
      print(e);
    } catch (e) {
      await createTable();
      maps = await db.rawQuery(
          'SELECT * FROM $tableName WHERE $columnYear = $year and $columnMonth = $month and  $columnDay = $day');
    }

    return convertToStepList(maps);
  }

  Future<List<Step>> getStepsInMonth(int month) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> unFilteredMaps = await db.query(tableName);
    final List<Map<String, dynamic>> filteredMaps = unFilteredMaps.where((map) {
      DateTime stepTime = DateTime.parse(map[columnTime]);
      return stepTime.month == month;
    }).toList();

    // Convert the List<Map<String, dynamic> into a List<step>.
    return convertToStepList(filteredMaps);
  }

  /// you write quotes like this `yup yup`
  Future<List<Step>> getStepsInWeek(int month, int day) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> unFilteredMaps = await db.query(tableName);
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
  List<Step> convertToStepList(List<Map<String, dynamic>> maps) {
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
