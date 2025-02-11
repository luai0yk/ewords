import 'package:ewords/utils/helpers/bottom_sheet_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hidable/hidable.dart';
import 'package:provider/provider.dart';

import '../../args/passage_args.dart';
import '../../provider/settings_provider.dart';
import '../../provider/tabbar_icons_visibility_provider.dart';
import '../../provider/tts_provider.dart';
import '../../theme/my_theme.dart';
import '../../ui/tabs/passage_tab.dart';
import '../../utils/combine_unit_words.dart';
import '../../utils/recent_tab.dart';
import '../../utils/tts.dart';
import '../dialogs/share_unit_content_dialog.dart';
import '../tabs/unit_quiz_tab.dart';
import '../tabs/unit_words_tab.dart';

class UnitContentPage extends StatefulWidget {
  const UnitContentPage({super.key});

  @override
  State<UnitContentPage> createState() => _UnitContentPageState();
}

class _UnitContentPageState extends State<UnitContentPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  final ScrollController scrollController = ScrollController();

  PassageArgs? passageArgs;

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
          print(word);
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

    // Ensure passageArgs is only set once
    passageArgs ??= ModalRoute.of(context)!.settings.arguments as PassageArgs;

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
    RecentTab.saveRecentTab(passageArgs: passageArgs!);
  }

  @override
  void dispose() {
    flutterTts!.stop();
    ttsProvider!.stop(listen: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MyTheme.initialize(context);
    // myContext = context;
    return Scaffold(
      appBar: Hidable(
        deltaFactor: 0.06,
        controller: scrollController,
        preferredWidgetSize: Size.fromHeight(130.sp),
        child: AppBar(
          title: Text(passageArgs!.passageTitle),
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
                                passageArgs: passageArgs!,
                                index: tabController!.index,
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
                                            passageArgs!));
                                  } else if (tabController!.index == 1) {
                                    flutterTts!.speak(passageArgs!.passage);
                                  }
                                  ttsProvider!.play();
                                }
                              },
                              icon: isPlaying &&
                                      ttsProvider!.currentPlayingWordID.isEmpty
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
            dividerHeight: 1,
            dividerColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white12
                : Colors.black12,
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
          UnitWordListPage(
            passageArgs: passageArgs!,
            scrollController: scrollController,
          ),
          PassageTab(passageArgs: passageArgs!),
          UnitQuizTab(passageArgs: passageArgs!),
          //TimerProgressBar(),
        ],
      ),
    );
  }
}
