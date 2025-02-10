import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/passage_model.dart';
import '../models/word_model.dart';

class DBHelper {
  /*Create an instance of DBHelper class using
  * Singleton pattern which assures that one only instance
  * is used all over the project*/
  static final DBHelper _instance = DBHelper._intern();
  factory DBHelper() => _instance;
  DBHelper._intern();

  /*Create an instance of Database using
  * Singleton pattern*/
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  /*Initializing words.db and making a copy of it
  * from the local assets folder to the app's directory*/
  initDb() async {
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

    /*opening the database (words.db) and giving it a version number*/
    var theDb = await openDatabase(path, version: 1);
    return theDb;
  }

  /*Getting words from database (words.db) depending the query*/
  Future<List<WordModel>> getWords(
      {String unitId = '', String bookId = ''}) async {
    /*Initializing database variable with the db function defined above*/
    var database = await db;
    /*A map to holds retrieved data from the database (words.db)*/
    List<Map<String, dynamic>> wordMap = [];

    /*If parameters are not passed the function will retrieve all data*/
    if (unitId.isEmpty) {
      wordMap = await database!.query('Words');
    }
    /*If parameters are passed the function will retrieve data based on Book_Id and Unit_Id  */
    else {
      wordMap = await database!.rawQuery(
          'SELECT * FROM Words WHERE Book_Id = $bookId and Unit_Id = $unitId');
    }

    /*Converting the retrieved map data into a List<WordModel>
    * by using List.generate loop then returning the converted data to the function*/
    return List.generate(
      wordMap.length,
      (index) => WordModel.fromMap(
        wordMap[index],
      ),
    );
  }

  /*Getting the reading data depending on Book_Id that is passed to the function*/
  Future<List<PassageModel>> getReadings({required int bookId}) async {
    /*Initializing database variable with the db function defined above*/
    var database = await db;
    /*A map to holds retrieved data from the database (words.db)*/
    List<Map<String, dynamic>> readingMap = await database!
        .rawQuery('SELECT * FROM Reading WHERE Book_Id = $bookId');

    /*Converting the retrieved map data into a List<ReadingModel>
    * by using List.generate loop then returning the converted data to the function*/
    return List.generate(
      readingMap.length,
      (index) => PassageModel.fromMap(
        readingMap[index],
      ),
    );
  }
}
