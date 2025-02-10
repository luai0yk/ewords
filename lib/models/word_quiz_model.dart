// import 'package:eword/Models/word_model.dart';
//
// class WordQuizModel extends WordModel {
//   int isAnswered;
//
//   WordQuizModel({
//     required super.id,
//     required super.unitId,
//     required super.bookId,
//     required super.word,
//     required super.definition,
//     required super.example,
//     required this.isAnswered,
//   });
//
//   // Convert a WordModel into a Map
//   @override
//   Map<String, dynamic> toMap() {
//     return {
//       'Id': id,
//       'Unit_Id': unitId,
//       'Book_Id': bookId,
//       'Word': word,
//       'Definition': definition,
//       'Example': example,
//       'Is_Answered': isAnswered,
//     };
//   }
//
//   // Convert a Map into a WordModel
//   factory WordQuizModel.fromMap(Map<String, dynamic> map) {
//     // Create a new WordQuizModel instance from a Map
//     return WordQuizModel(
//       id: map['Id'].toString(), // Convert the Id from the map to a String
//       unitId: map['Unit_Id'].toString(), // Convert Unit_Id to a String
//       bookId: map['Book_Id'].toString(), // Convert Book_Id to a String
//       word: map['Word'].toString(), // Convert the Word to a String
//       definition:
//           map['Definition'].toString(), // Convert the Definition to a String
//       example: map['Example'].toString(), // Convert the Example to a String
//       isAnswered: map[
//           'Is_Answered'], // Directly assign Is_Answered (assumed to be a boolean or appropriate type)
//     );
//   }
// }
