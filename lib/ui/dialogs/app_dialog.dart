import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';

class AppDialog extends StatelessWidget {
  final String? title, content;
  final Function()? onOkay, onCancel, onOther;
  final String? okayText, cancelText, otherText;
  final Widget? customContent;

  const AppDialog({
    super.key,
    this.title,
    this.content,
    this.onOkay,
    this.onCancel,
    this.onOther,
    this.okayText,
    this.cancelText,
    this.otherText,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null
          ? Text(
              title!,
              style: MyTheme().mainTextStyle.copyWith(
                    fontSize: 18.sp,
                  ),
            )
          : null,
      content: customContent ??
          (content != null
              ? Text(
                  content!,
                  style: MyTheme().mainTextStyle.copyWith(fontSize: 14.sp),
                )
              : null),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (onOkay != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.themeColors[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: () {
                  onOkay!();
                  Navigator.of(context).pop();
                },
                child: Text(
                  okayText ?? 'Okay',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            if (onCancel != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.themeColors[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: () {
                  onCancel!();
                  Navigator.of(context).pop();
                },
                child: Text(
                  cancelText ?? 'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            if (onOther != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.themeColors[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: () {
                  onOther!();
                  Navigator.of(context).pop();
                },
                child: Text(
                  otherText ?? 'Other',
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
