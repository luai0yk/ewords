import 'package:ewords/utils/tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../args/passage_args.dart';
import '../../db/quiz_score_helper.dart';
import '../../models/quiz_score_model.dart';
import '../../provider/quiz_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../../utils/helpers/dialog_helper.dart';
import '../dialogs/complete_quiz_dialog.dart';
import '../my_widgets/my_card.dart';

class QuizTab extends StatefulWidget {
  final PassageArgs passageArgs;
  const QuizTab({super.key, required this.passageArgs});

  @override
  State<QuizTab> createState() => _QuizTabState();
}

class _QuizTabState extends State<QuizTab> with WidgetsBindingObserver {
  QuizProvider? _quizProvider;

  @override
  void initState() {
    super.initState();
    _quizProvider = context.read<QuizProvider>();
    _quizProvider!.loadWords(widget.passageArgs);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _quizProvider!.isPaused = true;
    } else if (state == AppLifecycleState.resumed) {
      _quizProvider!.isPaused = false;
    }
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
                    // Store the quiz score when quiz finishes
                    QuizScoreHelper.instance.insertQuizScore(
                      QuizScoreModel(
                        unitId: int.parse(widget.passageArgs.unitId),
                        bookId: int.parse(widget.passageArgs.bookId),
                        correctAnswers: provider.correctCount,
                      ),
                    );

                    DialogHelper.show(
                      context: context,
                      isDismissible: false,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return CompleteQuizDialog(
                          onRestart: () {
                            provider.isQuizCompleted.value = false;
                            provider.loadWords(widget.passageArgs);
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
                      alignment: Alignment.center,
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
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  color: MyColors.themeColors[300],
                                  backgroundColor: MyColors.themeColors[100],
                                  value: provider.progress,
                                  minHeight: 15,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: MyTheme().mainTextStyle,
                                  children: [
                                    TextSpan(
                                        text:
                                            "  ${(provider.duration - (provider.progress * provider.duration)).toInt()} / "),
                                    TextSpan(
                                      text: "${provider.duration}",
                                      style: TextStyle(
                                          color: MyColors.themeColors[300]),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: MyTheme().mainTextStyle,
                            children: [
                              TextSpan(
                                text: 'Q: ',
                                style: TextStyle(
                                  color: MyColors.themeColors[300],
                                ),
                              ),
                              TextSpan(
                                text: ' ${provider.questionNumber + 1}',
                                style: MyTheme()
                                    .secondaryTextStyle
                                    .copyWith(fontSize: 16.sp),
                              ),
                              TextSpan(
                                text: ' /',
                                style: MyTheme()
                                    .secondaryTextStyle
                                    .copyWith(fontSize: 16.sp),
                              ),
                              TextSpan(
                                text: ' 20',
                                style: TextStyle(
                                  color: MyColors.themeColors[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: MyTheme().mainTextStyle,
                            children: [
                              const TextSpan(
                                text: 'C: ',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              TextSpan(
                                text: '${provider.correctCount}',
                                style: MyTheme()
                                    .secondaryTextStyle
                                    .copyWith(fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: MyTheme().mainTextStyle,
                            children: [
                              const TextSpan(
                                text: 'W: ',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              TextSpan(
                                text: '${provider.wrongCount}',
                                style: MyTheme()
                                    .secondaryTextStyle
                                    .copyWith(fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 24.sp,
                                ),
                              ],
                            );
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.all(8),
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
                    const SizedBox(height: 10),
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
