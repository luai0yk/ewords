import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../args/passage_args.dart';
import '../../provider/quiz_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';

class StartQuizDialog extends StatelessWidget {
  final PassageArgs passageArgs;
  final TabController tabController;
  const StartQuizDialog({
    super.key,
    required this.passageArgs,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    context.read<QuizProvider>().setProgress = 0.0;
    context.read<QuizProvider>().isPaused = true;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Start Quiz",
          style: MyTheme().mainTextStyle.copyWith(
                fontSize: 18.sp,
              ),
        ),
        content: Text(
          "Do you want to start the quiz?",
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
                  context.read<QuizProvider>().loadWords(passageArgs);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Start',
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
                  ),
                ),
                onPressed: () {
                  tabController.animateTo(0);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
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
    );
  }
}
