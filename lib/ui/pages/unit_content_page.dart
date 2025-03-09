import 'package:ewords/models/unit_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hidable/hidable.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../provider/settings_provider.dart';
import '../../provider/tabbar_icons_visibility_provider.dart';
import '../../provider/tts_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../../utils/ads/banner_ad.dart';
import '../../utils/combine_unit_words.dart';
import '../../utils/helpers/bottom_sheet_helper.dart';
import '../../utils/recent_unit.dart';
import '../../utils/tts.dart';
import '../dialogs/share_unit_content_dialog.dart';
import '../tabs/passage_tab.dart';
import '../tabs/quiz_tab.dart';
import '../tabs/words_tab.dart';

class UnitContentPage extends StatefulWidget {
  const UnitContentPage({super.key});

  @override
  State<UnitContentPage> createState() => _UnitContentPageState();
}

class _UnitContentPageState extends State<UnitContentPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  final ScrollController scrollController = ScrollController();

  UnitModel? unit;

  FlutterTts? _flutterTts;

  TabBarIconsVisibilityProvider? _tabBarIconsVisibilityProvider;

  TTSProvider? _ttsProvider; // Store reference to TTSProvider

  @override
  void initState() {
    super.initState();

    /*Initialization for TabController that handles
    the count of tabs and the animation of them*/
    tabController = TabController(length: 3, vsync: this);

    /*Initialization for FlutterTts*/
    _flutterTts = TTS.instance;

    /*Listen to TabBar changes in our case when it changes FlutterTts stops*/
    tabController!.addListener(() {
      //Stop playing TTS whenever the tab changes
      _ttsProvider!.stop();
      _flutterTts!.stop();

      //Hide the share and speak icons if the current tab is QuizTab
      _tabBarIconsVisibilityProvider!.showHideTabBarIcons(tabController!.index);
    });

    _flutterTts!.setProgressHandler(
      (text, start, end, word) {
        if (tabController!.index == 1) {
          _ttsProvider!.updateCurrentWordStartEnd(start, end);
        }
      },
    );

    _flutterTts!.setCompletionHandler(
      () {
        _flutterTts!.stop();
        _ttsProvider!.stop();
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /*The speech rate or speed
    * its value comes from the settings page (Slider's value)*/
    _flutterTts!.setSpeechRate(context.read<SettingsProvider>().speechRate!);

    // Store the reference to avoid accessing context in dispose()
    _ttsProvider = context.read<TTSProvider>();

    _tabBarIconsVisibilityProvider =
        context.read<TabBarIconsVisibilityProvider>();

    /*The speech language or accent
    * its value comes from the settings page (Accent's ListTile>>RadioListTile)*/
    _flutterTts!
        .setLanguage(context.read<SettingsProvider>().speechAccentCode!);

    /*Initialization for FlutterTts which handle text to speak*/
    /*Save key data once the page is opened*/

    unit ??= ModalRoute.of(context)!.settings.arguments as UnitModel;

    RecentUnit.saveRecentTab(index: unit!.id - 1);
  }

  @override
  void dispose() {
    _flutterTts!.stop();

    _ttsProvider!.stop(listen: false);

    //make the tab number 0 to show the icons when the page is opened again
    _tabBarIconsVisibilityProvider!.tabNumber = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Hidable(
        deltaFactor: 0.06,
        controller: scrollController,
        preferredWidgetSize: Size.fromHeight(130.sp),
        child: AppBar(
          title: Text(unit!.passageTitle),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            tooltip: 'Back',
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: MyColors.themeColors[300]!,
            ),
          ),
          actions: [
            Selector<TabBarIconsVisibilityProvider, int>(
              builder: (context, value, child) {
                return Visibility(
                    visible: value == 2 ? false : true,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            BottomSheetHelper.show(
                              context: context,
                              builder: (context) => ShareUnitContentDialog(
                                unit: unit!,
                                tabIndex: tabController!.index,
                              ),
                            );
                          },
                          tooltip: 'Share',
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedShare08,
                            color: MyColors.themeColors[300]!,
                          ),
                        ),
                        Selector<TTSProvider, bool>(
                          selector: (context, provider) {
                            return provider.isPlaying;
                          },
                          builder: (context, isPlaying, child) {
                            return IconButton(
                              onPressed: () async {
                                if (isPlaying) {
                                  _flutterTts!.stop();
                                  _ttsProvider!.stop();
                                } else {
                                  if (tabController!.index == 0) {
                                    _flutterTts!.speak(
                                      await CombineUnitWords.getCombinedWords(
                                        unit!.words,
                                      ),
                                    );
                                  } else if (tabController!.index == 1) {
                                    _flutterTts!.speak(unit!.passage);
                                  }
                                  _ttsProvider!.play();
                                }
                              },
                              tooltip: isPlaying ? 'Stop' : 'Speak',
                              icon: isPlaying &&
                                      _ttsProvider!.currentPlayingWordID == -1
                                  ? HugeIcon(
                                      icon: HugeIcons.strokeRoundedStop,
                                      color: MyColors.themeColors[300]!,
                                    )
                                  : HugeIcon(
                                      icon: HugeIcons.strokeRoundedMegaphone02,
                                      color: MyColors.themeColors[300]!,
                                    ),
                            );
                          },
                        ),
                      ],
                    ));
              },
              selector: (context, value) {
                return value.tabNumber;
              },
            )
          ],
          bottom: TabBar(
            controller: tabController,
            dividerHeight: 0,
            labelColor: Colors.white,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyColors.themeColors[300],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            splashBorderRadius: BorderRadius.circular(10.sp),
            indicatorPadding: EdgeInsets.all(6.sp),
            labelStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
            tabs: const [
              Tab(child: Text('WORDS')),
              Tab(child: Text('PASSAGE')),
              Tab(child: Text('QUIZ')),
            ],
          ),
          titleTextStyle: MyTheme().appBarTitleStyle,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              dragStartBehavior: DragStartBehavior.start,
              controller: tabController,
              children: [
                WordsTab(
                  unit: unit!,
                  scrollController: scrollController,
                ),
                PassageTab(
                    passage: unit!.passage, scrollController: scrollController),
                QuizTab(
                  unit: unit!,
                  tabController: tabController!,
                ),
                //TimerProgressBar(),
              ],
            ),
          ),
          const AdBanner(), // Add AdBanner widget here
        ],
      ),
    );
  }
}
