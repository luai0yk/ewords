import 'package:ewords/db/db_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../models/quiz_score_model.dart';

class QuizScoreHelper extends DBHelper {
  static QuizScoreHelper? _quizScoreHelper;

  // Lazy singleton getter
  static QuizScoreHelper get instance {
    _quizScoreHelper ??= QuizScoreHelper._intern();
    return _quizScoreHelper!;
  }

  //Prevent the initialization of QuizScoreHelper class
  QuizScoreHelper._intern();

  Future<int> insertQuizScore(QuizScoreModel quizScoreModel) async {
    Database? db = await database;
    return await db!.insert(QUIZ_TABLE_NAME, quizScoreModel.toMap());
  }

  Future<int> updateQuizScore(int id, int correctAnswers) async {
    Database? db = await database;
    return await db!.update(
      QUIZ_TABLE_NAME,
      {'correct_answers': correctAnswers},
      where: 'id = ? AND correct_answers < ?',
      whereArgs: [id, correctAnswers],
    );
  }

  // New method to insert or update quiz score
  Future<void> insertOrUpdateQuizScore(QuizScoreModel quizScoreModel) async {
    Database? db = await database;
    final List<Map<String, dynamic>> response = await db!.query(
      QUIZ_TABLE_NAME,
      where: 'unit_id = ? AND book_id = ?',
      whereArgs: [quizScoreModel.unitId, quizScoreModel.bookId],
    );

    if (response.isEmpty) {
      await insertQuizScore(quizScoreModel);
    } else {
      await updateQuizScore(
          response.first['id'], quizScoreModel.correctAnswers);
    }
  }

  Future<List<QuizScoreModel>> getQuizScores() async {
    Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(QUIZ_TABLE_NAME);

    return List.generate(
      maps.length,
      (index) {
        return QuizScoreModel.fromMap(maps[index]);
      },
    );
  }
  //
  // Future<int> getCorrectAnswersById({required int id}) async {
  //   Database? db = await database;
  //   List<Map<String, dynamic>> map = await db!.query(
  //     QUIZ_TABLE_NAME,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  //
  //   return map.first['correct_answers'];
  // }

  Future<bool> isPassed({required int bookId, required int unitId}) async {
    Database? db = await database;
    final List<Map<String, dynamic>> response = await db!.query(
      QUIZ_TABLE_NAME,
      columns: ['correct_answers'],
      where: 'book_id = ? and unit_id = ?',
      whereArgs: [bookId, unitId],
    );

    bool isPassed = false;
    int correctAnswers = 0;

    if (response.isEmpty) {
      isPassed = false;
    } else {
      correctAnswers = response.first['correct_answers'];
      double score = (correctAnswers / 20) * 100;
      if (score >= 50) {
        isPassed = true;
      } else {
        isPassed = false;
      }
    }

    return isPassed;
  }
}
