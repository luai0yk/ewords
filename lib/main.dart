import 'package:ewords/provider/diamonds_provider.dart';
import 'package:ewords/provider/quiz_provider.dart';
import 'package:ewords/provider/units_provider.dart';
import 'package:ewords/utils/ads/reward_ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../provider/favorite_words_provider.dart';
import '../../provider/gnav_provider.dart';
import '../../provider/tabbar_icons_visibility_provider.dart';
import '../provider/dictionary_provider.dart';
import '../provider/settings_provider.dart';
import '../provider/tts_provider.dart';
import '../theme/my_theme.dart';
import 'ui/pages/home_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();

  FlutterNativeSplash.preserve(
    widgetsBinding: widgetsBinding,
  );

  runApp(
    MultiProvider(
      providers: [
        // Initialize providers for state management
        ChangeNotifierProvider(create: (context) => DictionaryProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteWordsProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => TTSProvider()),
        ChangeNotifierProvider(create: (context) => GNavProvider()),
        ChangeNotifierProvider(
            create: (context) => TabBarIconsVisibilityProvider()),
        ChangeNotifierProvider(create: (context) => QuizProvider()),
        ChangeNotifierProvider(create: (context) => UnitsProvider()),
        ChangeNotifierProvider(create: (context) => DiamondsProvider()),
      ],
      child: const MyApp(), // Start the app with MyApp as the root widget
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late RewardAd _rewardAd;

  @override
  void initState() {
    super.initState();
    init();

    _rewardAd = RewardAd(
      context: context,
      onRewardEarned: () {
        context.read<DiamondsProvider>().adRewardDiamonds(diamonds: 6);
      },
    );

    _rewardAd.loadRewardedAd();
  }

  void init() async {
    // Fetch units while the splash screen is displayed
    await Provider.of<UnitsProvider>(context, listen: false).fetchUnits();
    await Provider.of<UnitsProvider>(context, listen: false).fetchScores();
    // Remove the splash screen after the units are fetched
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _rewardAd,
      child: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          return ScreenUtilInit(
            designSize: const Size(
                360, 690), // Set the design size for responsive layout
            minTextAdapt:
                true, // Enable text adaptation for different screen sizes
            splitScreenMode: true, // Enable split screen mode for large devices
            builder: (context, child) {
              return MaterialApp(
                theme: MyTheme.lightTheme, // Set the light theme
                darkTheme: MyTheme.darkTheme, // Set the dark theme
                themeMode: provider.themeState == 'Light'
                    ? ThemeMode.light // Use light theme if selected
                    : provider.themeState == 'Dark'
                        ? ThemeMode.dark // Use dark theme if selected
                        : ThemeMode
                            .system, // Use system theme if no specific selection
                debugShowCheckedModeBanner: false, // Hide the debug banner
                home: const HomePage(), // Set the home page of the app
              );
            },
          );
        },
      ),
    );
  }
}
