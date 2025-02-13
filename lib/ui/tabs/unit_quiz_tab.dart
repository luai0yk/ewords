import 'package:ewords/args/passage_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../provider/quiz_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../../utils/helpers/dialog_helper.dart';
import '../dialogs/complete_quiz_dialog.dart';
import '../my_widgets/my_card.dart';

class UnitQuizTab extends StatelessWidget {
  final PassageArgs passageArgs;

  const UnitQuizTab({super.key, required this.passageArgs});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizProvider()..loadWords(passageArgs),
      child: Scaffold(
        body: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            return ValueListenableBuilder<bool>(
              valueListenable: provider.isQuizCompleted,
              builder: (context, isQuizCompleted, child) {
                if (isQuizCompleted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (ModalRoute.of(context)?.isCurrent ?? false) {
                      DialogHelper.show(
                        context: context,
                        isDismissible: false,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return CompleteQuizDialog(
                            onRestart: () {
                              provider.isQuizCompleted.value = false;
                              provider.loadWords(passageArgs);
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
                                      provider
                                          .listWords[provider.questionNumber]
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
                                    minHeight: 20,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: MyTheme().mainTextStyle,
                                    children: [
                                      TextSpan(
                                          text:
                                              "  ${(20 - (provider.progress * 20)).toInt()} / "),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Q: ${provider.questionNumber + 1} / ${provider.listWords.length}",
                            style: MyTheme().mainTextStyle.copyWith(
                                  color: MyColors.themeColors[300],
                                ),
                          ),
                          Text(
                            "C: ${provider.correctCount}",
                            style: MyTheme().mainTextStyle.copyWith(
                                  color: Colors.green,
                                ),
                          ),
                          Text(
                            "W: ${provider.wrongCount}",
                            style: MyTheme().mainTextStyle.copyWith(
                                  color: Colors.red,
                                ),
                          ),
                          IconButton(
                            onPressed: provider.togglePauseResume,
                            icon: Icon(
                              provider.isPaused
                                  ? Icons.play_arrow_rounded
                                  : Icons.pause_rounded,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(provider.answerChoices.length,
                            (index) {
                          String choice = provider.answerChoices[index];
                          Color? buttonColor = MyColors.themeColors[300];

                          if (provider.isAnswered) {
                            if (choice == provider.correctAnswer) {
                              buttonColor = Colors.green;
                            } else if (choice == provider.selectedAnswer) {
                              buttonColor = Colors.red;
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () => provider.checkAnswer(choice),
                              child: Text(
                                choice,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
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
      ),
    );
  }
}
