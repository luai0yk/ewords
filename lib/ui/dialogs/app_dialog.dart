import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/my_theme.dart';
import '../my_widgets/app_button.dart';

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
              AppButton(
                text: okayText ?? 'Okay',
                onPressed: () {
                  onOkay!();
                  Navigator.of(context).pop();
                },
              ),
            if (onCancel != null)
              AppButton(
                text: cancelText ?? 'Cancel',
                onPressed: () {
                  onCancel!();
                  Navigator.of(context).pop();
                },
              ),
            if (onOther != null)
              AppButton(
                text: otherText ?? 'Other',
                onPressed: () {
                  onOther!();
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ],
    );
  }
}
