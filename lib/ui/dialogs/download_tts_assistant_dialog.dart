import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../my_widgets/app_button.dart';

class DownloadTtsAssistantDialog extends StatelessWidget {
  const DownloadTtsAssistantDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Help',
        style: MyTheme().mainTextStyle.copyWith(
              fontSize: 18.sp,
            ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '1',
              style: MyTheme().mainTextStyle.copyWith(fontSize: 25.sp),
            ),
            RichText(
              text: TextSpan(
                style: MyTheme().mainTextStyle.copyWith(fontSize: 14.sp),
                children: [
                  const TextSpan(
                    text: 'Click ',
                  ),
                  TextSpan(
                    text: 'Go to my settings ',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: MyColors.themeColors[300],
                    ),
                  ),
                  const TextSpan(
                    text: 'button\n',
                  ),
                ],
              ),
            ),
            // Steps for downloading TTS accents
            Text(
              '2',
              style: MyTheme()
                  .mainTextStyle
                  .copyWith(fontSize: 25.sp)
                  .copyWith(fontSize: 25.sp),
            ),
            Image.asset('assets/images/download_steps/1.png'),
            Text(
              '3',
              style: MyTheme()
                  .mainTextStyle
                  .copyWith(fontSize: 25.sp)
                  .copyWith(fontSize: 25.sp),
            ),
            Image.asset('assets/images/download_steps/2.png'),
            Text('4', style: MyTheme().mainTextStyle.copyWith(fontSize: 25.sp)),
            Image.asset('assets/images/download_steps/3.png'),
            Text(
              '5',
              style: MyTheme().mainTextStyle.copyWith(fontSize: 25.sp),
            ),
            Image.asset('assets/images/download_steps/4.png'),
          ],
        ),
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Button to navigate to TTS settings
            AppButton(
              text: 'Go to my settings',
              onPressed: () async {
                const AndroidIntent intent = AndroidIntent(
                  action: 'com.android.settings.TTS_SETTINGS',
                  package: 'com.android.settings',
                );
                await intent.launch();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            // Cancel button
            AppButton(
              text: 'Cancel',
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        )
      ],
    );
  }
}
