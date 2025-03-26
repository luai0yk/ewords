import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../provider/settings_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../my_widgets/app_button.dart';

class ChangeThemeDialog extends StatelessWidget {
  const ChangeThemeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        'App Theme',
        style: MyTheme().mainTextStyle.copyWith(
              fontSize: 18.sp,
            ),
      ),
      content: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Radio buttons for selecting app theme
              RadioListTile(
                value: 'Light',
                splashRadius: 15,
                activeColor: MyColors.themeColors[300],
                groupValue: provider.themeState,
                onChanged: (value) {
                  provider.changeTheme(value!); // Change app theme
                  Navigator.of(context).pop(); // Close the dialog
                },
                title: Text(
                  'Light',
                  style: MyTheme().mainTextStyle.copyWith(fontSize: 14.sp),
                ),
              ),
              RadioListTile(
                value: 'Dark',
                activeColor: MyColors.themeColors[300],
                splashRadius: 15,
                groupValue: provider.themeState,
                onChanged: (value) {
                  provider.changeTheme(value!); // Change app theme
                  Navigator.of(context).pop(); // Close the dialog
                },
                title: Text(
                  'Dark',
                  style: MyTheme().mainTextStyle.copyWith(fontSize: 14.sp),
                ),
              ),
              RadioListTile(
                splashRadius: 15,
                activeColor: MyColors.themeColors[300],
                value: 'System default',
                groupValue: provider.themeState,
                onChanged: (value) {
                  provider.changeTheme(value!); // Change app theme
                  Navigator.of(context).pop(); // Close the dialog
                },
                title: Text(
                  'System default',
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
            AppButton(
              text: 'Cancel',
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      ],
    );
  }
}
