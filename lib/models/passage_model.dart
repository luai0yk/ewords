class PassageModel {
  int id, unitId, bookId;
  
  String passageTitle, passage;

  PassageModel({
    required this.id,
    required this.unitId,
    required this.bookId,
    required this.passageTitle,
    required this.passage,
  });

  factory PassageModel.fromMap(Map<String, dynamic> map) {
    /*Split the passage field by its lines into a list then get
    * the first item of it which holds the passage title*/
    String title = map['passage'].split('\n').first;

    /*Split the passage field by its line into a list using split('\n') function*/
    List<String> lines = map['passage'].split('\n');

    /*Skip or delete the first line which holds the passage title
    * then convert the list into one String value again using join('') function*/
    String reading = lines.skip(1).join('\n');

    // Create a new PassageModel instance from a Map
    return PassageModel(
      id: map['id'],
      unitId: map['unit_id'],
      bookId: map['book_id'],
      passageTitle: title,
      passage: reading,
    );
  }
}
