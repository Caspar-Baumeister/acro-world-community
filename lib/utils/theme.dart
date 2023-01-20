import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

enum MyThemeKeys { LIGHT, DARK }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    indicatorColor: PRIMARY_COLOR,
    dividerColor: Colors.grey,
    dividerTheme: const DividerThemeData(color: Colors.grey),
    scaffoldBackgroundColor: Colors.white,
    tabBarTheme: const TabBarTheme(
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: PRIMARY_COLOR,
            width: 2.0,
          ),
        ),
      ),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 22.5, fontWeight: FontWeight.bold),
      headline3: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      headline4: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      actionsIconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18.0),
    ),

    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: PRIMARY_COLOR),
    primaryColor: PRIMARY_COLOR,
    // appBarTheme: const AppBarTheme(
    //   color: APPBAR_COLOR,
    // ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: NOT_ACTIVE_COLOR,
      cursorColor: PRIMARY_COLOR,
      selectionHandleColor: PRIMARY_COLOR,
    ),
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    highlightColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
  );

  // maybe for outdoor
  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey,
    brightness: Brightness.dark,
    highlightColor: Colors.white,
    backgroundColor: Colors.black54,
    textSelectionTheme:
        const TextSelectionThemeData(selectionColor: Colors.grey),
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}
