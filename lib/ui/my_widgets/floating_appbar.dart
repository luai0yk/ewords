import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../provider/diamonds_provider.dart';
import '../../provider/units_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../../utils/helpers/dialog_helper.dart';
import '../../utils/helpers/snackbar_helper.dart';
import '../../utils/recent_unit.dart';
import '../dialogs/app_dialog.dart';
import '../my_widgets/my_card.dart';
import '../my_widgets/my_snackbar.dart';
import '../pages/dictionary_page.dart';
import '../pages/unit_content_page.dart';

class FloatingAppBar extends StatelessWidget {
  final Function showRewardedAd;

  const FloatingAppBar({super.key, required this.showRewardedAd});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                DialogHelper.show(
                  context: context,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return AppDialog(
                      title: 'Rewarded Ad',
                      content: 'Watch an ad and get 5 diamonds.',
                      okayText: 'Watch Ad',
                      onOkay: () {
                        showRewardedAd();
                      },
                      onCancel: () => null,
                    );
                  },
                );
              },
              tooltip: 'Diamonds',
              icon: Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedDiamond02,
                    color: MyColors.themeColors[300]!,
                  ),
                  const SizedBox(width: 2),
                  Selector<DiamondsProvider, int>(
                    builder: (context, diamonds, child) {
                      return Text(
                        '$diamonds',
                        style: MyTheme().mainTextStyle.copyWith(
                              color: MyColors.themeColors[300],
                            ),
                      );
                    },
                    selector: (ctx, provider) => provider.diamonds,
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
}
