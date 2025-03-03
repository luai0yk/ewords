import 'dart:async';
import 'dart:math';

import 'package:ewords/db/quiz_score_helper.dart';
import 'package:ewords/models/unit_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quiz_score_model.dart';
import '../models/word_model.dart';

class QuizProvider extends ChangeNotifier {
  QuizProvider();

  double _progress = 0.0;
  final int duration = 30;
  int _questionNumber = 0;
  Timer? _timer;
  List<WordModel> _listWords = [];
  List<String> _answerChoices = [];
  String _correctAnswer = "";
  String _selectedAnswer = "";
  bool _isAnswered = false;
  bool isPaused = false;
  int _correctCount = 0;
  int _wrongCount = 0;
  final Random _random = Random();
  ValueNotifier<bool> isQuizCompleted = ValueNotifier<bool>(false);

  double get progress => _progress;
  int get questionNumber => _questionNumber;
  List<WordModel> get listWords => _listWords;
  List<String> get answerChoices => _answerChoices;
  String get correctAnswer => _correctAnswer;
  String get selectedAnswer => _selectedAnswer;
  bool get isAnswered => _isAnswered;
  int get correctCount => _correctCount;
  int get wrongCount => _wrongCount;

  set setProgress(double val) => _progress = val;

  void setSelectedAnswer(String val) {
    _selectedAnswer = val;
    notifyListeners();
  }

  void loadWords(UnitModel unit) async {
    // List<WordModel> words = await WordHelper.instance.getWords(
    //   bookId: passageArgs.bookId!,
    //   unitId: passageArgs.unitId!,
    // );

    if (unit.words.isNotEmpty) {
      _listWords = unit.words;
      _questionNumber = 0;
      _wrongCount = 0;
      _correctCount = 0;
      _updateChoices();
      //notifyListeners();
    }
  }

  void _startProgress() {
    _timer?.cancel();
    _progress = 0.0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_progress < 1.0 && !isPaused) {
        _progress += 1 / duration;
        notifyListeners();
      } else if (_progress >= 1.0) {
        _timer?.cancel();
        if (!_isAnswered) {
          _wrongCount++;
        }
        _moveToNextQuestion();
        notifyListeners();
      }
    });
  }

  void _updateChoices() {
    if (_listWords.isEmpty || _questionNumber >= _listWords.length) return;

    WordModel currentWord = _listWords[_questionNumber];
    _correctAnswer = currentWord.word;

    Set<String> incorrectAnswers = {};
    while (incorrectAnswers.length < 3) {
      String randomWord = _listWords[_random.nextInt(_listWords.length)].word;
      if (randomWord != _correctAnswer) {
        incorrectAnswers.add(randomWord);
      }
    }

    _answerChoices = [_correctAnswer, ...incorrectAnswers];
    _answerChoices.shuffle(_random);

    _selectedAnswer = "";
    _isAnswered = false;
    isPaused = false;
    _startProgress();
    //notifyListeners();
  }

  void checkAnswer(String selectedAnswer) {
    if (_isAnswered) return;

    bool isCorrect = selectedAnswer == _correctAnswer;

    _selectedAnswer = selectedAnswer;
    _isAnswered = true;
    if (isCorrect) {
      _correctCount++;
    } else {
      _wrongCount++;
    }
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 400), () {
      _moveToNextQuestion();
    });
  }

  void _moveToNextQuestion() {
    if (_questionNumber < _listWords.length - 1) {
      _questionNumber++;
      _updateChoices();
    } else {
      isQuizCompleted.value = true;
      _timer!.cancel();
    }
    notifyListeners();
  }

  String sanitizeDefinition(String definition, String correctAnswer) {
    return definition.replaceAll(
        RegExp('\\b$correctAnswer\\b', caseSensitive: false), '_____');
  }

  void togglePauseResume() {
    isPaused = !isPaused;
    notifyListeners();
  }

  Future<void> insertOrUpdateQuizScore({required QuizScoreModel score}) async {
    await QuizScoreHelper.instance.insertOrUpdateQuizScore(
      QuizScoreModel(
        id: score.id,
        unitId: score.unitId,
        bookId: score.bookId,
        correctAnswers: score.correctAnswers,
      ),
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (score.totalScore >= 50) {
      prefs.setInt('current_active_unit', (score.id + 1));
    }

    if (score.totalScore >= 90) {
      prefs.setInt('diamond', (prefs.getInt('diamond') ?? 5 + 5));
    } else if (score.totalScore >= 75) {
      prefs.setInt('diamond', (prefs.getInt('diamond') ?? 5 + 3));
    } else if (score.totalScore >= 50) {
      prefs.setInt('diamond', (prefs.getInt('diamond') ?? 5 + 2));
    }

    checkPassedUnits(
      id: score.id,
      bookId: score.bookId,
      unitId: score.unitId,
    );
  }

  // A set to hold the IDs of passed units
  final Set<int> _passedUnitIds = <int>{};

  Future<void> checkPassedUnits(
      {required int id, required int bookId, required int unitId}) async {
    bool isPassed = await QuizScoreHelper.instance.isPassed(
      bookId: bookId,
      unitId: unitId,
    );

    if (isPassed) {
      _passedUnitIds.add(id);
      _passedUnitIds.add(id + 1);
    } else {
      _passedUnitIds.remove(id);
    }

    notifyListeners();
  }

  // Check if a unit ID is in the passed units
  bool isPassed(int id) => _passedUnitIds.contains(id);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
