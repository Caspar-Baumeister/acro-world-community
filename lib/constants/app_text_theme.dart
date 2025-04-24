import 'package:acroworld/constants/app_colors.dart';
import 'package:acroworld/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTextTheme {
  /// Returns a TextTheme that changes the color of the titleLarge text style
  /// depending on the current theme mode.
  static TextTheme getTextTheme(ThemeMode mode) {
    return TextTheme(
      headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color:
              mode == ThemeMode.dark ? AppColors.darkTxt : AppColors.lightTxt),
      displayLarge: AppTextStyles.displayLarge.copyWith(
          color:
              mode == ThemeMode.dark ? AppColors.darkTxt : AppColors.lightTxt),
      displayMedium: AppTextStyles.displayMedium.copyWith(
          color:
              mode == ThemeMode.dark ? AppColors.darkTxt : AppColors.lightTxt),
      displaySmall: AppTextStyles.displaySmall.copyWith(
          color:
              mode == ThemeMode.dark ? AppColors.darkTxt : AppColors.lightTxt),
      titleMedium: AppTextStyles.titleMedium.copyWith(
          color:
              mode == ThemeMode.dark ? AppColors.darkTxt : AppColors.lightTxt),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color:
              mode == ThemeMode.dark ? AppColors.darkTxt : AppColors.lightTxt),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color:
              mode == ThemeMode.dark ? AppColors.darkTxt : AppColors.lightTxt),
      labelSmall: AppTextStyles.labelSmall.copyWith(
          color:
              mode == ThemeMode.dark ? AppColors.darkTxt : AppColors.lightTxt),
      labelMedium: AppTextStyles.labelMedium.copyWith(
          color:
              mode == ThemeMode.dark ? AppColors.darkTxt : AppColors.lightTxt),
      labelLarge: AppTextStyles.labelLarge.copyWith(
          color:
              mode == ThemeMode.dark ? AppColors.darkTxt : AppColors.lightTxt),
    );
  }
}
