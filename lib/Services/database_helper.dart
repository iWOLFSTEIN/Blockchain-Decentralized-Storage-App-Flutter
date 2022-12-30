import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

class DatabaseHelper with ChangeNotifier {
  static final _databaseName = "database.db";
  static final _databaseVersion = 1;

  static final table = 'user';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnPrivateKey = 'privateKey';
  static final columnTime = 'time';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  DatabaseHelper() {
    _initDatabase();
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $columnName TEXT NOT NULL,
            $columnPrivateKey TEXT NOT NULL,
            $columnTime TEXT NOT NULL
          )
          ''');
    notifyListeners();
  }

  // Helper methods
  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertChildren(Map<String, dynamic> row) async {
    Database db = await instance.database;
    var rowId = await db.insert(table, row);

    return rowId;
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllChildrenRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<void> truncateTable() async {
    Database db = await instance.database;
    await db.execute('DELETE FROM $table;');
  }
}
