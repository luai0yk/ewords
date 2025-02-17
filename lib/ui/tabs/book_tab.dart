import 'package:ewords/ui/pages/dictionary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../../utils/constants.dart';
import '../../utils/helpers/snackbar_helper.dart';
import '../../utils/recent_tab.dart';
import '../my_widgets/my_card.dart';
import '../my_widgets/my_snackbar.dart';
import '../pages/units_page.dart';

class BookListPage extends StatelessWidget {
  final ScrollController scrollController;

  const BookListPage({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    MyTheme.initialize(context);
    return Scaffold(
      // SingleChildScrollView to handle scrolling of other widgets
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 12,
            top: (MediaQuery.of(context).padding.top + 12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Recent Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        RecentTab.loadRecentTap(
                          context: context,
                          onError: (msg) {
                            SnackBarHelper.show(
                              context: context,
                              widget: MySnackBar.create(content: msg),
                            );
                          },
                        );
                        MyTheme.initialize(context);
                      },
                      child: MyCard(
                        child: Text(
                          textAlign: TextAlign.center,
                          'recent'.toUpperCase(),
                          style: TextStyle(
                            color: MyColors.themeColors[300],
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Dictionary Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DictionaryPage(),
                          ),
                        );
                      },
                      child: MyCard(
                        child: Text(
                          textAlign: TextAlign.center,
                          'dictionary'.toUpperCase(),
                          style: TextStyle(
                            color: MyColors.themeColors[300],
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              // GridView to display books
              GridView.builder(
                itemCount: 6, // Number of book items
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns in the grid
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.88,
                ),
                shrinkWrap:
                    true, // Allow GridView to take only necessary height
                physics:
                    const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to UnitListPage when a book is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UnitsPage(
                            bookId: (index + 1), // Pass book index
                          ),
                        ),
                      );
                    },
                    child: MyCard(
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Stack(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 90.r,
                                            height: 60.r,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: MyColors.themeColors[300]!
                                                  .withOpacity(0.1),
                                            ),
                                          ),
                                          Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              fontSize: 95.sp,
                                              color: MyColors.themeColors[300],
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: MyColors.themeColors[300]!
                                        .withOpacity(0.1),
                                  ),
                                  child: Text(
                                    MyConstants.levels[index],
                                    style: TextStyle(
                                      color: MyColors.themeColors[300],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            MyConstants.bookDescription[index],
                            style: MyTheme().secondaryTextStyle,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
