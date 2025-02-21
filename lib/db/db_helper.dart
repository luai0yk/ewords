import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  /*Create an instance of DBHelper class using
  * Singleton pattern which assures that one only instance
  * is used all over the project*/
  //static final DBHelper _instance = DBHelper._intern();
  //factory DBHelper() => _instance;
  //DBHelper._intern();

  String FAVORITE_WORDS_TABLE_NAME = 'FavoriteWord';
  String WORDS_TABLE_NAME = 'Words';
  String PASSAGES_TABLE_NAME = 'Passages';
  String QUIZ_TABLE_NAME = 'QuizScores';

  /*Create an instance of Database using
  * Singleton pattern*/
  Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  /*Initializing words.db and making a copy of it
  * from the local assets folder to the app's directory*/
  _initDatabase() async {
    /*Getting the path directory of the app*/
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    /*Combining app's directory path with Database name
    * to get the whole path of it*/
    String path = join(documentsDirectory.path, "words.db");
    /*Checking if the Database (words.db) is exited in the app's directory*/
    bool dbExists = await io.File(path).exists();
    if (!dbExists) {
      ByteData data = await rootBundle.load(join("assets/db", "words.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await io.File(path).writeAsBytes(bytes, flush: true);
    }
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  /*The function that creates the favorite words table*/
  onCreate(Database db, int version) async {
    // Execute a SQL command to create a new table in the database
    await db.execute(
      '''
      CREATE TABLE "$FAVORITE_WORDS_TABLE_NAME" (
	          id INTEGER PRIMARY KEY,
	          unit_id	INTEGER NOT NULL,
            book_id	INTEGER NOT NULL,
            word	TEXT NOT NULL UNIQUE,
            definition	TEXT NOT NULL,
            example	TEXT NOT NULL
            )
    ''',
    );
    await db.execute(
      '''
      CREATE TABLE "$QUIZ_TABLE_NAME" (
        id INTEGER PRIMARY KEY,
        unit_id INTEGER NOT NULL,
        book_id INTEGER NOT NULL,
        correct_answers INTEGER NOT NULL
      )
      ''',
    );
  }
}
