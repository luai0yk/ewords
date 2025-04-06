import 'package:ewords/provider/diamonds_provider.dart';
import 'package:ewords/provider/quiz_provider.dart';
import 'package:ewords/provider/units_provider.dart';
import 'package:ewords/utils/ads/reward_ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    MultiProvider(
      providers: [
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
      child: const MyApp(),
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
    await Provider.of<UnitsProvider>(context, listen: false).fetchUnits();
    await Provider.of<UnitsProvider>(context, listen: false).fetchScores();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    return Provider.value(
      value: _rewardAd,
      child: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                theme: MyTheme.lightTheme,
                darkTheme: MyTheme.darkTheme,
                themeMode: provider.themeState == 'Light'
                    ? ThemeMode.light
                    : provider.themeState == 'Dark'
                        ? ThemeMode.dark
                        : ThemeMode.system,
                debugShowCheckedModeBanner: false,
                home: const HomePage(),
              );
            },
          );
        },
      ),
    );
  }
}
