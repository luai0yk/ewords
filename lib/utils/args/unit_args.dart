import 'package:ewords/models/word_model.dart';

class UnitArgs {
  int? unitId, bookId;
  String? passage;
  List<WordModel>? words;

  UnitArgs({
    this.unitId,
    this.bookId,
    this.passage,
    this.words,
  });
}
