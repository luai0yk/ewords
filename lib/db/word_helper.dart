import 'package:ewords/db/db_helper.dart';

import '../models/word_model.dart';

class WordHelper extends DBHelper {
  static WordHelper? _wordsHelper;

  // Lazy singleton getter
  static WordHelper get instance {
    _wordsHelper ??= WordHelper._intern();
    return _wordsHelper!;
  }

  //To prevent the instantiation of the WordsHelper class
  WordHelper._intern();

  Future<List<WordModel>> getWords({int unitId = -1, int bookId = -1}) async {
    /*Initializing database variable with the db function defined above*/
    var db = await database;
    /*A map to holds retrieved data from the database (words.db)*/
    List<Map<String, dynamic>> wordMap = [];

    /*If parameters are not passed the function will retrieve all data*/
    if (unitId == -1) {
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
