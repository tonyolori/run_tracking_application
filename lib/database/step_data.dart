import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late Future<Database> database;

void main() async {
  // Open the database and store the reference.
  innit();

  // Create a step and add it to the steps table
  var fido = Step(
    id: 0,
    stepCount: 1273,
  );

  await insertStep(fido);

  // Now, use the method above to retrieve all the dogs.
  print(await Steps()); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  fido = Step(
    id: 0,
    stepCount: 990,
  );
  //await updateStep(fido);

  // Print the updated results.
  print(await Steps()); // Prints Fido with age 42.

  // Delete Fido from the database.
  await deleteStep(fido.id);

  // Print the list of dogs (empty).
  print(await Steps());
}

Future<void> deleteStep(int id) async {
  // Get a reference to the database.
  final db = await openDatabase(
    join(await getDatabasesPath(), 'fitwork_database.db'),
    version: 1,
  );

  // Remove a step entry from the database.
  await db.delete(
    'steps',
    where: 'id = ?',
    whereArgs: [id],
  );
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
  print("innited");
}

_oncreate(db, version) {
  // Run the CREATE TABLE statement on the database.
  return db.execute(
    'CREATE TABLE stepTable(id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, steps INT, timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP);',
  );
}

void dropTable() async {
  var db = await database;
  db.execute('drop table stepTable');
  print("table dropped");
}

Future<bool> createTable() async {
  var db = await database;
  if (await db.query('sqlite_master',
          where: 'name = ?', whereArgs: ['stepTable']) ==
      []) {
    _oncreate(db, 1);
  }
  return true;
}

// Define a function that inserts dogs into the database
Future<void> insertStep(Step stepdata) async {
  // Get a reference to the database.
  final db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await createTable();
  // await db.insert(
  //   'stepTable',
  //   stepdata.toMap(),
  //   conflictAlgorithm: ConflictAlgorithm.replace,
  // );
}

Future<List<Step>> Steps() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('stepTable');

  // Convert the List<Map<String, dynamic> into a List<step>.
  return List.generate(maps.length, (i) {
    return Step(
        id: maps[i]['id'],
        stepCount: maps[i]['steps'],
        timeStamp: maps[i]['timestamp']);
  });
}

class Step {
  int id;
  final int stepCount;
  String? timeStamp;

  Step({
    required this.id,
    required this.stepCount,
    this.timeStamp,
  });

  //DateTime get timeStamp => _timeStamp;

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    //'id':id,
    //'timestamp': timeStamp,
    return {
      'steps': stepCount,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Step{id:$id name: $stepCount, time: $timeStamp}';
  }
}

//// class StepCount {
////   late DateTime _timeStamp;
////   int _steps = 0;
//
////   StepCount._(dynamic e) {
////     _steps = e as int;
////     _timeStamp = DateTime.now();
////   }
//
////   int get steps => _steps;
//
////   DateTime get timeStamp => _timeStamp;
//
////   @override
////   String toString() =>
////       'Steps taken: $_steps at ${_timeStamp.toIso8601String()}';
//// }


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