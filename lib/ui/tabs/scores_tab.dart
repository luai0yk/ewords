import 'package:ewords/db/quiz_score_helper.dart';
import 'package:ewords/models/quiz_score_model.dart';
import 'package:ewords/ui/my_widgets/quiz_score_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hidable/hidable.dart';

import '../../theme/my_colors.dart';

class ScoresTab extends StatefulWidget {
  final ScrollController scrollController;
  const ScoresTab({super.key, required this.scrollController});

  @override
  State<ScoresTab> createState() => _ScoresTabState();
}

class _ScoresTabState extends State<ScoresTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Hidable(
        deltaFactor: 0.06,
        preferredWidgetSize: Size.fromHeight(75.sp),
        controller: widget.scrollController,
        child: AppBar(
          title: Text('quiz scores'.toUpperCase()), // Title of the app bar
          titleTextStyle: TextStyle(
            color: MyColors.themeColors[300],
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: FutureBuilder<List<QuizScoreModel>>(
        future: QuizScoreHelper.instance.getQuizScores(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(strokeWidth: 10));
          }
          // Handle error state
          else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Sorry, something went wrong!',
                style: TextStyle(
                  color: MyColors.themeColors[300],
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          // Handle empty favorites
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No scores yet!',
                style: TextStyle(
                  color: MyColors.themeColors[300],
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              QuizScoreModel quizScore = snapshot.data![index];
              return QuizScoreCard(quizScore: quizScore);
            },
          );
        },
      ),
    );
  }
}
