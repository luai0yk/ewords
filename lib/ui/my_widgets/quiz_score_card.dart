import 'package:ewords/models/quiz_score_model.dart';
import 'package:ewords/ui/my_widgets/app_badge.dart';
import 'package:ewords/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../theme/my_colors.dart';

class QuizScoreCard extends StatelessWidget {
  final QuizScoreModel quizScore;
  const QuizScoreCard({super.key, required this.quizScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.sp),
      margin: EdgeInsets.only(bottom: 8.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: Colors.black12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              AppBadge(
                text: MyConstants.levelCodes[quizScore.bookId - 1],
              ),
              const SizedBox(width: 5),
              AppBadge(
                text: 'U${quizScore.unitId}',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                          size: 15.sp,
                          color: Colors.green,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Correct: ${quizScore.correctAnswers}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        tween: Tween<double>(
                          begin: 0,
                          end: quizScore.correctAnswers / 20,
                        ),
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.green[50],
                          color: Colors.green[400],
                          minHeight: 22.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedMultiplicationSignCircle,
                          size: 15.sp,
                          color: Colors.red,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Wrong: ${quizScore.wrongAnswers}',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        tween: Tween<double>(
                          begin: 0,
                          end: quizScore.wrongAnswers / 20,
                        ),
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.red[50],
                          color: Colors.red[400],
                          minHeight: 22.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0,
                    end: quizScore.totalScore / 100,
                  ),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => LinearProgressIndicator(
                    color: MyColors.themeColors[400],
                    backgroundColor: MyColors.themeColors[50],
                    value: value,
                    minHeight: 22.h,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Score ${quizScore.totalScore.toInt()}%',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
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
