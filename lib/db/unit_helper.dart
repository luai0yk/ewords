import 'package:ewords/db/db_helper.dart';
import 'package:ewords/db/word_helper.dart';
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

    for (var entry in map) {
      List<WordModel> wordsList = await WordHelper.instance.getWords(
        bookId: entry['book_id'],
        unitId: entry['unit_id'],
      );
      units.add(UnitModel.fromMap(entry, words: wordsList));
    }

    return units;
  }

  Future<List<UnitModel>> getUnit({int bookId = -1, int unitId = -1}) async {
    Database? db = await database;
    List<Map<String, dynamic>> map = await db!.query(
      PASSAGES_TABLE_NAME,
      where: 'book_id = ? AND unit_id = ?',
      whereArgs: [bookId, unitId],
    );

    List<UnitModel> units = [];

    for (var entry in map) {
      List<WordModel> wordsList = await WordHelper.instance.getWords(
        bookId: entry['book_id'],
        unitId: entry['unit_id'],
      );
      units.add(UnitModel.fromMap(entry, words: wordsList));
    }

    return units;
  }
}
