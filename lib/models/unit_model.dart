import 'package:ewords/models/word_model.dart';

class UnitModel {
  int id, unitId, bookId;
  String passage, passageTitle;
  List<WordModel> words;

  UnitModel({
    required this.id,
    required this.bookId,
    required this.unitId,
    required this.passageTitle,
    required this.passage,
    required this.words,
  });

  factory UnitModel.fromMap(Map<String, dynamic> map,
      {List<WordModel>? words}) {
    /*Split the passage field by its lines into a list then get
    * the first item of it which holds the passage title*/
    String title = map['passage'].split('\n').first;

    /*Split the passage field by its line into a list using split('\n') function*/
    List<String> lines = map['passage'].split('\n');

    /*Skip or delete the first line which holds the passage title
    * then convert the list into one String value again using join('') function*/
    String passage = lines.skip(1).join('\n');

    // Create a new PassageModel instance from a Map
    return UnitModel(
      id: map['id'],
      unitId: map['unit_id'],
      bookId: map['book_id'],
      passageTitle: title,
      passage: passage,
      words: words!,
    );
  }
}
