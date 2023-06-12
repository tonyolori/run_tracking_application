import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../model/entry.dart';

abstract class DB {
  static Database? _db;
  static int get _version => 1;

  static Future<void> init() async {
    try {
      String path = await getDatabasesPath();
      String dbpath = p.join(path, 'run_database.db');
      _db = await openDatabase(dbpath, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);//
    }
  }

  static FutureOr<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE entries (
        rid STRING PRIMARY KEY NOT NULL,
        uid STRING,
        date STRING, 
        duration STRING, 
        speed REAL, 
        distance REAL
      )
    ''');
  }
  static Future<List<Map<String, dynamic>>> getRunListForUser(String uid)async{
    List<Map<String, dynamic>> results = await DB.query(Entry.table);
    List<Map<String, dynamic>> filteredResults =
        results.where((result) => result['uid'] == uid).toList();
    return filteredResults;

  }

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      await _db!.query(table);
  static Future<int> insert(String table, Entry item) async =>
      await _db!.insert(table, item.toMap());
  static Future<int> delete(String table, String rid) async =>
      await _db!.delete(table, where: "rid=?", whereArgs: [rid]);
}
