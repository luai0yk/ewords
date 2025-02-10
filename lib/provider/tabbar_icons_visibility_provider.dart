import 'package:flutter/cupertino.dart';

class TabBarIconsVisibilityProvider extends ChangeNotifier {
  int tabNumber = 0;

  showHideTabBarIcons(int tabNumber) {
    this.tabNumber = tabNumber;
    notifyListeners();
  }
}
