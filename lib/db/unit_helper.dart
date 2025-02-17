import 'package:ewords/db/db_helper.dart';
import 'package:ewords/db/words_helper.dart';
import 'package:ewords/models/unit_model.dart';
import 'package:ewords/models/word_model.dart';
import 'package:sqflite/sqflite.dart';

class UnitHelper extends DBHelper {
  static UnitHelper? _passageHelper;

  // Lazy singleton getter
  static UnitHelper get instance {
    _passageHelper ??= UnitHelper._intern();
    return _passageHelper!;
  }

  //To prevent the initialization of the UnitHelper class
  UnitHelper._intern();

  Future<List<UnitModel>> getUnits() async {
    Database? db = await database;
    List<Map<String, dynamic>> map = await db!.query(PASSAGES_TABLE_NAME);

    List<UnitModel> units = [];
    for (var item in map) {
      List<WordModel> wordsList = await WordsHelper.instance.getWords(
        bookId: item['book_id'],
        unitId: item['unit_id'],
      );
      units.add(UnitModel(
        bookId: item['book_id'],
        unitId: item['unit_id'],
        passage: item['passage'],
        words: wordsList,
      ));
    }

    return units;
  }
}
