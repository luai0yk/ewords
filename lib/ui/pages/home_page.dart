import 'package:ewords/ui/tabs/home_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hidable/hidable.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/gnav_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../tabs/favorite_tab.dart';
import '../tabs/scores_tab.dart';
import '../tabs/settings_tab.dart';

// Global variables to hold word list and pages
//List<WordModel>? wordList;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? pageController; // Controller for the PageView
  final ScrollController scrollController =
      ScrollController(); // Controller for scrolling
  SharedPreferences? prefs; // Instance of SharedPreferences
  List<Widget>? pages;

  @override
  void initState() {
    super.initState();

    // Initialize the list of pages
    pages = [
      // BookListPage(scrollController: scrollController),
      const HomeTab(),
      FavoriteTab(scrollController: scrollController),
      ScoresTab(scrollController: scrollController),
      const SettingsPage(),
    ];
    pageController = PageController(); // Initialize PageController
    init(); // Call init function to load preferences
  }

  // Initialize SharedPreferences
  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    pageController?.dispose();
    scrollController.dispose();
    super.dispose();
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
                  ? Colors.white12 // Color for dark mode
                  : Colors.black12, // Color for light mode
              width: 1,
            ),
          ),
        ),
        child: Selector<GNavProvider, int>(
            builder: (context, selectedTab, child) {
              return Hidable(
                deltaFactor: 0.06, // Factor for hiding the navigation bar
                controller: scrollController,
                preferredWidgetSize:
                    Size.fromHeight(65.sp), // Height for the navigation bar
                child: GNav(
                  padding: EdgeInsets.all(15.sp), // Padding for the tabs
                  tabMargin: EdgeInsets.all(8.sp), // Margin between tabs
                  activeColor: Colors.white, // Color for active tab text
                  tabBackgroundColor: MyColors
                      .themeColors[300]!, // Background color for active tab
                  tabBorderRadius: 15.sp, // Border radius for tabs
                  duration: const Duration(
                      milliseconds: 200), // Duration for animation
                  curve: Curves.easeIn, // Animation curve
                  gap: 4.sp, // Gap between icons and text
                  selectedIndex: selectedTab, // Currently selected tab index
                  iconSize: 22.sp, // Size of the icons
                  textStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  onTabChange: (value) {
                    MyTheme.initialize(context);
                    selectedTab = value; // Update selected tab index
                    pageController!
                        .jumpToPage(selectedTab); // Change the page in PageView
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
                ),
              );
            },
            selector: (context, value) => value.selectedTab),
      ),
      body: PageView(
        onPageChanged: (value) {
          // Update selected tab index when page changes,
          context.read<GNavProvider>().updateSelectedTab(value);
        },
        controller: pageController, // Controller for the PageView
        children: pages!, // List of pages
      ),
    );
  }
}
