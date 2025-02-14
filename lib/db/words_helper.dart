import 'package:ewords/db/db_helper.dart';

import '../models/word_model.dart';

class WordsHelper extends DBHelper {
  static WordsHelper? _wordsHelper;

  // Lazy singleton getter
  static WordsHelper get instance {
    _wordsHelper ??= WordsHelper._intern();
    return _wordsHelper!;
  }

  //To prevent the instantiation of the WordsHelper class
  WordsHelper._intern();

  /*Getting words from database (words.db) depending the query*/
  Future<List<WordModel>> getWords(
      {String unitId = '', String bookId = ''}) async {
    /*Initializing database variable with the db function defined above*/
    var db = await database;
    /*A map to holds retrieved data from the database (words.db)*/
    List<Map<String, dynamic>> wordMap = [];

    /*If parameters are not passed the function will retrieve all data*/
    if (unitId.isEmpty) {
      wordMap = await db!.query(WORDS_TABLE_NAME);
    }
    /*If parameters are passed the function will retrieve data based on Book_Id and Unit_Id  */
    else {
      wordMap = await db!.query(WORDS_TABLE_NAME,
          where: 'Book_Id = ? and Unit_Id = ?', whereArgs: [bookId, unitId]);
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
}
