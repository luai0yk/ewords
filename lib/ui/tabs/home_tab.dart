import 'package:ewords/models/quiz_score_model.dart';
import 'package:ewords/models/unit_model.dart';
import 'package:ewords/provider/quiz_provider.dart';
import 'package:ewords/provider/units_provider.dart';
import 'package:ewords/theme/my_colors.dart';
import 'package:ewords/theme/my_theme.dart';
import 'package:ewords/ui/pages/unit_content_page.dart';
import 'package:ewords/utils/helpers/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hidable/hidable.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/diamonds_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers/snackbar_helper.dart';
import '../../utils/recent_unit.dart';
import '../dialogs/app_dialog.dart';
import '../my_widgets/my_card.dart';
import '../my_widgets/my_snackbar.dart';
import '../pages/dictionary_page.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int? currentActiveUnit;

  late RewardedAd _rewardedAd;
  bool _isAdLoaded = false;

  DiamondsProvider? _diamondsProvider;

  final ScrollController _scrollController = ScrollController();

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    currentActiveUnit = prefs.getInt('current_active_unit') ?? 1;
  }

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init();
    _diamondsProvider = context.read<DiamondsProvider>();
    _diamondsProvider!.loadDiamonds();
  }

  @override
  void dispose() {
    // _rewardedAd.dispose();
    super.dispose();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Use test ad unit ID
      request: const AdRequest(),

      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isAdLoaded = true;

          SnackBarHelper.show(
            context: context,
            widget: MySnackBar.create(
              content: 'You have a chance to get a reward',
              label: 'Claim',
              onPressed: () {
                _showRewardedAd();
              },
            ),
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isAdLoaded = false;
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_isAdLoaded) {
      _rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          _diamondsProvider!.adRewardDiamonds(diamonds: 5);
        },
      );
      _loadRewardedAd(); // Load another ad
    } else {
      SnackBarHelper.show(
        context: context,
        widget: MySnackBar.create(content: 'Ad is not loaded!'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.initialize(context);

    return Scaffold(
      body: Stack(
        children: [
          Consumer<UnitsProvider>(
            builder: (context, provider, child) {
              if (provider.units == null) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 10),
                );
              }
              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.22,
                  left: MediaQuery.of(context).size.width * 0.22,
                  top: MediaQuery.of(context).size.width * 0.30,
                  bottom: MediaQuery.of(context).size.width * 0.10,
                ),
                reverse: true,
                itemCount: provider.units!.length,
                itemBuilder: (context, index) {
                  if (index == 0 || (index % 31 == 0)) {
                    return MyCard(
                      //  margin: EdgeInsets.only(bottom: 30.h),
                      child: Text(
                        MyConstants
                            .bookDescription[provider.units![index].bookId - 1],
                        style: MyTheme().secondaryTextStyle.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    );
                  } else {
                    final itemIndex = index - ((index ~/ 31) + 1);

                    return _buildListItem(
                      itemIndex,
                      provider.units ?? [],
                      provider.scores ?? [],
                    );
                  }
                },
              );
            },
          ),
          Hidable(
            controller: _scrollController,
            preferredWidgetSize: Size.fromHeight(60.h),
            deltaFactor: 0.06,
            child: _buildFloatingButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
    int index,
    List<UnitModel> units,
    List<QuizScoreModel> scores,
  ) {
    Color? unPassedUnitColor = Theme.of(context).brightness == Brightness.light
        ? MyColors.themeColors[50]
        : MyColors.themeColors[50]!.withOpacity(0.1);

    final UnitModel unit = units[index];
    Alignment alignment = _getAlignment(index);

    context.read<QuizProvider>().checkPassedUnits(
          id: unit.id,
          bookId: unit.bookId,
          unitId: unit.unitId,
        );

    return Selector<QuizProvider, bool>(
      builder: (context, isPassed, child) {
        // bool isPassed = provider.isPassed(unit.id);
        QuizScoreModel? score;
        //
        if (isPassed && index < scores.length) {
          score = scores[index];
        }

        print('built list items');

        return Container(
          alignment: alignment,
          child: Container(
            width: 100.w,
            // height: 120.h,
            // color: Colors.red,
            margin: EdgeInsets.symmetric(vertical: 30.h),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isPassed || currentActiveUnit == unit.id) {
                      MyTheme.initialize(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UnitContentPage(),
                          settings: RouteSettings(arguments: unit),
                        ),
                      );
                    } else {
                      SnackBarHelper.show(
                        context: context,
                        widget:
                            MySnackBar.create(content: 'This unit is locked'),
                      );
                    }
                  },
                  child: Container(
                    height: currentActiveUnit == unit.id ? 85.r : 72.r,
                    width: currentActiveUnit == unit.id ? 85.r : 72.r,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: isPassed || currentActiveUnit == unit.id
                          ? MyColors.themeColors[300]
                          : unPassedUnitColor,
                      borderRadius: BorderRadius.circular(90),
                      border: currentActiveUnit == unit.id
                          ? Border.all(
                              color: MyColors.themeColors[50]!.withOpacity(.7),
                              width: 5,
                            )
                          : const Border(),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isPassed || currentActiveUnit == unit.id
                            ? Colors.white
                            : MyColors.themeColors[300],
                        fontSize: 35.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (isPassed && score != null)
                  _buildUnitStars(score: score.totalScore),
              ],
            ),
          ),
        );
      },
      selector: (p0, provider) {
        return provider.isPassed(unit.id);
      },
    );
  }

  Widget _buildUnitStars({required double score}) {
    print('built stars');
    Color? firstStarColor, secondStarColor, thirdStarColor;

    firstStarColor =
        score >= 50 ? MyColors.themeColors[300] : MyColors.themeColors[50];
    secondStarColor =
        score >= 75 ? MyColors.themeColors[300] : MyColors.themeColors[50];
    thirdStarColor =
        score >= 90 ? MyColors.themeColors[300] : MyColors.themeColors[50];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedStar,
          color: firstStarColor!,
        ),
        const SizedBox(width: 3),
        HugeIcon(
          icon: HugeIcons.strokeRoundedStar,
          color: secondStarColor!,
        ),
        const SizedBox(width: 3),
        HugeIcon(
          icon: HugeIcons.strokeRoundedStar,
          color: thirdStarColor!,
        ),
      ],
    );
  }

  Widget _buildFloatingButtons() {
    return MyCard(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 5,
        left: MediaQuery.of(context).padding.top / 2,
        right: MediaQuery.of(context).padding.top / 2,
      ),
      padding: EdgeInsets.all(4.sp),
      width: double.infinity,
      height: 35.h,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                DialogHelper.show(
                  context: context,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return AppDialog(
                      title: 'Rewarded Ad',
                      content: 'Watch an ad and get 5 diamonds.',
                      okayText: 'Watch Ad',
                      onOkay: () {
                        _showRewardedAd();
                      },
                      onCancel: () => null,
                    );
                  },
                );
              },
              tooltip: 'Diamonds',
              icon: Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedDiamond02,
                    color: MyColors.themeColors[300]!,
                  ),
                  const SizedBox(width: 2),
                  Selector<DiamondsProvider, int>(
                    builder: (context, diamonds, child) {
                      return Text(
                        '$diamonds',
                        style: MyTheme().mainTextStyle.copyWith(
                              color: MyColors.themeColors[300],
                            ),
                      );
                    },
                    selector: (ctx, provider) => provider.diamonds,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              'eWords',
              style: MyTheme().secondaryTextStyle.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
            ),
            const Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DictionaryPage(),
                  ),
                );
              },
              tooltip: 'Dictionary',
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedSearch01,
                color: MyColors.themeColors[300]!,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                MyTheme.initialize(context);
                RecentUnit.loadRecentTap(
                  context: context,
                  onError: (msg) {
                    SnackBarHelper.show(
                      context: context,
                      widget: MySnackBar.create(content: msg),
                    );
                  },
                  onSuccess: (index) {
                    MyTheme.initialize(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UnitContentPage(),
                        settings: RouteSettings(
                          arguments:
                              context.read<UnitsProvider>().units![index],
                        ),
                      ),
                    );
                  },
                );
              },
              tooltip: 'Learning',
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedOnlineLearning01,
                color: MyColors.themeColors[300]!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Alignment _getAlignment(int index) {
    switch (index % 4) {
      case 0:
        return Alignment.topLeft;
      case 1:
        return Alignment.center;
      case 2:
        return Alignment.topRight;
      case 3:
        return Alignment.center;
      default:
        return Alignment.topLeft;
    }
  }
}
