import 'package:ewords/args/passage_args.dart';
import 'package:ewords/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';
import '../ui/pages/unit_content_page.dart';

class RecentTab {
  // Method called when the recent button is tapped
  static void loadRecentTap(
      {required BuildContext context,
      required Function(String msg) onError}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Read the last unit opened from SharedPreferences
    final int unitId = prefs.getInt(MyConstants.UNIT_ID) ?? -1;
    final int bookId = prefs.getInt(MyConstants.BOOK_ID) ?? -1;
    final String passageTitle =
        prefs.getString(MyConstants.PASSAGE_TITLE) ?? '';
    final String passage = prefs.getString(MyConstants.PASSAGE) ?? '';

    // Check whether there is an existing recent data or not
    if (unitId == -1 ||
        bookId == -1 ||
        passageTitle.isEmpty ||
        passage.isEmpty) {
      ErrorHandler.errorHandler(
        message: 'No recent unit found',
        onError: onError,
      );
    } else {
      //Navigate to the UnitViewPage with loaded data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UnitContentPage(),
          settings: RouteSettings(
            arguments: PassageArgs(
                unitId: unitId,
                bookId: bookId,
                passageTitle: passageTitle,
                passage: passage),
          ),
        ),
      );
    }
  }

  /*This function is used to save the key data of the last unit opened by a user
  key data like Book_Id and Unit_Id ect..*/
  static Future<void> saveRecentTab({required PassageArgs passageArgs}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(MyConstants.UNIT_ID, passageArgs.unitId);
    await prefs.setInt(MyConstants.BOOK_ID, passageArgs.bookId);
    await prefs.setString(MyConstants.PASSAGE_TITLE, passageArgs.passageTitle);
    await prefs.setString(MyConstants.PASSAGE, passageArgs.passage);
  }
}
