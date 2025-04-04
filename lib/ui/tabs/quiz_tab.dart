import 'package:ewords/models/unit_model.dart';
import 'package:ewords/provider/units_provider.dart';
import 'package:ewords/ui/my_widgets/app_badge.dart';
import 'package:ewords/ui/my_widgets/app_button.dart';
import 'package:ewords/ui/my_widgets/my_snackbar.dart';
import 'package:ewords/ui/my_widgets/stars_rate.dart';
import 'package:ewords/utils/helpers/snackbar_helper.dart';
import 'package:ewords/utils/tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../provider/diamonds_provider.dart';
import '../../provider/quiz_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../../utils/ads/reward_ad.dart';
import '../../utils/helpers/dialog_helper.dart';
import '../dialogs/app_dialog.dart';
import '../my_widgets/my_card.dart';

class QuizTab extends StatefulWidget {
  final UnitModel unit;
  final TabController tabController;

  const QuizTab({
    super.key,
    required this.unit,
    required this.tabController,
  });

  @override
  State<QuizTab> createState() => _QuizTabState();
}

class _QuizTabState extends State<QuizTab> with WidgetsBindingObserver {
  //late RewardAd _rewardAd;

  QuizProvider? _quizProvider;
  UnitsProvider? _unitsProvider;
  // double? _score;
  // int? _answerdQuestionCount;

  DiamondsProvider? _diamondsProvider;

  @override
  void initState() {
    super.initState();
    _quizProvider = context.read<QuizProvider>();
    _diamondsProvider = context.read<DiamondsProvider>();
    _unitsProvider = context.read<UnitsProvider>();
    _diamondsProvider!.loadDiamonds();
    _unitsProvider!.scoreById(id: widget.unit.id);
    _quizProvider!.unit = widget.unit;
    // Don't automatically load words to show start screen first
    _quizProvider!.cover(true); // Show the covered card initially
    init();
    WidgetsBinding.instance.addObserver(this);
  }

