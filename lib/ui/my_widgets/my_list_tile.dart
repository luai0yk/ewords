import 'package:ewords/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../../utils/constants.dart';
import 'app_badge.dart';
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
      child: MyCard(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        radius: 22,
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Word title with level badges
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Word title
                      Expanded(
                        child: Text(
                          word.word.substring(0, 1).toUpperCase() +
                              word.word.substring(1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: MyColors.themeColors[300],
                            fontSize: titleSize.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      // Level and Unit badges
                      if (isWordDetailVisible) ...[
                        AppBadge(
                          text: MyConstants.levelCodes[word.bookId - 1],
                        ),
                        const SizedBox(width: 8),
                        AppBadge(
                          text: 'U${word.unitId}',
                        ),
                        const SizedBox(width: 10),
                      ],
                    ],
                  ),

                  // Definition
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: Text(
                      word.definition,
                      maxLines: textMaxLines != 0 ? textMaxLines : 100,
                      style: MyTheme().secondaryTextStyle.copyWith(
                            fontSize: textSize.sp,
                            height: 1.3,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Example
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      word.example,
                      maxLines: subTextMaxLines != 0 ? subTextMaxLines : 10,
                      style: MyTheme().thirdTextStyle.copyWith(
                            fontSize: subTextSize.sp,
                            fontStyle: FontStyle.italic,
                            height: 1.2,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Trailing widgets
            if (isTrailingVisible && trailing != null && trailing!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: trailing!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
