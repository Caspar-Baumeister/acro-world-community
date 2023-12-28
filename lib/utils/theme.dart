import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

enum MyThemeKeys { light, dark }

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
      bottomSheetTheme: const BottomSheetThemeData(
        modalBackgroundColor: BACKGROUND_COLOR,
        surfaceTintColor: BACKGROUND_COLOR,
        backgroundColor: BACKGROUND_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
      ),
      // set modal background color
      dialogTheme: const DialogTheme(
        backgroundColor: BACKGROUND_COLOR,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: BACKGROUND_COLOR,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 22.5, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: BACKGROUND_COLOR,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: BACKGROUND_COLOR,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18.0),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: PRIMARY_COLOR),
      primaryColor: PRIMARY_COLOR,
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: NOT_ACTIVE_COLOR,
        cursorColor: PRIMARY_COLOR,
        selectionHandleColor: PRIMARY_COLOR,
      ),
      brightness: Brightness.light,
      highlightColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: BACKGROUND_COLOR,
        background: Colors.white,
      ));

  // maybe for outdoor
  static final ThemeData darkTheme = ThemeData();

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.light:
        return lightTheme;
      case MyThemeKeys.dark:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}
