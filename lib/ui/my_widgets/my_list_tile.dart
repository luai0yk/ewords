import 'package:ewords/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../../utils/constants.dart';
import 'my_card.dart';

class MyListTile extends StatelessWidget {
  final WordModel word;
  final double titleSize; // Font size for the title
  final double textSize; // Font size for the main text
  final double subTextSize; // Font size for the subtext
  final int textMaxLines, subTextMaxLines; // Maximum lines for text
  final bool isTrailingVisible; // Controls visibility of trailing widgets
  final bool isWordDetailVisible; // Controls visibility of word level and unit
  final GestureTapCallback onTap; // Callback for tap events
  final List<Widget>? trailing; // Optional trailing widgets

  const MyListTile({
    super.key,
    required this.word, // Optional subtext, default is empty
    this.titleSize = 18, // Default font size for title
    this.textSize = 14, // Default font size for main text
    this.subTextSize = 13, // Default font size for subtext
    this.textMaxLines = 0, // Max lines for the main text
    this.subTextMaxLines = 0, // Max lines for the subtext
    this.isTrailingVisible = false, // Control visibility of trailing widgets
    this.isWordDetailVisible =
        false, // Controls visibility of word level and unit
    required this.onTap, // Callback for tap action
    this.trailing, // Optional trailing widgets
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'fav',
        child: MyCard(
          margin: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: isWordDetailVisible,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: MyColors.themeColors[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                MyConstants.levelCodes[word.bookId - 1],
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'U:${word.unitId}',
                                style: TextStyle(
                                  color: MyColors.themeColors[300],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      child: Text(
                        word.word,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MyColors.themeColors[300],
                          fontSize: titleSize.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Material(
                      child: Text(
                        word.definition,
                        maxLines: textMaxLines != 0 ? textMaxLines : 100,
                        style: MyTheme().secondaryTextStyle.copyWith(
                              fontSize: textSize.sp,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Material(
                      child: Text(
                        word.example,
                        maxLines: subTextMaxLines != 0 ? subTextMaxLines : 10,
                        style: MyTheme().thirdTextStyle.copyWith(
                              fontSize: subTextSize.sp,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isTrailingVisible,
                child: Column(
                  children: trailing ?? [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
