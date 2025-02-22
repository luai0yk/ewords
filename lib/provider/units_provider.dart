import 'package:ewords/db/unit_helper.dart';
import 'package:ewords/models/unit_model.dart';
import 'package:flutter/cupertino.dart';

class UnitsProvider extends ChangeNotifier {
  List<UnitModel>? units;

  Future<void> fetchUnits() async {
    units = await UnitHelper.instance.getUnits();
    notifyListeners(); // Notify listeners to update the UI
  }
}
