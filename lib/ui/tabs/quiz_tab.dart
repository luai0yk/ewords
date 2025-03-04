import 'package:ewords/models/unit_model.dart';
import 'package:ewords/utils/tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../models/quiz_score_model.dart';
import '../../provider/diamonds_provider.dart';
import '../../provider/quiz_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../../utils/helpers/dialog_helper.dart';
import '../dialogs/complete_quiz_dialog.dart';
import '../dialogs/pasue_resume_dialog.dart';
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
  QuizProvider? _quizProvider;

  @override
  void initState() {
    super.initState();
    _quizProvider = context.read<QuizProvider>();
    _quizProvider!.loadWords(widget.unit);

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && !(_quizProvider!.isPaused)) {
      context.read<QuizProvider>().isPaused = true;
      DialogHelper.show(
        context: context,
        isDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return PauseResumeDialog(tabController: widget.tabController);
        },
      );
    } else if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          return ValueListenableBuilder<bool>(
            valueListenable: provider.isQuizCompleted,
            builder: (context, isQuizCompleted, child) {
              if (isQuizCompleted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (ModalRoute.of(context)?.isCurrent ?? false) {
                    provider.insertOrUpdateQuizScore(
                      score: QuizScoreModel(
                        id: widget.unit.id,
                        unitId: widget.unit.unitId,
                        bookId: widget.unit.bookId,
                        correctAnswers: provider.correctCount,
                      ),
                    );

                    context.read<DiamondsProvider>().updateDiamonds(
                          correctAnswers: provider.correctCount,
                        );

                    DialogHelper.show(
                      context: context,
                      isDismissible: false,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return CompleteQuizDialog(
                          tabController: widget.tabController,
                          onRestart: () {
                            provider.isQuizCompleted.value = false;
                            provider.loadWords(widget.unit);
                          },
                        );
                      },
                    );
                  }
                });
              }

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
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
                          const SizedBox(height: 20),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              LinearProgressIndicator(
                                color: MyColors.themeColors[300],
                                backgroundColor: MyColors.themeColors[50],
                                value: provider.progress,
                                minHeight: 20.h,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              Text(
                                ' ${(provider.duration - (provider.progress * provider.duration)).toInt()} / ${provider.duration}',
                                style: const TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
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
                        Container(
                          decoration: BoxDecoration(
                            color: MyColors.themeColors[50],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '${provider.questionNumber + 1} / 20',
                            style: TextStyle(
                              color: MyColors.themeColors[300],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 5.h),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'C: ${provider.correctCount}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 5.h),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'W: ${provider.wrongCount}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            DialogHelper.show(
                              context: context,
                              isDismissible: false,
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return PauseResumeDialog(
                                  tabController: widget.tabController,
                                );
                              },
                            );
                          },
                          icon: HugeIcon(
                            icon: _quizProvider!.isPaused
                                ? HugeIcons.strokeRoundedPlay
                                : HugeIcons.strokeRoundedPause,
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
              );
            },
          );
        },
      ),
    );
  }
}
