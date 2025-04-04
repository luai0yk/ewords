import 'dart:async';
import 'dart:math';

import 'package:ewords/db/quiz_score_helper.dart';
import 'package:ewords/models/unit_model.dart';
import 'package:ewords/provider/diamonds_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quiz_score_model.dart';
import '../models/word_model.dart';

class QuizProvider extends ChangeNotifier {
  double _progress = 0.0;
  double _savedProgress = 0.0; // Added to store progress when paused
  int _currentActiveUnit = 0;
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
  bool _isCovered = true;
  bool _isQuizStarted = false;
  UnitModel? unit;
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
  bool get isCovered => _isCovered;
  bool get isQuizStarted => _isQuizStarted;

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentActiveUnit = prefs.getInt('current_active_unit') ?? 1;
  }

  set setProgress(double val) => _progress = val;

  cover(state, {pause = false}) {
    _isCovered = state;
    if (state == true) {
      if (pause) {
        isPaused = true;
      }
      if (_timer != null) {
        _savedProgress = _progress; // Save current progress when pausing
        _timer!.cancel();
      }
    } else {
      isPaused = false;
      if (_questionNumber < _listWords.length && _isQuizStarted) {
        _startProgress(continueFromCurrentProgress: true);
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setSelectedAnswer(String val) {
    _selectedAnswer = val;
    notifyListeners();
  }

  void resetQuiz() {
    _listWords = [];
    _questionNumber = 0;
    _wrongCount = 0;
    _correctCount = 0;
    _isQuizStarted = false;
    _isAnswered = false;
    _selectedAnswer = "";
    _correctAnswer = "";
    _answerChoices = [];
    _progress = 0.0;
    _savedProgress = 0.0; // Reset saved progress
    _timer?.cancel();
    isPaused = false;
    _isCovered = true;
    isQuizCompleted.value = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void loadWords(UnitModel unit) async {
    // Reset the quiz state first
    resetQuiz();

    // Set the new unit and load its words
    this.unit = unit;

    if (unit.words.isNotEmpty) {
      _listWords = unit.words;
      _questionNumber = 0;
      _wrongCount = 0;
      _correctCount = 0;
      _isQuizStarted = true;
      _updateChoices();
    }
  }

  void _startProgress({bool continueFromCurrentProgress = false}) {
    _timer?.cancel();
    if (!continueFromCurrentProgress) {
      _progress = 0.0;
      _savedProgress = 0.0;
    } else {
      _progress = _savedProgress; // Restore saved progress when resuming
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_progress < 1.0 && !isPaused) {
        _progress += 1 / duration;
        notifyListeners();
      } else if (_progress >= 1.0) {
        _timer?.cancel();
        if (!_isAnswered) {
          _wrongCount++;
        }
        _moveToNextQuestion(unit);
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
    _startProgress(continueFromCurrentProgress: false);
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
      _moveToNextQuestion(unit);
    });
  }

  void _moveToNextQuestion(unit) {
    if (_questionNumber < _listWords.length - 1) {
      _questionNumber++;
      _updateChoices();
    } else {
      isQuizCompleted.value = true;
      _isCovered = true;
      insertOrUpdateQuizScore(
        score: QuizScoreModel(
          id: unit.id,
          unitId: unit.unitId,
          bookId: unit.bookId,
          correctAnswers: correctCount,
        ),
      );
      _timer?.cancel();
    }
    notifyListeners();
  }

  String sanitizeDefinition(String definition, String correctAnswer) {
    return definition.replaceAll(
        RegExp('\\b$correctAnswer\\b', caseSensitive: false), '_____');
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
      await prefs.setInt(
        'current_active_unit',
        (score.id + 1),
      );
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
      _passedUnitIds.add(id <= 179 ? (id + 1) : 0);
    } else {
      _passedUnitIds.remove(id);
    }

    notifyListeners();
  }

  Map<String, dynamic> getUnitStatus(int id) {
    return <String, dynamic>{
      'is_passed': _passedUnitIds.contains(id),
      'current_active_unit': _currentActiveUnit,
    };
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Function to help the user choose the right answers but minus 3 diamonds
  Future<void> useHelp(
      {required DiamondsProvider diamondProvider,
      required Function() onError}) async {
    if (diamondProvider.diamonds >= 3) {
      _selectedAnswer = _correctAnswer;

      diamondProvider.minusDiamonds(diamonds: 3);

      notifyListeners();
    } else {
      onError();
    }
  }
}
