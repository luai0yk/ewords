import 'package:ewords/models/quiz_score_model.dart';
import 'package:ewords/models/unit_model.dart';
import 'package:ewords/provider/quiz_provider.dart';
import 'package:ewords/provider/units_provider.dart';
import 'package:ewords/theme/my_colors.dart';
import 'package:ewords/theme/my_theme.dart';
import 'package:ewords/ui/pages/unit_content_page.dart';
import 'package:ewords/utils/ads/reward_ad.dart';
import 'package:ewords/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hidable/hidable.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../provider/diamonds_provider.dart';
import '../../utils/helpers/snackbar_helper.dart';
import '../my_widgets/floating_appbar.dart';
import '../my_widgets/my_card.dart';
import '../my_widgets/my_snackbar.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  DiamondsProvider? _diamondsProvider;
  QuizProvider? _quizProvider;

  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _unitKeys = {};

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollToActiveUnit(context.read<UnitsProvider>().units!,
    //       context.read<UnitsProvider>().scores!);
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _diamondsProvider = context.read<DiamondsProvider>();
    _quizProvider = context.read<QuizProvider>();
    _quizProvider!.init();
    _diamondsProvider!.loadDiamonds();
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
                key: const PageStorageKey<String>('units'),
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
                      child: RichText(
                        text: TextSpan(
                          style: MyTheme().secondaryTextStyle.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                          children: [
                            WidgetSpan(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: MyColors.themeColors[50],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  MyConstants.levelCodes[
                                      provider.units![index].bookId - 1],
                                  style: TextStyle(
                                    color: MyColors.themeColors[300],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text:
                                  '  ${MyConstants.levelDescription[provider.units![index].bookId - 1]}',
                            ),
                          ],
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
            child: FloatingAppBar(
              showRewardedAd: () {
                context.read<RewardAd>().showRewardedAd();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToActiveUnit(List<UnitModel> units, List<QuizScoreModel> scores) {
    final QuizProvider quizProvider = context.read<QuizProvider>();
    for (int i = 0; i < units.length; i++) {
      final UnitModel unit = units[i];
      final unitStatus = quizProvider.getUnitStatus(unit.id);
      if (unitStatus['current_active_unit'] == 5) {
        final GlobalKey? key = _unitKeys[unit.id];
        if (key != null && key.currentContext != null) {
          final RenderBox renderBox =
              key.currentContext!.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          _scrollController.animateTo(
            position.dy + _scrollController.offset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        break;
      }
    }
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

    return Selector<QuizProvider, Map<String, dynamic>>(
      builder: (context, passedUnits, child) {
        bool isPassed = passedUnits['is_passed'];
        int currentActiveUnit = passedUnits['current_active_unit'];
        QuizScoreModel? score;
        //
        if (isPassed && index < scores.length) {
          score = scores[index];
        }

        _unitKeys[unit.id] = GlobalKey();

        return Container(
          key: _unitKeys[unit.id],
          alignment: alignment,
          child: Container(
            width: 100.w,
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
                      ).then(
                        (value) {
                          _quizProvider!.init();
                        },
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
      selector: (context, selector) {
        return selector.getUnitStatus(unit.id);
      },
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

// @override
// void dispose() {
//  // _scrollController.dispose();
//   super.dispose();
// }
