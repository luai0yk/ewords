import 'package:ewords/db/quiz_score_helper.dart';
import 'package:ewords/db/unit_helper.dart';
import 'package:ewords/models/quiz_score_model.dart';
import 'package:ewords/models/unit_model.dart';
import 'package:flutter/cupertino.dart';

class UnitsProvider extends ChangeNotifier {
  List<UnitModel>? units;
  List<QuizScoreModel>? scores;

  Future<void> fetchUnits() async {
    units = await UnitHelper.instance.getUnits();
    notifyListeners();
  }

  Future<void> fetchScores() async {
    scores = await QuizScoreHelper.instance.getQuizScores();
    notifyListeners();
  }
}
