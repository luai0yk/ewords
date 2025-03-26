import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../my_widgets/app_button.dart';

class CompleteQuizDialog extends StatelessWidget {
  final Function() onRestart;
  final TabController tabController;
  const CompleteQuizDialog(
      {super.key, required this.onRestart, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Quiz Completed",
            style: MyTheme().mainTextStyle.copyWith(
                  fontSize: 18.sp,
                ),
          ),
          content: Text(
            "You have answered all the questions.",
            style: MyTheme().mainTextStyle.copyWith(fontSize: 14.sp),
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppButton(
                  text: 'Restart',
                  onPressed: () {
                    onRestart();
                    Navigator.of(context).pop();
                  },
                ),
                AppButton(
                  text: 'Quit',
                  onPressed: () {
                    onRestart();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
