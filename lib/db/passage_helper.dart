import 'package:ewords/db/db_helper.dart';

import '../models/passage_model.dart';

class PassageHelper extends DBHelper {
  static PassageHelper? _passageHelper;

  // Lazy singleton getter
  static PassageHelper get instance {
    _passageHelper ??= PassageHelper._intern();
    return _passageHelper!;
  }

  //To prevent the initialization of the PassageHelper class
  PassageHelper._intern();

  /*Getting the Passages data depending on Book_Id that is passed to the function*/
  Future<List<PassageModel>> getPassages({required int bookId}) async {
    /*Initializing database variable with the db function defined above*/
    var db = await database;
    /*A map to holds retrieved data from the database (words.db)*/
    List<Map<String, dynamic>> passageMap = await db!
        .rawQuery('SELECT * FROM $PASSAGES_TABLE_NAME WHERE Book_Id = $bookId');

    /*Converting the retrieved map data into a List<PassageModel>
    * by using List.generate loop then returning the converted data to the function*/
    return List.generate(
      passageMap.length,
      (index) => PassageModel.fromMap(
        passageMap[index],
      ),
    );
  }
}
