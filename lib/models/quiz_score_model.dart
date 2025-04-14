class QuizScoreModel {
  int? nextUnitId;
  int id, unitId, bookId, correctAnswers;
  String? takenAt = '', updatedAt = '';

  QuizScoreModel({
    required this.unitId,
    required this.bookId,
    required this.correctAnswers,
    required this.id,
    this.takenAt,
    this.updatedAt,
    this.nextUnitId,
  });

  // Calculate wrong answers
  int get wrongAnswers => 20 - correctAnswers;

  // Calculate total score as a percentage
  double get totalScore => (correctAnswers / 20) * 100;

  // Convert a map to QuizScoreModel
  factory QuizScoreModel.fromMap(Map<String, dynamic> map) {
    return QuizScoreModel(
      id: map['id'],
      unitId: map['unit_id'],
      bookId: map['book_id'],
      correctAnswers: map['correct_answers'],
      takenAt: map['taken_at'],
      updatedAt: map['updated_at'],
    );
  }

  // Convert QuizScoreModel to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'unit_id': unitId,
      'book_id': bookId,
      'correct_answers': correctAnswers,
    };
  }
}
