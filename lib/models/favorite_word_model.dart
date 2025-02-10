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
      id: map['Id'].toString(), // Convert the Id from the map to a String
      unitId: map['Unit_Id'].toString(), // Convert Unit_Id to a String
      bookId: map['Book_Id'].toString(), // Convert Book_Id to a String
      word: map['Word'].toString(), // Convert the Word to a String
      definition:
          map['Definition'].toString(), // Convert the Definition to a String
      example: map['Example'].toString(), // Convert the Example to a String
    );
  }
}
