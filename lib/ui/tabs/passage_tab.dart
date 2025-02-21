import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../provider/tts_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';

class PassageTab extends StatelessWidget {
  final String passage;
  final ScrollController scrollController;
  const PassageTab({
    super.key,
    required this.passage,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(15.sp),
        child: Selector<TTSProvider, Map<String, int>>(
          selector: (context, provider) {
            return provider.currentWordStartEnd;
          },
          builder: (context, currentWordStartEnd, child) {
            return RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    style: MyTheme().secondaryTextStyle.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                    text: passage.substring(0, currentWordStartEnd['start']),
                  ),
                  currentWordStartEnd['start'] != null
                      ? TextSpan(
                          text: passage.substring(currentWordStartEnd['start']!,
                              currentWordStartEnd['end']!),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: MyColors.themeColors[300],
                                backgroundColor: MyColors.themeColors[50],
                              ),
                        )
                      : const TextSpan(text: ''),
                  currentWordStartEnd['end'] != null
                      ? TextSpan(
                          text: passage.substring(currentWordStartEnd['end']!),
                          style: MyTheme().secondaryTextStyle.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        )
                      : const TextSpan(text: ''),
                ],
              ),
            );
          },
        ),
      ),
    ));
  }
}
