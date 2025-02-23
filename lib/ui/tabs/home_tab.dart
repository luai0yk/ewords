import 'package:ewords/models/unit_model.dart';
import 'package:ewords/provider/quiz_provider.dart';
import 'package:ewords/provider/units_provider.dart';
import 'package:ewords/theme/my_colors.dart';
import 'package:ewords/theme/my_theme.dart';
import 'package:ewords/ui/pages/dictionary_page.dart';
import 'package:ewords/ui/pages/unit_content_page.dart';
import 'package:ewords/utils/recent_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/helpers/snackbar_helper.dart';
import '../my_widgets/my_card.dart';
import '../my_widgets/my_snackbar.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  SharedPreferences? prefs;
  int? currentActiveUnit;
  final ScrollController _scrollController = ScrollController();

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    currentActiveUnit = prefs!.getInt('current_active_unit') ?? 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Selector<UnitsProvider, List<UnitModel>?>(
            selector: (context, provider) {
              return provider.units;
            },
            builder: (context, units, child) {
              if (units == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.22,
                ),
                reverse: true,
                itemCount: units.length,
                itemBuilder: (context, index) {
                  return _buildListItem(index, units);
                },
              );
            },
          ),
          _buildFloatingButtons(),
        ],
      ),
    );
  }

  Widget _buildListItem(int index, List<UnitModel> units) {
    final UnitModel unit = units[index];
    Alignment alignment = _getAlignment(index);

    context.read<QuizProvider>().checkPassedUnits(
          id: unit.id,
          bookId: unit.bookId,
          unitId: unit.unitId,
        );

    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        bool isPassed = provider.isPassed(unit.id);

        return Container(
          alignment: alignment,
          child: SizedBox(
            width: 85.w,
            height: 120.h,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isPassed || currentActiveUnit == unit.id) {
                      MyTheme.initialize(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UnitContentPage(),
                          settings: RouteSettings(arguments: unit),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 85.r,
                    width: 85.r,
                    decoration: isPassed || currentActiveUnit == unit.id
                        ? BoxDecoration(
                            color: MyColors.themeColors[300],
                            borderRadius: BorderRadius.circular(90),
                            border: Border.all(
                              color: MyColors.themeColors[50]!,
                              width: 5,
                            ),
                          )
                        : BoxDecoration(
                            color: MyColors.themeColors[50],
                            borderRadius: BorderRadius.circular(90),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface,
                              width: 5,
                            ),
                          ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isPassed || currentActiveUnit == unit.id
                            ? Colors.white
                            : Colors.black38,
                        fontSize: 35.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingButtons() {
    return MyCard(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: MediaQuery.of(context).padding.top / 2,
        right: MediaQuery.of(context).padding.top / 2,
      ),
      padding: EdgeInsets.all(4.sp),
      width: double.infinity,
      height: 50.h,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Text(
              'eWords',
              style: MyTheme().mainTextStyle.copyWith(
                    color: MyColors.themeColors[300],
                  ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DictionaryPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.search_rounded,
                color: MyColors.themeColors[300],
              ),
            ),
            IconButton(
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
              icon: Icon(
                Icons.quiz_rounded,
                color: MyColors.themeColors[300],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Alignment _getAlignment(int index) {
    switch (index % 4) {
      case 0:
        return Alignment.topLeft;
      case 1:
        return Alignment.center;
      case 2:
        return Alignment.topRight;
      case 3:
        return Alignment.center;
      default:
        return Alignment.topLeft;
    }
  }
}
