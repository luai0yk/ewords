import 'package:ewords/models/unit_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hidable/hidable.dart';
import 'package:provider/provider.dart';

import '../../provider/settings_provider.dart';
import '../../provider/tabbar_icons_visibility_provider.dart';
import '../../provider/tts_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
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

  FlutterTts? flutterTts;

  TTSProvider? ttsProvider; // Store reference to TTSProvider

  @override
  void initState() {
    super.initState();

    /*Initialization for TabController that handles
    the count of tabs and the animation of then*/
    tabController = TabController(length: 3, vsync: this);

    /*Initialization for FlutterTts*/
    flutterTts = TTS.instance;

    /*Listen to TabBar changes in our case when it changes FlutterTts stops*/
    tabController!.addListener(() {
      //Stop playing TTS whenever the tab changes
      ttsProvider!.stop();
      flutterTts!.stop();

      //Hide the share and speak icons if the current tab is QuizTab
      Provider.of<TabBarIconsVisibilityProvider>(context, listen: false)
          .showHideTabBarIcons(tabController!.index);
    });

    flutterTts!.setProgressHandler(
      (text, start, end, word) {
        if (tabController!.index == 1) {
          ttsProvider!.updateCurrentWordStartEnd(start, end);
        }
      },
    );

    flutterTts!.setCompletionHandler(
      () {
        flutterTts!.stop();
        ttsProvider!.stop();
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /*The speech rate or speed
    * its value comes from the settings page (Slider's value)*/
    flutterTts!.setSpeechRate(context.read<SettingsProvider>().speechRate!);

    // Store the reference to avoid accessing context in dispose()
    ttsProvider = context.read<TTSProvider>();

    /*The speech language or accent
    * its value comes from the settings page (Accent's ListTile>>RadioListTile)*/
    flutterTts!.setLanguage(context.read<SettingsProvider>().speechAccentCode!);

    /*Initialization for FlutterTts which handle text to speak*/
    /*Save key data once the page is opened*/

    unit ??= ModalRoute.of(context)!.settings.arguments as UnitModel;

    RecentUnit.saveRecentTab(index: unit!.id - 1);
  }

  @override
  void dispose() {
    flutterTts!.stop();
    ttsProvider!.stop(listen: false);
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
                          icon: const Icon(
                            Icons.share_rounded,
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
                                  flutterTts!.stop();
                                  ttsProvider!.stop();
                                } else {
                                  if (tabController!.index == 0) {
                                    flutterTts!.speak(
                                      await CombineUnitWords.getCombinedWords(
                                        unit!.words,
                                      ),
                                    );
                                  } else if (tabController!.index == 1) {
                                    flutterTts!.speak(unit!.passage);
                                  }
                                  ttsProvider!.play();
                                }
                              },
                              icon: isPlaying &&
                                      ttsProvider!.currentPlayingWordID == -1
                                  ? const Icon(Icons.stop_rounded)
                                  : const Icon(Icons.volume_up_rounded),
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
      body: TabBarView(
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
    );
  }
}
