import 'package:ewords/ui/tabs/home_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hidable/hidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/word_model.dart';
import '../../provider/gnav_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../tabs/favorite_tab.dart';
import '../tabs/scores_tab.dart';
import '../tabs/settings_tab.dart';

// Global variables to hold word list and pages
List<WordModel>? wordList;
List<Widget>? pages;

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

  @override
  void initState() {
    super.initState();

    // Initialize the list of pages
    pages = [
      // BookListPage(scrollController: scrollController),
      const HomeTab(),
      FavoriteListPage(scrollController: scrollController),
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
                      icon: Icons.home_rounded,
                      text: 'home'.toUpperCase(), // Text for the first tab
                    ),
                    GButton(
                      icon: Icons.favorite_rounded,
                      text: 'favorite'.toUpperCase(), // Text for the second tab
                    ),
                    GButton(
                      icon: Icons.score_rounded,
                      text: 'scores'.toUpperCase(), // Text for the third tab
                    ),
                    GButton(
                      icon: Icons.settings_rounded,
                      text: 'settings'.toUpperCase(), // Text for the fourth tab
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
