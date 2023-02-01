import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

class DatabaseHelper with ChangeNotifier {
  static final _databaseName = "database.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

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

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE account (
       name VARCHAR(256),
      private_key VARCHAR(256),
      public_key VARCHAR(256),
      address VARCHAR(256),
      created_at int(11)
          )
          ''');

    await db.execute('''
       CREATE TABLE files (
      file_key VARCHAR(256) PRIMARY KEY UNIQUE,
      bid varchar(256),

      name VARCHAR(1024),
      contract_address VARCHAR(256),
      file_size int(11),
      merkle_root VARCHAR(256),
      segments int(11),

      timer_start int(11),
      timer_end int(11),

      time_created int(11),
      last_verified int(11),

      conclude_timeout int(11),
      prove_timeout int(11),
      sha256 VARCHAR(256),
      is_encrypted int(1),

      download_url VARCHAR(512),

      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
''');

    notifyListeners();
  }

  Future<int> insertChildrenInAccountTable(Map<String, dynamic> row) async {
    Database db = await instance.database;
    var rowId = await db.insert('account', row);

    return rowId;
  }

  Future<List<Map<String, dynamic>>>
      queryAllChildrenRowsFromAccountTable() async {
    Database db = await instance.database;
    return await db.query('account', limit: 1);
  }

  Future<void> truncateAccountTable() async {
    Database db = await instance.database;
    await db.execute('DELETE FROM account;');
  }

  Future<int> insertChildrenInFilesTable(Map<String, dynamic> row) async {
    Database db = await instance.database;
    var rowId = await db.insert('files', row);

    return rowId;
  }

  Future<List<Map<String, dynamic>>>
      queryAllChildrenRowsFromFilesTable() async {
    Database db = await instance.database;
    return await db.query('files');
  }

  Future<void> truncatefilesTable() async {
    Database db = await instance.database;
    await db.execute('DELETE FROM files;');
  }
}
