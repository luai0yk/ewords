class WordModel {
  final String id;
  final String unitId;
  final String bookId;
  final String word;
  final String definition;
  final String example;

  WordModel({
    required this.id,
    required this.unitId,
    required this.bookId,
    required this.word,
    required this.definition,
    required this.example,
  });

  // Convert a WordModel into a Map
  Map<String, dynamic> toMap() {
    // Convert the current instance of WordModel to a Map
    return {
      'Id': id, // Add the Id to the map
      'Unit_Id': unitId, // Add the Unit_Id to the map
      'Book_Id': bookId, // Add the Book_Id to the map
      'Word': word, // Add the Word to the map
      'Definition': definition, // Add the Definition to the map
      'Example': example, // Add the Example to the map
    };
  }

  // Convert a Map into a WordModel
  factory WordModel.fromMap(Map<String, dynamic> map) {
    // Create a new WordModel instance from a Map
    return WordModel(
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
