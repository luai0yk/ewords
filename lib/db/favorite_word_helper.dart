import 'package:ewords/db/db_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../models/favorite_word_model.dart';

class FavoriteWordHelper extends DBHelper {
  static FavoriteWordHelper? _favoriteWordHelper;

  // Lazy singleton getter
  static FavoriteWordHelper get instance {
    _favoriteWordHelper ??= FavoriteWordHelper._intern();
    return _favoriteWordHelper!;
  }

  //Prevent the initialization of FavoriteWordHelper class
  FavoriteWordHelper._intern();

  /*Add the word to favorite*/
  Future<void> addFavorite(FavoriteWordModel favorite) async {
    // Access the database instance asynchronously
    Database? db = await database;

    // The favorite.toMap() method converts the FavoriteWordModel object into a Map
    await db!.insert(
      FAVORITE_WORDS_TABLE_NAME, // The name of the table where the favorite word will be stored
      favorite.toMap(), // The data to be inserted, formatted as a Map
    );
  }

  /*Check if a specific word is in the favorite words table*/
  Future<bool> isFavorite(int id) async {
    // Ensure the database instance is correctly initialized
    Database? db = await database;

    // Check if the database contains the record with the given id
    List<Map<String, dynamic>> favoriteMap = await db!.query(
      FAVORITE_WORDS_TABLE_NAME, // Use the table name directly if it's a constant
      where:
          'Id = ?', // Ensure 'Id' matches the actual column name in the database
      whereArgs: [id], // Parameterized query to avoid SQL injection
    );

    // Return true if the list is not empty, meaning the record exists
    return favoriteMap.isNotEmpty;
  }

  Future<void> deleteFavorite(int id) async {
    //Obtain a reference to the database.
    Database? db = await database;

    // Perform the deletion operation.
    await db!.delete(
      FAVORITE_WORDS_TABLE_NAME,
      where: 'id = ?', // Replace 'id' with your actual column name.
      whereArgs: [id], // Provide the value to match in the where clause.
    );

    // await db.rawQuery('delete from $TABLE_NAME where Id like $id');
  }

  /*Get all items from favorite table*/
  Future<List<FavoriteWordModel>> getFavorites() async {
    // Access the database instance
    Database? db = await database;

    // Execute a raw SQL query to select all entries from the favorites table
    List<Map<String, dynamic>> favoriteMap =
        await db!.query(FAVORITE_WORDS_TABLE_NAME);

    /* Return a list of FavoriteWordModel instances generated from the query results */
    return List.generate(
      favoriteMap.length,
      (index) => FavoriteWordModel.fromMap(
        favoriteMap[index], // Convert each map entry to a FavoriteWordModel
      ),
    );
  }
}
