import 'package:ewords/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';

class RecentUnit {
  // Method called when the recent button is tapped
  static void loadRecentTap(
      {required BuildContext context,
      required Function(String msg) onError,
      required Function(int index) onSuccess}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Read the last unit opened from SharedPreferences
    final int lastUnitIndex = prefs.getInt(MyConstants.LAST_UNIT_INDEX) ?? -1;

    // Check whether there is an existing recent data or not
    if (lastUnitIndex == -1) {
      ErrorHandler.errorHandler(
        message: 'No recent unit found',
        onError: onError,
      );
    } else {
      int index = prefs.getInt(MyConstants.LAST_UNIT_INDEX) ?? 0;
      onSuccess(index);
    }
  }

  /*This function is used to save the key data of the last unit opened by a user
  key data like Book_Id and Unit_Id ect..*/
  static Future<void> saveRecentTab({
    required int index,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(MyConstants.LAST_UNIT_INDEX, index);
  }
}
