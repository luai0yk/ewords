import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../args/passage_args.dart';
import '../db/db_helper.dart';
import '../models/word_model.dart';

class QuizProvider extends ChangeNotifier {
  QuizProvider();

  double _progress = 0.0;
  final int duration = 20;
  int _questionNumber = 0;
  Timer? _timer;
  List<WordModel> _listWords = [];
  List<String> _answerChoices = [];
  String _correctAnswer = "";
  String _selectedAnswer = "";
  bool _isAnswered = false;
  bool _isPaused = false;
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
  bool get isPaused => _isPaused;
  int get correctCount => _correctCount;
  int get wrongCount => _wrongCount;

  void loadWords(PassageArgs passageArgs) async {
    List<WordModel> words = await DBHelper().getWords(
      bookId: passageArgs.bookId,
      unitId: passageArgs.unitId,
    );

    if (words.isNotEmpty) {
      _listWords = words;
      _questionNumber = 0;
      _wrongCount = 0;
      _correctCount = 0;
      _updateChoices();
      notifyListeners();
    }
  }

  void _startProgress() {
    _timer?.cancel();
    _progress = 0.0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_progress < 1.0 && !_isPaused) {
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
    _isPaused = false;
    _startProgress();
    notifyListeners();
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
    _isPaused = !_isPaused;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
