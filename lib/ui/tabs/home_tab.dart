import 'package:ewords/models/quiz_score_model.dart';
import 'package:ewords/models/unit_model.dart';
import 'package:ewords/provider/quiz_provider.dart';
import 'package:ewords/provider/units_provider.dart';
import 'package:ewords/theme/my_colors.dart';
import 'package:ewords/theme/my_theme.dart';
import 'package:ewords/ui/pages/unit_content_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/helpers/snackbar_helper.dart';
import '../../utils/recent_unit.dart';
import '../my_widgets/my_card.dart';
import '../my_widgets/my_snackbar.dart';
import '../pages/dictionary_page.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  SharedPreferences? prefs;
  int? currentActiveUnit;
  final ScrollController _scrollController = ScrollController();

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    currentActiveUnit = prefs!.getInt('current_active_unit') ?? 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init();
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
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.22,
                ),
                reverse: true,
                itemCount: provider.units!.length,
                itemBuilder: (context, index) {
                  return _buildListItem(
                      index, provider.units!, provider.scores ?? []);
                },
              );
            },
          ),
          _buildFloatingButtons(),
        ],
      ),
    );
  }

  Widget _buildListItem(
      int index, List<UnitModel> units, List<QuizScoreModel> scores) {
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

    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        bool isPassed = provider.isPassed(unit.id);
        QuizScoreModel? score;

        if (isPassed && index < scores.length) {
          score = scores[index];
        }

        return Container(
          alignment: alignment,
          child: SizedBox(
            width: 85.w,
            height: 120.h,
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
                    }
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 85.r,
                        width: 85.r,
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: isPassed || currentActiveUnit == unit.id
                            ? BoxDecoration(
                                color: MyColors.themeColors[300],
                                borderRadius: BorderRadius.circular(90),
                                border: Border.all(
                                  color: currentActiveUnit == unit.id
                                      ? MyColors.themeColors[50]!
                                          .withOpacity(.7)
                                      : Theme.of(context).colorScheme.onSurface,
                                  width: 5,
                                ),
                              )
                            : BoxDecoration(
                                color: unPassedUnitColor,
                                borderRadius: BorderRadius.circular(90),
                                border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  width: 5,
                                ),
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
                    ],
                  ),
                ),
                if (isPassed && score != null)
                  _buildUnitStars(score: score.totalScore),
              ],
            ),
          ),
        );
      },
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
              onPressed: () {},
              tooltip: 'Diamonds',
              icon: Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedDiamond02,
                    color: MyColors.themeColors[300]!,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${prefs!.getInt('diamond') ?? 5}',
                    style: MyTheme().mainTextStyle.copyWith(
                          color: MyColors.themeColors[300],
                        ),
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

  Widget _buildUnitStars({required double score}) {
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
