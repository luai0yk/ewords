import 'package:flutter/material.dart';

import '../../theme/my_colors.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.quiz,
          size: 50,
          color: MyColors.themeColors[300],
        ),
      ),
    );
  }
}
