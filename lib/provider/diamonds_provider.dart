import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiamondsProvider with ChangeNotifier {
  int _diamonds = 5;

  int get diamonds => _diamonds;

  Future<void> loadDiamonds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _diamonds = prefs.getInt('diamond') ?? 5;
    notifyListeners();
  }

  Future<void> updateDiamonds({required correctAnswers}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double score = (correctAnswers / 20) * 100;

    if (score >= 90) {
      _diamonds = (prefs.getInt('diamond') ?? 5) + 5;
    } else if (score >= 75) {
      _diamonds = (prefs.getInt('diamond') ?? 5) + 3;
    } else if (score >= 50) {
      _diamonds = (prefs.getInt('diamond') ?? 5) + 2;
    }

    await prefs.setInt('diamond', _diamonds);
    notifyListeners();
  }

  Future<void> adRewardDiamonds({required int diamonds}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _diamonds = (_diamonds + diamonds);

    await prefs.setInt('diamond', _diamonds);
    notifyListeners();
  }
}
