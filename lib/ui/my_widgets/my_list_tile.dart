import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import 'my_card.dart';

class MyListTile extends StatelessWidget {
  final String title, text; // Main title and text for the list tile
  final String subText; // Optional subtext
  final String leadingText; // Optional leading text
  final double titleSize; // Font size for the title
  final double textSize; // Font size for the main text
  final double subTextSize; // Font size for the subtext
  final double leadingTextSize; // Font size for the leading text
  final int textMaxLines, subTextMaxLines; // Maximum lines for text
  final bool isThreeLines; // Controls if subtext is shown
  final bool isLeadingVisible; // Controls visibility of leading text
  final bool isTrailingVisible; // Controls visibility of trailing widgets
  final GestureTapCallback onTap; // Callback for tap events
  final List<Widget>? trailing; // Optional trailing widgets

  const MyListTile({
    super.key,
    required this.title, // Title of the list tile
    required this.text, // Main text of the list tile
    this.subText = '', // Optional subtext, default is empty
    this.leadingText = '', // Optional leading text, default is empty
    this.titleSize = 18, // Default font size for title
    this.textSize = 14, // Default font size for main text
    this.subTextSize = 13, // Default font size for subtext
    this.leadingTextSize = 30, // Default font size for leading text
    this.textMaxLines = 0, // Max lines for the main text
    this.subTextMaxLines = 0, // Max lines for the subtext
    this.isThreeLines = true, // Whether to show three lines including subtext
    this.isLeadingVisible = false, // Control visibility of leading text
    this.isTrailingVisible = false, // Control visibility of trailing widgets
    required this.onTap, // Callback for tap action
    this.trailing, // Optional trailing widgets
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MyCard(
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            Visibility(
              visible: isLeadingVisible,
              child: Container(
                alignment: Alignment.center,
                height: 65.r,
                width: 65.r,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40.r,
                      height: 25.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: MyColors.themeColors[300]!.withOpacity(0.1),
                      ),
                    ),
                    Text(
                      leadingText,
                      style: TextStyle(
                        color: MyColors.themeColors[300],
                        fontSize: leadingTextSize.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.sp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MyColors.themeColors[300],
                      fontSize: titleSize.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    text,
                    maxLines: textMaxLines != 0 ? textMaxLines : 100,
                    style: MyTheme().secondaryTextStyle.copyWith(
                          fontSize: textSize.sp,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Visibility(
                    visible: isThreeLines,
                    child: Text(
                      subText,
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
    );
  }
}
