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

  Future<int> updateQuizScore(QuizScoreModel quizScoreModel) async {
    Database? db = await database;
    return await db!.update(
      'quiz_scores',
      quizScoreModel.toMap(),
      where: 'id = ?',
      whereArgs: [quizScoreModel.id],
    );
  }
}
