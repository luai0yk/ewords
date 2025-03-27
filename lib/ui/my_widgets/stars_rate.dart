import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../theme/my_colors.dart';

class StarsRate extends StatelessWidget {
  final double score;
  final double? size;
  const StarsRate({super.key, required this.score, this.size});

  @override
  Widget build(BuildContext context) {
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
          size: size ?? 20,
        ),
        const SizedBox(width: 3),
        HugeIcon(
          icon: HugeIcons.strokeRoundedStar,
          color: secondStarColor!,
          size: (size ?? 20) + ((size ?? 20) / 4),
        ),
        const SizedBox(width: 3),
        HugeIcon(
          icon: HugeIcons.strokeRoundedStar,
          color: thirdStarColor!,
          size: size ?? 20,
        ),
      ],
    );
  }
}
