import 'package:ewords/models/word_model.dart';

class UnitModel {
  int unitId, bookId;
  String passage;
  List<WordModel> words;

  UnitModel({
    required this.bookId,
    required this.unitId,
    required this.passage,
    required this.words
  });

  
}
