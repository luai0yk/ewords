import 'package:ewords/db/quiz_score_helper.dart';
import 'package:ewords/models/quiz_score_model.dart';
import 'package:ewords/models/unit_model.dart';
import 'package:ewords/models/word_model.dart';
import 'package:flutter/cupertino.dart';

import '../db/unit_helper.dart';

class UnitsProvider extends ChangeNotifier {
  List<UnitModel>? units;
  List<QuizScoreModel>? scores;
  List<WordModel>? words;

  Future<void> fetchUnits() async {
    units = await UnitHelper.instance.getUnits();
    notifyListeners();
  }

  Future<void> fetchScores() async {
    scores = await QuizScoreHelper.instance.getQuizScores();
    notifyListeners();
  }
}
