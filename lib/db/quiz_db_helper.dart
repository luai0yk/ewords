// import 'package:eword/Database/db_helper.dart';
// import 'package:eword/Models/word_model.dart';
// import 'package:eword/Models/word_quiz_model.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// class QuizDBHelper {
//   final String DB_NAME = 'quiz.db';
//   final String TABLE_NAME = 'quiz';
//   final int DB_VERSION = 1;
//
//   // Singleton pattern to ensure only one instance of QuizDBHelper
//   static final QuizDBHelper _instance = QuizDBHelper._intern();
//   factory QuizDBHelper() => _instance;
//   QuizDBHelper._intern();
//
//   // Singleton pattern to manage the Database instance
//   Database? _database;
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB();
//     return _database!;
//   }
//
//   // Initialize the database
//   _initDB() async {
//     String path = join(await getDatabasesPath(), DB_NAME);
//     return openDatabase(
//       path,
//       version: DB_VERSION,
//       onCreate: onCreate,
//     );
//   }
//
//   // Create the table structure in the database
//   onCreate(Database db, int version) async {
//     await db.execute(
//       '''
//       CREATE TABLE $TABLE_NAME (
//         Id INTEGER PRIMARY KEY,
//         Unit_Id INTEGER NOT NULL,
//         Book_Id INTEGER NOT NULL,
//         Word TEXT NOT NULL UNIQUE,
//         Definition TEXT NOT NULL,
//         Example TEXT NOT NULL,
//         Is_Answered INTEGER NOT NULL
//       )
//       ''',
//     );
//   }
//
//   Future<void> wordQuizInit() async {
//     Database db = await database;
//
//     List<WordModel> wordList = await DBHelper().getWords();
//     for (var word in wordList) {
//       WordQuizModel quiz = WordQuizModel(
//         id: word.id,
//         unitId: word.unitId,
//         bookId: word.bookId,
//         word: word.word,
//         definition: word.definition,
//         example: word.example,
//         isAnswered: 0,
//       );
//
//       await db.insert(
//         TABLE_NAME,
//         quiz.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     }
//   }
//
//   Future<List<WordQuizModel>> query() async {
//     Database db = await database;
//     List<Map<String, dynamic>> data = await db.query(TABLE_NAME);
//     return List.generate(
//       data.length,
//       (index) => WordQuizModel.fromMap(data[index]),
//     );
//   }
// }
