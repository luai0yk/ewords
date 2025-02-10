import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../provider/settings_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';

class ChangeTtsLanguageDialog extends StatelessWidget {
  const ChangeTtsLanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'TTS Accent',
        style: MyTheme().mainTextStyle.copyWith(
              fontSize: 18.sp,
            ),
      ),
      content: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Radio buttons for selecting accent
              RadioListTile(
                value: 'en-US',
                groupValue: provider.speechAccentCode,
                activeColor: MyColors.themeColors[300],
                splashRadius: 15,
                onChanged: (value) {
                  provider.setAccent(value!); // Set selected accent
                  Navigator.of(context).pop(); // Close the dialog
                },
                title: Text(
                  'United State (US)',
                  style: MyTheme().mainTextStyle.copyWith(fontSize: 14.sp),
                ),
              ),
              RadioListTile(
                value: 'en-GB',
                groupValue: provider.speechAccentCode,
                activeColor: MyColors.themeColors[300],
                splashRadius: 15,
                onChanged: (value) {
                  provider.setAccent(value!); // Set selected accent
                  Navigator.of(context).pop(); // Close the dialog
                },
                title: Text(
                  'United Kingdom (UK)',
                  style: MyTheme().mainTextStyle.copyWith(fontSize: 14.sp),
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        // Cancel button
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.themeColors[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
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
