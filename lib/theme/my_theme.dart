import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'my_colors.dart';

class MyTheme {
  static BuildContext? _context;

  static MyTheme? _myTheme;

  static MyTheme initialize(BuildContext context) {
    _context = context;
    _myTheme ??= MyTheme._internal();
    return _myTheme!;
  }

  factory MyTheme() {
    return _myTheme!;
  }

  MyTheme._internal();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
    ).copyWith(
      // onSurface: const Color.fromARGB(255, 250, 250, 250),
      onSurface: Colors.white,
      surface: const Color.fromARGB(255, 255, 255, 255),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: MyColors.themeColors[600],
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: const TextStyle(
        color: Colors.white,
      ),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MyColors.themeColors[300],
      ),
      unselectedLabelStyle: const TextStyle(
        color: Colors.black12,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black12),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: MyColors.themeColors[100],
      circularTrackColor: MyColors.themeColors[300],
    ),
    /*This theme affects the selected text and its handler whether TextField or SelectableText*/
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: MyColors.themeColors[200],
      selectionHandleColor: MyColors.themeColors[300],
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(
        color: Colors.black26,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.black12,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    dialogBackgroundColor: Colors.white,
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
    ).copyWith(
      onSurface: const Color.fromARGB(255, 29, 27, 32),
      surface: const Color.fromARGB(255, 20, 18, 24),
    ),
    useMaterial3: true,
    iconTheme: const IconThemeData(color: Colors.white12),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(
        color: MyColors.themeColors[600],
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: const TextStyle(
        color: Colors.white,
      ),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MyColors.themeColors[300],
      ),
      unselectedLabelStyle: const TextStyle(
        color: Colors.white12,
      ),
    ),
    /*This theme affects the selected text and its handler whether TextField or SelectableText*/
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: MyColors.themeColors[200],
      selectionHandleColor: MyColors.themeColors[300],
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(
        color: Colors.white12,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.white12,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: MyColors.themeColors[100],
      circularTrackColor: MyColors.themeColors[300],
    ),
    snackBarTheme: const SnackBarThemeData(backgroundColor: Colors.white),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromARGB(255, 20, 18, 24),
    ),
  );

  //This style affects the general title of a setting section
  TextStyle get headSettingStyle {
    return TextStyle(
      fontSize: 12.sp,
      color: Theme.of(_context!).brightness == Brightness.dark
          ? Colors.white38
          : Colors.black38,
    );
  }

  TextStyle get mainTextStyle {
    return TextStyle(
      color: Theme.of(_context!).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get secondaryTextStyle {
    return TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.bold,
      color: Theme.of(_context!).brightness == Brightness.dark
          ? Colors.white60
          : Colors.black54,
    );
  }

  TextStyle get thirdTextStyle {
    return TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.bold,
      color: Theme.of(_context!).brightness == Brightness.dark
          ? Colors.white30
          : Colors.black38,
    );
  }

  TextStyle get appBarTitleStyle {
    return TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: MyColors.themeColors[300]);
  }
}
