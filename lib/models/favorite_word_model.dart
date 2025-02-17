import '../models/word_model.dart';

class FavoriteWordModel extends WordModel {
  FavoriteWordModel({
    required super.id,
    required super.unitId,
    required super.bookId,
    required super.word,
    required super.definition,
    required super.example,
  });

  factory FavoriteWordModel.fromMap(Map<String, dynamic> map) {
    // Create a new FavoriteWordModel instance from a Map
    return FavoriteWordModel(
      id: map['id'], // Convert the Id from the map to a String
      unitId: map['unit_id'], // Convert Unit_Id to a String
      bookId: map['book_id'], // Convert Book_Id to a String
      word: map['word'].toString(), // Convert the Word to a String
      definition:
          map['definition'].toString(), // Convert the Definition to a String
      example: map['example'].toString(), // Convert the Example to a String
    );
  }
}
