import 'package:ewords/db/unit_helper.dart';
import 'package:ewords/models/unit_model.dart';
import 'package:ewords/provider/quiz_provider.dart';
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
import '../my_widgets/my_snackbar.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  SharedPreferences? prefs;
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        scrollToActiveUnit();
      },
    );
  }

  void scrollToActiveUnit() {
    if (prefs != null) {
      int? currentActiveUnit = prefs!.getInt('current_active_unit');
      if (currentActiveUnit != null) {
        int index = currentActiveUnit - 1;
        GlobalKey? key = _itemKeys[index];
        if (key != null) {
          Scrollable.ensureVisible(
            key.currentContext!,
            // duration: Duration(seconds: 1),
            // curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UnitModel>>(
        future: UnitHelper.instance.getUnits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text(
                'Loading..',
                style: TextStyle(
                  color: MyColors.themeColors[300],
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (snapshot.hasError) {
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
          } else {
            return Stack(
              children: [
                AnimatedList(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.22,
                  ),
                  reverse: true,
                  initialItemCount: snapshot.data!.length,
                  itemBuilder: (context, index, animation) {
                    CrossAxisAlignment alignment;
                    UnitModel unit = snapshot.data![index];

                    GlobalKey key = GlobalKey();
                    _itemKeys[index] = key;

                    context.read<QuizProvider>().checkPassedUnits(
                          id: unit.id,
                          bookId: unit.bookId,
                          unitId: unit.unitId,
                        );

                    int? currentActiveUnit =
                        prefs!.getInt('current_active_unit') ?? 1;

                    switch (index % 4) {
                      case 0:
                        alignment = CrossAxisAlignment.start;
                        break;
                      case 1:
                        alignment = CrossAxisAlignment.center;
                        break;
                      case 2:
                        alignment = CrossAxisAlignment.end;
                        break;
                      case 3:
                        alignment = CrossAxisAlignment.center;
                        break;
                      default:
                        alignment = CrossAxisAlignment.start;
                    }
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0, end: 1).animate(
                        CurvedAnimation(
                            parent: animation, curve: Curves.easeOutBack),
                      ),
                      child: Selector<QuizProvider, bool>(
                        selector: (context, provider) {
                          return provider.isPassed(unit.id);
                        },
                        builder: (context, isPassed, child) {
                          return Column(
                            key: key,
                            crossAxisAlignment: alignment,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (isPassed ||
                                      currentActiveUnit == unit.id) {
                                    MyTheme.initialize(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UnitContentPage(),
                                        settings: RouteSettings(
                                          arguments: snapshot.data![index],
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 85.r,
                                      width: 85.r,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      decoration: isPassed ||
                                              currentActiveUnit == unit.id
                                          ? BoxDecoration(
                                              color: MyColors.themeColors[300],
                                              borderRadius:
                                                  BorderRadius.circular(90),
                                              border: Border.all(
                                                color:
                                                    MyColors.themeColors[50]!,
                                                width: 5,
                                              ),
                                            )
                                          : BoxDecoration(
                                              color: MyColors.themeColors[100],
                                              borderRadius:
                                                  BorderRadius.circular(90),
                                              border: Border.all(
                                                color:
                                                    MyColors.themeColors[50]!,
                                                width: 5,
                                              ),
                                            ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: isPassed ||
                                                  currentActiveUnit == unit.id
                                              ? Colors.white
                                              : Colors.black38,
                                          fontSize: 35.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top * 2,
                    left: MediaQuery.of(context).padding.top,
                    right: MediaQuery.of(context).padding.top,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const DictionaryPage();
                                },
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: MyColors.themeColors[300],
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
                                    builder: (context) =>
                                        const UnitContentPage(),
                                    settings: RouteSettings(
                                      arguments: snapshot.data![index],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.last_page_rounded,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: MyColors.themeColors[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
