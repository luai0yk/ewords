import 'package:ewords/models/word_model.dart';
import 'package:ewords/theme/my_colors.dart';
import 'package:ewords/theme/my_theme.dart';
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
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.themeColors[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${MyConstants.levelCodes[word.bookId - 1]} - ${MyConstants.levelNames[word.bookId - 1]}',
                    style: TextStyle(
                      color: MyColors.themeColors[300],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.themeColors[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Unit:${word.unitId}',
                    style: TextStyle(
                      color: MyColors.themeColors[300],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          Container(
            decoration: BoxDecoration(
              color: MyColors.themeColors[50],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: EdgeInsets.only(bottom: 4.h),
            child: Text(
              'Word',
              style: TextStyle(
                color: MyColors.themeColors[300],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            word.word.substring(0, 1).toUpperCase() + word.word.substring(1),
            style: MyTheme().mainTextStyle.copyWith(),
          ),
          SizedBox(height: 15.h),
          Container(
            decoration: BoxDecoration(
              color: MyColors.themeColors[50],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: EdgeInsets.only(bottom: 4.h),
            child: Text(
              'Definition',
              style: TextStyle(
                color: MyColors.themeColors[300],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            word.definition,
            style: MyTheme().mainTextStyle.copyWith(),
          ),
          SizedBox(height: 15.h),
          Container(
            decoration: BoxDecoration(
              color: MyColors.themeColors[50],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: EdgeInsets.only(bottom: 4.h),
            child: Text(
              'Example',
              style: TextStyle(
                color: MyColors.themeColors[300],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            word.example,
            style: MyTheme().mainTextStyle.copyWith(),
          ),
        ],
      ),
    );
  }
}
