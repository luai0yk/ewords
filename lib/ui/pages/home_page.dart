import 'package:ewords/ui/tabs/home_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/gnav_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../tabs/favorite_tab.dart';
import '../tabs/scores_tab.dart';
import '../tabs/settings_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? pageController;
  SharedPreferences? prefs;
  List<Widget>? pages;

  @override
  void initState() {
    super.initState();

    pages = [
      const HomeTab(),
      const FavoriteTab(),
      const ScoresTab(),
      const SettingsPage(),
    ];
    pageController = PageController();
    init();
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.initialize(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white12
                  : Colors.black12,
              width: 1,
            ),
          ),
        ),
        child: Selector<GNavProvider, int>(
            builder: (context, selectedTab, child) {
              return GNav(
                padding: EdgeInsets.all(15.sp),
                tabMargin: EdgeInsets.all(8.sp),
                activeColor: Colors.white,
                tabBackgroundColor: MyColors.themeColors[300]!,
                tabBorderRadius: 15.sp,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                gap: 4.sp,
                selectedIndex: selectedTab,
                iconSize: 22.sp,
                textStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                onTabChange: (value) {
                  MyTheme.initialize(context);
                  selectedTab = value;
                  pageController!.jumpToPage(selectedTab);
                },
                tabs: [
                  GButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedHome05,
                      color: MyColors.themeColors[300]!,
                    ).icon,
                    text: 'home'.toUpperCase(),
                  ),
                  GButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedFavourite,
                      color: MyColors.themeColors[300]!,
                    ).icon,
                    text: 'favorite'.toUpperCase(),
                  ),
                  GButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedPercent,
                      color: MyColors.themeColors[300]!,
                    ).icon,
                    text: 'scores'.toUpperCase(),
                  ),
                  GButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedSettings01,
                      color: MyColors.themeColors[300]!,
                    ).icon,
                    text: 'settings'.toUpperCase(),
                  ),
                ],
              );
            },
            selector: (context, value) => value.selectedTab),
      ),
      body: PageView(
        onPageChanged: (value) {
          context.read<GNavProvider>().updateSelectedTab(value);
        },
        controller: pageController,
        children: pages!,
      ),
    );
  }
}
