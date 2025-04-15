import 'package:android_intent_plus/android_intent.dart';
import 'package:ewords/ui/dialogs/change_theme_dialog.dart';
import 'package:ewords/ui/dialogs/change_tts_language_dialog.dart';
import 'package:ewords/ui/dialogs/download_tts_assistant_dialog.dart';
import 'package:ewords/ui/my_widgets/my_snackbar.dart';
import 'package:ewords/ui/tabs/launch_site.dart';
import 'package:ewords/utils/helpers/dialog_helper.dart';
import 'package:ewords/utils/launch_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/settings_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';

BuildContext? myContext; // Global context for dialog navigation

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences? prefs; // SharedPreferences instance

  @override
  void initState() {
    super.initState();
    init(); // Initialize SharedPreferences on startup
  }

  // Asynchronous function to initialize SharedPreferences
  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.initialize(context);
    myContext = context; // Set global context for dialog navigation
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.toUpperCase()),
        titleTextStyle: TextStyle(
          color: MyColors.themeColors[300],
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      body: ListView(
        children: [
          // Section title for General settings
          Padding(
            padding: EdgeInsets.only(top: 15.sp, left: 15.sp, right: 15.sp),
            child: Text('General settings', style: MyTheme().headSettingStyle),
          ),
          // List tile for theme selection
          ListTile(
            leading: Theme.of(context).brightness == Brightness.light
                ? HugeIcon(
                    icon: HugeIcons.strokeRoundedSun01,
                    color: MyColors.themeColors[300]!,
                  )
                : HugeIcon(
                    icon: HugeIcons.strokeRoundedMoon02,
                    color: MyColors.themeColors[300]!,
                  ),
            title: Text(
              'Theme',
              style: MyTheme().mainTextStyle,
            ),
            subtitle: Text(
              context.read<SettingsProvider>().themeState!,
              style: MyTheme().secondaryTextStyle,
            ),
            onTap: () {
              DialogHelper.show(
                context: context,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const ChangeThemeDialog();
                },
              );
            },
          ),
          // Section title for TTS settings
          Padding(
            padding: EdgeInsets.only(top: 15.sp, left: 15.sp, right: 15.sp),
            child: Text(
              'TTS settings',
              style: MyTheme().headSettingStyle,
            ),
          ),
          // List tile for accent selection
          ListTile(
            leading: Selector<SettingsProvider, String>(
              builder: (context, value, child) {
                return Text(
                  value == 'en-GB' ? 'UK' : 'US',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: MyColors.themeColors[300],
                  ),
                );
              },
              selector: (ctx, val) {
                return val.speechAccentCode!;
              },
            ),
            title: Text(
              'Accent',
              style: MyTheme().mainTextStyle,
            ),
            subtitle: Text(
              'This is the accent of text-to-speech',
              style: MyTheme().secondaryTextStyle,
            ),
            onTap: () {
              DialogHelper.show(
                context: context,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const ChangeTtsLanguageDialog();
                },
              );
            },
          ),
          // List tile for speech rate adjustment
          Selector<SettingsProvider, double>(
            selector: (ctx, val) => val.speechRate!,
            builder: (context, value, child) => ListTile(
              leading: HugeIcon(
                icon: HugeIcons.strokeRoundedMegaphone02,
                color: MyColors.themeColors[300]!,
              ),
              title: Text(
                'Speech Rate',
                style: MyTheme().mainTextStyle,
              ),
              subtitle: Slider(
                inactiveColor: MyColors.themeColors[50],
                thumbColor: MyColors.themeColors[500],
                value: value,
                max: 1.5,
                min: 0.2,
                activeColor: MyColors.themeColors[300],
                onChanged: (value) {
                  context
                      .read<SettingsProvider>()
                      .setSpeechRate(value); // Update speech rate
                },
              ),
              trailing: Text(
                value.toString().substring(0, 3),
                style: MyTheme().secondaryTextStyle.copyWith(
                      fontSize: 12.sp,
                      color: MyColors.themeColors[300],
                    ),
              ),
            ),
          ),

          // List tile for TTS download option
          ListTile(
            leading: HugeIcon(
              icon: HugeIcons.strokeRoundedDownload02,
              color: MyColors.themeColors[300]!,
            ),
            title: Text(
              'Download TTS',
              style: MyTheme().mainTextStyle,
            ),
            subtitle: RichText(
              text: TextSpan(style: MyTheme().secondaryTextStyle, children: [
                const TextSpan(
                  text: 'Download an accent if not downloaded yet, ',
                ),
                WidgetSpan(
                  child: InkWell(
                    child: Text(
                      'help'.toUpperCase(),
                      style: MyTheme().secondaryTextStyle.copyWith(
                            fontSize: 12.sp,
                            color: MyColors.themeColors[300],
                          ),
                    ),
                    onTap: () {
                      DialogHelper.show(
                        context: context,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const DownloadTtsAssistantDialog();
                        },
                      ); // Show help dialog for TTS download
                    },
                  ),
                ),
              ]),
            ),
            onTap: () async {
              // Open Android TTS settings
              const AndroidIntent intent = AndroidIntent(
                action: 'com.android.settings.TTS_SETTINGS',
                package: 'com.android.settings',
              );
              await intent.launch();
            },
          ),

          Padding(
            padding: EdgeInsets.only(top: 15.sp, left: 15.sp, right: 15.sp),
            child: Text('Help & About', style: MyTheme().headSettingStyle),
          ),
          ListTile(
            leading: HugeIcon(
              icon: HugeIcons.strokeRoundedContact,
              color: MyColors.themeColors[300]!,
            ),
            title: Text(
              'Contact us',
              style: MyTheme().mainTextStyle,
            ),
            subtitle: Text(
              'Get in touch — we’re always here to help you!',
              style: MyTheme().secondaryTextStyle,
            ),
            onTap: () {
              LaunchEmail.launch(
                email: 'luai0yk@gmail.com',
                onError: (email) {
                  MySnackBar.create(content: 'Could not launch $email');
                },
              );
            },
          ),
          ListTile(
            leading: HugeIcon(
              icon: HugeIcons.strokeRoundedGithub,
              color: MyColors.themeColors[300]!,
            ),
            title: Text(
              'Contribute',
              style: MyTheme().mainTextStyle,
            ),
            subtitle: Text(
              'eWords is an open-source project, and we welcome contributions.',
              style: MyTheme().secondaryTextStyle,
            ),
            onTap: () {
              LaunchSite.launch(
                url: 'https://github.com/luai0yk/ewords',
                onError: (url) {
                  MySnackBar.create(content: 'Could not launch $url');
                },
              );
            },
          ),
          ListTile(
            leading: HugeIcon(
              icon: HugeIcons.strokeRoundedInformationCircle,
              color: MyColors.themeColors[300]!,
            ),
            title: Text(
              'App Info',
              style: MyTheme().mainTextStyle,
            ),
            subtitle: Text(
              'eWords version 1.0',
              style: MyTheme().secondaryTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
