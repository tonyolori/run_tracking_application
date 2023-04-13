import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/calorie_model.dart';

abstract class CalorieDatabase {
  static Database? _db;
  static int get _version => 1;

  static Future<void> innit() async {
    _db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'calorie_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: onCreate,
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: _version,
    );
  }

  static onCreate(db, version) {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      '''
      CREATE TABLE $tableName(
        $columnCalorieCount INT,
        $columnYear INT,
        $columnMonth INT,
        $columnDay INT,
        $columnTime DATETIME default CURRENT_TIMESTAMP,
        primary key ($columnYear,$columnMonth,$columnDay)
        );
  ''',
    );
  }

  // Define a function that inserts dogs into the database
  static Future<bool> insertCalorie(Calorie calorieData) async {
    List<Calorie> duplicateCalorie =
        await getCalorie(calorieData.year, calorieData.month, calorieData.day);

    if ((duplicateCalorie.isNotEmpty) &&
        (duplicateCalorie[0].calorieCount >= calorieData.calorieCount)) {
      return false;
    }

    await _db!.insert(
      tableName,
      calorieData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  static Future<List<Calorie>> getAllCalories() async {
    // Get a reference to the database.
    //final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await _db!.query(tableName);

    // Convert the List<Map<String, dynamic> into a List<step>.
    return convertToCalorieList(maps);
  }

  static Future<List<Calorie>> getCalorie(int year, int month, int day) async {
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

    return convertToCalorieList(maps);
  }

  // Convert the List <Map<String, dynamic> into a List<step>.
  static List<Calorie> convertToCalorieList(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      DateTime time = DateTime.parse(maps[i][columnTime]);
      return Calorie(
        calorieCount: maps[i][columnCalorieCount] ?? -1,
        time: time,
      );
    });
  }
}
