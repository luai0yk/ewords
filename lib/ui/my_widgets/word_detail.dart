import 'package:ewords/models/word_model.dart';
import 'package:ewords/theme/my_theme.dart';
import 'package:ewords/ui/my_widgets/app_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants.dart';

class WordDetail extends StatelessWidget {
  final WordModel word;

  const WordDetail({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBadge(
                  text:
                      '${MyConstants.levelCodes[word.bookId - 1]} - ${MyConstants.levelNames[word.bookId - 1]}',
                ),
                const SizedBox(width: 5),
                AppBadge(
                  text: 'Unit${word.unitId}',
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          const AppBadge(text: 'WORD'),
          SizedBox(height: 5.h),
          Text(
            word.word.substring(0, 1).toUpperCase() + word.word.substring(1),
            style: MyTheme().mainTextStyle.copyWith(fontSize: 18.sp),
          ),
          SizedBox(height: 25.h),
          const AppBadge(text: 'DEFINITION'),
          SizedBox(height: 5.h),
          Text(
            word.definition,
            style: MyTheme().secondaryTextStyle.copyWith(
                  fontSize: 15.sp,
                  height: 1.3,
                ),
          ),
          SizedBox(height: 25.h),
          const AppBadge(text: 'EXAMPLE'),
          SizedBox(height: 5.h),
          Text(
            word.example,
            style: MyTheme().thirdTextStyle.copyWith(
                  fontSize: 15.sp,
                  fontStyle: FontStyle.italic,
                  height: 1.2,
                ),
          ),
        ],
      ),
    );
  }
}
