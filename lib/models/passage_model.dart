class PassageModel {
  String id, unitId, bookId, passageTitle, passage;

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
    String title = map['Reading'].split('\n').first;

    /*Split the passage field by its line into a list using split('\n') function*/
    List<String> lines = map['Reading'].split('\n');

    /*Skip or delete the first line which holds the passage title
    * then convert the list into one String value again using join('') function*/
    String reading = lines.skip(1).join('\n');

    // Create a new PassageModel instance from a Map
    return PassageModel(
      id: map['Id'].toString(),
      unitId: map['Unit_Id'].toString(),
      bookId: map['Book_Id'].toString(),
      passageTitle: title,
      passage: reading,
    );
  }
}
