import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/text_constants.dart';
import 'package:flutter/material.dart';

enum MyThemeKeys { light, dark }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
      textTheme: TextTheme(
        displayLarge: displayLargeTextStyle(CustomColors.primaryTextColor),
        displayMedium: displayMediumTextStyle(CustomColors.primaryTextColor),
        displaySmall: displaySmallTextStyle(CustomColors.primaryTextColor),
        headlineMedium: headlineMediumTextStyle(CustomColors.primaryTextColor),
        headlineSmall: headlineSmallTextStyle(CustomColors.primaryTextColor),
        titleLarge: titleLargeTextStyle(CustomColors.primaryTextColor),
        titleMedium: titleMediumTextStyle(CustomColors.primaryTextColor),
        titleSmall: titleSmallTextStyle(CustomColors.primaryTextColor),
        bodyLarge: bodyLargeTextStyle(CustomColors.primaryTextColor),
        bodyMedium: bodyMediumTextStyle(CustomColors.primaryTextColor),
        labelLarge: labelLargeTextStyle(CustomColors.primaryTextColor),
        bodySmall: bodySmallTextStyle(CustomColors.primaryTextColor),
        labelSmall: labelSmallTextStyle(CustomColors.primaryTextColor),
      ),
      indicatorColor: CustomColors.primaryColor,
      dividerColor: CustomColors.inactiveBorderColor,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CustomColors.backgroundColor,
        selectedItemColor: CustomColors.primaryTextColor,
        unselectedItemColor: CustomColors.secondaryTextColor,
        selectedIconTheme: IconThemeData(color: CustomColors.primaryTextColor),
        unselectedIconTheme:
            IconThemeData(color: CustomColors.secondaryTextColor),
      ),
      dividerTheme:
          const DividerThemeData(color: CustomColors.inactiveBorderColor),
      scaffoldBackgroundColor: CustomColors.backgroundColor,
      tabBarTheme: const TabBarThemeData(
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CustomColors.primaryColor,
              width: 2.0,
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: CustomColors.errorBorderColor, width: 1.0),
          borderRadius: AppBorders.defaultRadius,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: CustomColors.errorBorderColor, width: 1.0),
          borderRadius: AppBorders.defaultRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: CustomColors.activeBorderColor, width: 1.0),
          borderRadius: AppBorders.defaultRadius,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 1.0, color: CustomColors.inactiveBorderColor),
          borderRadius: AppBorders.defaultRadius,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        modalBackgroundColor: CustomColors.backgroundColor,
        surfaceTintColor: CustomColors.backgroundColor,
        backgroundColor: CustomColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
      ),
      // set modal background color
      dialogTheme: const DialogThemeData(
        backgroundColor: CustomColors.backgroundColor,
      ),
      drawerTheme: const DrawerThemeData(
          backgroundColor: CustomColors.backgroundColor,
          surfaceTintColor: CustomColors.backgroundColor),
      appBarTheme: AppBarTheme(
        backgroundColor: CustomColors.backgroundColor,
        iconTheme: const IconThemeData(color: CustomColors.iconColor),
        actionsIconTheme: const IconThemeData(color: CustomColors.iconColor),
        centerTitle: true,
        foregroundColor: CustomColors.backgroundColor,
        elevation: 0,
        surfaceTintColor: CustomColors.backgroundColor,
        titleTextStyle: headlineSmallTextStyle(CustomColors.primaryTextColor),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: CustomColors.primaryColor),
      primaryColor: CustomColors.primaryColor,
      textSelectionTheme: const TextSelectionThemeData(
        // selectionColor: NOT_ACTIVE_COLOR,
        cursorColor: CustomColors.primaryColor,
        selectionHandleColor: CustomColors.primaryColor,
      ),
      brightness: Brightness.light,
      highlightColor: CustomColors.highlightedColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          surface: CustomColors.backgroundColor,
          surfaceTint: CustomColors.backgroundColor));

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
