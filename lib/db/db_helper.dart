import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  String FAVORITE_WORDS_TABLE_NAME = 'FavoriteWord';
  String WORDS_TABLE_NAME = 'Words';
  String PASSAGES_TABLE_NAME = 'Passages';
  String QUIZ_TABLE_NAME = 'QuizScores';

  Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "words.db");
    bool dbExists = await io.File(path).exists();
    if (!dbExists) {
      ByteData data = await rootBundle.load(join("assets/db", "words.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await io.File(path).writeAsBytes(bytes, flush: true);
    }
    return await openDatabase(
      path,
      version: 2, // Increment the version when adding new fields
      onCreate: onCreate,
    );
  }

  // onCreate function to initialize tables
  onCreate(Database db, int version) async {
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
        correct_answers INTEGER NOT NULL,
        taken_at TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP),
        updated_at TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP)
      )
      ''',
    );
  }
}
