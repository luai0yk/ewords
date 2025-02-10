import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/favorite_word_model.dart';

class FavoriteDBHelper {
  static const String TABLE_NAME = 'FavoriteWord';

  /*Obtain an instance of FavoriteDBHelper class using
  * Singleton pattern which assures that only one instance
  * is used all over the project*/
  static final FavoriteDBHelper _instance = FavoriteDBHelper._intern();
  factory FavoriteDBHelper() => _instance;
  FavoriteDBHelper._intern();

  /*Obtain an instance of Database using
  * Singleton pattern*/
  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /*Creating the database that hold favorite words*/
  _initDB() async {
    String path = join(await getDatabasesPath(), 'favorite.db');
    int version = 1;
    return openDatabase(
      path,
      version: version,
      onCreate: onCreate,
    );
  }

  /*The function that creates the favorite words table*/
  onCreate(Database db, int version) async {
    // Execute a SQL command to create a new table in the database
    await db.execute(
      '''
      CREATE TABLE "$TABLE_NAME" (
	          Id INTEGER PRIMARY KEY,
	          Unit_Id	INTEGER NOT NULL,
            Book_Id	INTEGER NOT NULL,
            Word	TEXT NOT NULL UNIQUE,
            Definition	TEXT NOT NULL,
            Example	TEXT NOT NULL
            )
    ''',
    );
  }

  /*Add the word to favorite*/
  Future<void> addFavorite(FavoriteWordModel favorite) async {
    // Access the database instance asynchronously
    Database db = await database;

    // The favorite.toMap() method converts the FavoriteWordModel object into a Map
    await db.insert(
      TABLE_NAME, // The name of the table where the favorite word will be stored
      favorite.toMap(), // The data to be inserted, formatted as a Map
    );
  }

  /*Check if a specific word is in the favorite words table*/
  Future<bool> isFavorite(String id) async {
    // Ensure the database instance is correctly initialized
    Database db = await database;

    // Check if the database contains the record with the given id
    List<Map<String, dynamic>> favoriteMap = await db.query(
      TABLE_NAME, // Use the table name directly if it's a constant
      where:
          'Id = ?', // Ensure 'Id' matches the actual column name in the database
      whereArgs: [id], // Parameterized query to avoid SQL injection
    );

    // Return true if the list is not empty, meaning the record exists
    return favoriteMap.isNotEmpty;
  }

  Future<void> deleteFavorite(String id) async {
    //Obtain a reference to the database.
    Database db = await database;

    // Perform the deletion operation.
    await db.delete(
      TABLE_NAME,
      where: 'id = ?', // Replace 'id' with your actual column name.
      whereArgs: [id], // Provide the value to match in the where clause.
    );

    // await db.rawQuery('delete from $TABLE_NAME where Id like $id');
  }

  /*Get all items from favorite table*/
  Future<List<FavoriteWordModel>> getFavorites() async {
    // Access the database instance
    Database db = await database;

    // Execute a raw SQL query to select all entries from the favorites table
    List<Map<String, dynamic>> favoriteMap = await db.query(TABLE_NAME);

    /* Return a list of FavoriteWordModel instances generated from the query results */
    return List.generate(
      favoriteMap.length,
      (index) => FavoriteWordModel.fromMap(
        favoriteMap[index], // Convert each map entry to a FavoriteWordModel
      ),
    );
  }
}
