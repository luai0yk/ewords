import 'package:ewords/args/passage_args.dart';
import 'package:ewords/db/passage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hidable/hidable.dart';

import '../../models/passage_model.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../../ui/pages/unit_content_page.dart';
import '../../utils/constants.dart';
import '../my_widgets/my_list_tile.dart';

class UnitsPage extends StatelessWidget {
  final int bookId; // Identifier for the book

  final ScrollController scrollController =
      ScrollController(); // Controller for scrolling

  UnitsPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    MyTheme.initialize(context);
    print("Theme Mode : ${Theme.of(context).brightness == Brightness.dark}");
    return Scaffold(
      appBar: Hidable(
        preferredWidgetSize: Size.fromHeight(75.sp),
        controller: scrollController,
        deltaFactor: 0.06,
        child: AppBar(
          title: Text('${MyConstants.levels[(bookId - 1)]} Book'),
          titleTextStyle: MyTheme().appBarTitleStyle,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<PassageModel>>(
          future: PassageHelper.instance.getPassages(bookId: bookId),
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
            // Handle empty data
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Sorry, no data available!',
                  style: TextStyle(
                    color: MyColors.themeColors[300],
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            List<PassageModel> passageList = snapshot.data!;

            return ListView.builder(
              controller: scrollController,
              itemCount: passageList.length, // Count of readings
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return MyListTile(
                  onTap: () {
                    // Navigate to the UnitViewPage with the selected unit's details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UnitContentPage(),
                        settings: RouteSettings(
                          arguments: PassageArgs(
                              unitId: passageList[index].unitId,
                              bookId: passageList[index].bookId,
                              passageTitle: passageList[index].passageTitle,
                              passage: passageList[index].passage),
                        ),
                      ),
                    );
                  },
                  isLeadingVisible: true,
                  leadingText: (index + 1).toString(),
                  leadingTextSize: 32.sp,
                  title: passageList[index].passageTitle,
                  text: passageList[index].passage,
                  textMaxLines: 2, // Limit text to 2 lines
                  isThreeLines: false,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
