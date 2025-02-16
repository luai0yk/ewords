import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../provider/quiz_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';

class PauseResumeDialog extends StatelessWidget {
  final TabController tabController;
  const PauseResumeDialog({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    context.read<QuizProvider>().isPaused = true;

    return PopScope(
      canPop: false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Resume Quiz",
            style: MyTheme().mainTextStyle.copyWith(
                  fontSize: 18.sp,
                ),
          ),
          content: Text(
            "Comeback soon, we are waiting for you!",
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
                    context.read<QuizProvider>().isPaused = false;
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Resume',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.themeColors[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                    tabController.animateTo(0);
                  },
                  child: Text(
                    'Quit',
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
        ),
      ),
    );
  }
}
