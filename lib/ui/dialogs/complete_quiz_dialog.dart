import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';

class CompleteQuizDialog extends StatelessWidget {
  final Function() onRestart;
  const CompleteQuizDialog({super.key, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.themeColors[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: () {
                onRestart();
                Navigator.of(context).pop();
              },
              child: Text(
                'Restart',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