  void init() async {
    await Provider.of<UnitsProvider>(context, listen: false).fetchScores();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _quizProvider!.resetQuiz();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && !(_quizProvider!.isPaused)) {
      context.read<QuizProvider>().isPaused = true;
      _quizProvider!
          .cover(true, pause: true); // Cover the quiz when app is paused
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                ValueListenableBuilder(
                  valueListenable: provider.isQuizCompleted,
                  builder: (context, isCompleted, child) {
                    return isCompleted
                        ? _buildCompletionScreen(provider)
                        : const SizedBox();
                  },
                ),
                Column(
                  children: [
                    MyCard(
                      alignment: Alignment.topLeft,
                      height: 120.h,
                      child: Column(
                        children: [
                          Text(
                            provider.listWords.isNotEmpty
                                ? provider.sanitizeDefinition(
                                    provider.listWords[provider.questionNumber]
                                        .definition,
                                    provider.correctAnswer)
                                : "Loading...",
                            style: MyTheme().mainTextStyle,
                          ),
                          const Spacer(),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: LinearProgressIndicator(
                                  color: MyColors.themeColors[300],
                                  backgroundColor: MyColors.themeColors[50],
                                  value: provider.progress,
                                  minHeight: 24.h,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: Row(
                                  children: [
                                    HugeIcon(
                                      icon: HugeIcons.strokeRoundedTime02,
                                      color: Colors.black38,
                                      size: 18.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${(provider.duration - (provider.progress * provider.duration)).toInt()}s',
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5),
                        AppBadge(
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedBubbleChatQuestion,
                            color: MyColors.themeColors[300]!,
                          ).icon,
                          text: '${provider.questionNumber + 1} / 20',
                        ),
                        SizedBox(width: 5.h),
                        AppBadge(
                          backgroundColor: Colors.green[50]!,
                          textColor: Colors.green,
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                            color: MyColors.themeColors[300]!,
                          ).icon,
                          text: '${provider.correctCount}',
                        ),
                        SizedBox(width: 5.h),
                        AppBadge(
                          backgroundColor: Colors.red[50]!,
                          textColor: Colors.red,
                          icon: HugeIcon(
                            icon:
                                HugeIcons.strokeRoundedMultiplicationSignCircle,
                            color: MyColors.themeColors[300]!,
                          ).icon,
                          text: '${provider.wrongCount}',
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            await _quizProvider!.useHelp(
                              diamondProvider: _diamondsProvider!,
                              onError: () {
                                SnackBarHelper.show(
                                  context: context,
                                  widget: MySnackBar.create(
                                    content:
                                        "You don't have sufficient diamonds",
                                    label: 'Get some',
                                    onPressed: () {
                                      DialogHelper.show(
                                        context: context,
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return AppDialog(
                                            title: 'Rewarded Ad',
                                            content:
                                                'Watch an ad and get 6 diamonds.',
                                            okayText: 'Watch Ad',
                                            onOkay: () {
                                              context
                                                  .read<RewardAd>()
                                                  .showRewardedAd();
                                            },
                                            onCancel: () => null,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          tooltip: 'Help',
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedIdea,
                            color: MyColors.themeColors[300]!,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            provider.cover(true, pause: true);
                          },
                          tooltip: 'Pause',
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedPause,
                            color: MyColors.themeColors[300]!,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children:
                          List.generate(provider.answerChoices.length, (index) {
                        String choice = provider.answerChoices[index];
                        Color? buttonColor =
                            Theme.of(context).brightness == Brightness.light
                                ? MyColors.themeColors[50]
                                : MyColors.themeColors[50]!.withOpacity(0.1);
                        Widget buttonChild = Text(
                          choice,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: MyColors.themeColors[300],
                          ),
                        );

                        if (provider.selectedAnswer == choice) {
                          if (provider.isAnswered) {
                            if (choice == provider.correctAnswer) {
                              buttonColor = Colors.green;
                            } else {
                              buttonColor = Colors.red;
                            }
                            buttonChild = Text(
                              choice,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                                color: Colors.white,
                              ),
                            );
                          } else {
                            buttonColor = MyColors.themeColors[300];
                            buttonChild = Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  choice,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedArrowRight04,
                                  color: Colors.white,
                                )
                              ],
                            );
                          }
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: EdgeInsets.all(8.sp),
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              if (provider.selectedAnswer == choice &&
                                  !provider.isAnswered) {
                                provider.checkAnswer(choice);
                                if ((provider.correctCount +
                                        provider.wrongCount) ==
                                    20) {
                                  context
                                      .read<DiamondsProvider>()
                                      .updateDiamonds(
                                        correctAnswers: provider.correctCount,
                                      );
                                }
                              } else {
                                TTS.instance.speak(choice);
                                provider.setSelectedAnswer(choice);
                              }
                            },
                            child: buttonChild,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 5.h),
                  ],
                ),
                Visibility(
                  visible: provider.isCovered ? true : false,
                  child: MyCard(
                    isBorderd: false,
                    padding: EdgeInsets.symmetric(
                      vertical: 10.sp,
                      horizontal: MediaQuery.of(context).size.width / 10,
                    ),
                    child: provider.isPaused
                        ? _buildPauseScreen(provider)
                        : provider.isQuizCompleted.value
                            ? _buildCompletionScreen(provider)
                            : _buildStartScreen(provider),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStartScreen(QuizProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Quiz for unit ${widget.unit.unitId}',
          style: MyTheme().mainTextStyle.copyWith(
                fontSize: 22.sp,
                color: MyColors.themeColors[300],
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        if (_unitsProvider!.score != null)
          Column(
            children: [
              Text(
                'Previous Saved Score',
                style: MyTheme().secondaryTextStyle.copyWith(
                      fontSize: 14.sp,
                    ),
              ),
              SizedBox(height: 10.h),
              StarsRate(
                score: _unitsProvider!.score ?? 0,
                size: 40,
              ),
              SizedBox(height: 10.h),
              Text(
                '${_unitsProvider!.score?.toInt() ?? 0}%',
                style: MyTheme().mainTextStyle.copyWith(
                      fontSize: 30.sp,
                      color: MyColors.themeColors[300],
                    ),
              ),
              SizedBox(height: 5.h),
              Text(
                'You answered ${_unitsProvider!.answeredQuestionCount ?? 0} out of 20 questions correctly.',
                textAlign: TextAlign.center,
                style: MyTheme().secondaryTextStyle.copyWith(
                      fontSize: 14.sp,
                    ),
              ),
            ],
          ),
        SizedBox(height: 30.h),
        AppButton(
          text: 'Start Quiz',
          onPressed: () {
            _quizProvider!.loadWords(widget.unit);
            provider.cover(false);
          },
        ),
        AppButton(
          text: 'Back to Home',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildPauseScreen(QuizProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Quiz Paused',
          style: MyTheme().mainTextStyle.copyWith(
                fontSize: 24.sp,
                color: MyColors.themeColors[300],
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        Text(
          'Current Progress',
          style: MyTheme().secondaryTextStyle.copyWith(
                fontSize: 16.sp,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10.h),
        Text(
          'Question ${provider.questionNumber + 1} of 20',
          style: MyTheme().mainTextStyle.copyWith(
                fontSize: 18.sp,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5.h),
        Text(
          'Correct: ${provider.correctCount} | Wrong: ${provider.wrongCount}',
          style: MyTheme().secondaryTextStyle.copyWith(
                fontSize: 16.sp,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30.h),
        AppButton(
          text: 'Resume Quiz',
          onPressed: () {
            provider.cover(false);
          },
        ),
        AppButton(
          text: 'Quit Quiz',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildCompletionScreen(QuizProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StarsRate(
          score: (provider.correctCount / 20) * 100,
          size: 50,
        ),
        SizedBox(height: 30.h),
        MyCard(
          padding: EdgeInsets.all(14.sp),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                '${((provider.correctCount / 20) * 100).toInt()}%',
                style: MyTheme().mainTextStyle.copyWith(
                      fontSize: 40.sp,
                      color: MyColors.themeColors[300],
                    ),
              ),
              SizedBox(height: 10.h),
              Text(
                'You answered ${provider.correctCount} out of 20 questions correctly.',
                textAlign: TextAlign.center,
                style: MyTheme().secondaryTextStyle.copyWith(
                      fontSize: 14.sp,
                    ),
              ),
              SizedBox(height: 30.h),
              Text(
                'Keep studying and try hard',
                style: MyTheme().secondaryTextStyle.copyWith(
                      fontSize: 16.sp,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50.h),
        AppButton(
          text: 'Try Again',
          onPressed: () {
            _quizProvider!.loadWords(widget.unit);
            provider.cover(false);
          },
        ),
        AppButton(
          text: 'Back to Home',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
