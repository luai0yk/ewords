import 'package:ewords/models/quiz_score_model.dart';
import 'package:ewords/ui/my_widgets/app_badge.dart';
import 'package:ewords/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                text: 'U:${quizScore.unitId}',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    LinearProgressIndicator(
                      color: Colors.green[300],
                      backgroundColor: Colors.green[50],
                      value: quizScore.correctAnswers / 20,
                      minHeight: 15.h,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    Text(
                      '  Correct ${quizScore.correctAnswers}',
                      style: const TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    LinearProgressIndicator(
                      color: Colors.red[300],
                      backgroundColor: Colors.red[50],
                      value: quizScore.wrongAnswers / 20,
                      minHeight: 15.h,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    Text(
                      '  Wrong ${quizScore.wrongAnswers}',
                      style: const TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              LinearProgressIndicator(
                color: MyColors.themeColors[300],
                backgroundColor: MyColors.themeColors[50],
                value: quizScore.totalScore / 100,
                minHeight: 15.h,
                borderRadius: BorderRadius.circular(15),
              ),
              Text(
                '  Score ${quizScore.totalScore.toInt()}%',
                style: const TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
