class WordModel {
  final int id;
  final int unitId;
  final int bookId;
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
      'id': id, // Add the Id to the map
      'unit_id': unitId, // Add the Unit_Id to the map
      'book_id': bookId, // Add the Book_Id to the map
      'word': word, // Add the Word to the map
      'definition': definition, // Add the Definition to the map
      'example': example, // Add the Example to the map
    };
  }

  // Convert a Map into a WordModel
  factory WordModel.fromMap(Map<String, dynamic> map) {
    // Create a new WordModel instance from a Map
    return WordModel(
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
