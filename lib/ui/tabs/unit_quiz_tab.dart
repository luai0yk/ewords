import 'dart:async';
import 'dart:math';

import 'package:ewords/args/passage_args.dart';
import 'package:ewords/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../db/db_helper.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../my_widgets/my_card.dart';

class UnitQuizTab extends StatefulWidget {
  final PassageArgs passageArgs;

  const UnitQuizTab({super.key, required this.passageArgs});

  @override
  State<UnitQuizTab> createState() => _UnitQuizTabState();
}

class _UnitQuizTabState extends State<UnitQuizTab> {
  double _progress = 0.0;
  final int _duration = 20;
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

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    List<WordModel> words = await DBHelper().getWords(
      bookId: widget.passageArgs.bookId,
      unitId: widget.passageArgs.unitId,
    );

    if (mounted && words.isNotEmpty) {
      setState(() {
        _listWords = words;
        _questionNumber = 0; // Start from the first question
        _updateChoices(); // Now safe to call
      });
    }
  }

  /// Start or reset timer
  void _startProgress() {
    _timer?.cancel();
    _progress = 0.0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_progress < 1.0 && !_isPaused) {
        setState(() => _progress += 1 / _duration);
      } else if (_progress >= 1.0) {
        _timer?.cancel();
        if (!_isAnswered) {
          setState(() {
            _wrongCount++;
          });
        }
        _moveToNextQuestion();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Updates answer choices for the current question
  void _updateChoices() {
    if (_listWords.isEmpty || _questionNumber >= _listWords.length) return;

    WordModel currentWord = _listWords[_questionNumber];
    _correctAnswer = currentWord.word;

    // Get three incorrect choices
    Set<String> incorrectAnswers = {};
    while (incorrectAnswers.length < 3) {
      String randomWord = _listWords[_random.nextInt(_listWords.length)].word;
      if (randomWord != _correctAnswer) {
        incorrectAnswers.add(randomWord);
      }
    }

    // Combine correct and incorrect answers and shuffle them
    _answerChoices = [_correctAnswer, ...incorrectAnswers];
    _answerChoices.shuffle(_random);

    setState(() {
      _selectedAnswer = "";
      _isAnswered = false;
      _isPaused = false;
      _startProgress();
    });
  }

  /// Handles answer selection
  void _checkAnswer(String selectedAnswer) {
    if (_isAnswered) return; // Prevent multiple taps

    bool isCorrect = selectedAnswer == _correctAnswer;

    setState(() {
      _selectedAnswer = selectedAnswer;
      _isAnswered = true;
      if (isCorrect) {
        _correctCount++;
      } else {
        _wrongCount++;
      }
    });

    // Delay before moving to the next question
    Future.delayed(const Duration(milliseconds: 400), () {
      _moveToNextQuestion();
    });
  }

  /// Move to the next question or show completion dialog if it was the last question
  void _moveToNextQuestion() {
    if (_questionNumber < _listWords.length - 1) {
      setState(() {
        _questionNumber++;
        _updateChoices();
      });
    } else {
      _showCompletionDialog();
    }
  }

  /// Show completion dialog
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Quiz Completed"),
          content: const Text("You have answered all the questions."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _questionNumber = 0;
                  _correctCount = 0;
                  _wrongCount = 0;
                  _updateChoices();
                });
              },
              child: const Text("Restart"),
            ),
          ],
        );
      },
    );
  }

  /// Remove related word from the definition
  String _sanitizeDefinition(String definition, String correctAnswer) {
    return definition.replaceAll(
        RegExp('\\b$correctAnswer\\b', caseSensitive: false), '_____');
  }

  /// Toggle pause and resume
  void _togglePauseResume() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            MyCard(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    _listWords.isNotEmpty
                        ? _sanitizeDefinition(
                            _listWords[_questionNumber].definition,
                            _correctAnswer)
                        : "Loading...",
                    style: MyTheme().mainTextStyle,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          color: MyColors.themeColors[300],
                          backgroundColor: MyColors.themeColors[100],
                          value: _progress,
                          minHeight: 20,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: MyTheme().mainTextStyle,
                          children: [
                            TextSpan(
                                text:
                                    "  ${(20 - (_progress * 20)).toInt()} / "),
                            TextSpan(
                              text: "$_duration",
                              style:
                                  TextStyle(color: MyColors.themeColors[300]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Q: ${_questionNumber + 1} / ${_listWords.length}",
                  style: MyTheme().mainTextStyle.copyWith(
                        color: MyColors.themeColors[300],
                      ),
                ),
                Text(
                  "C: $_correctCount",
                  style: MyTheme().mainTextStyle.copyWith(
                        color: Colors.green,
                      ),
                ),
                Text(
                  "W: $_wrongCount",
                  style: MyTheme().mainTextStyle.copyWith(
                        color: Colors.red,
                      ),
                ),
                IconButton(
                  onPressed: _togglePauseResume,
                  icon: Icon(
                    _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(_answerChoices.length, (index) {
                String choice = _answerChoices[index];
                Color? buttonColor = MyColors.themeColors[300];

                if (_isAnswered) {
                  if (choice == _correctAnswer) {
                    buttonColor = Colors.green;
                  } else if (choice == _selectedAnswer) {
                    buttonColor = Colors.red;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => _checkAnswer(choice),
                    child: Text(
                      choice,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
