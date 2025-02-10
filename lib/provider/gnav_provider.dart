import 'package:flutter/cupertino.dart';

class GNavProvider extends ChangeNotifier {
  int _selectedTab = 0;

  int get selectedTab => _selectedTab;

  void updateSelectedTab(int selectedTab) {
    _selectedTab = selectedTab;
    notifyListeners();
  }
}
