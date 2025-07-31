import 'package:acroworld/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ThemeType { light, dark, auto }

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color accent1Dark;
  final Color accent1Darker;
  final Color accent3;
  final Color greyWeak;
  final Color greyStrong;
  final Color focus;
  final Color icon;

  const CustomColors({
    required this.accent1Dark,
    required this.accent1Darker,
    required this.accent3,
    required this.greyWeak,
    required this.greyStrong,
    required this.focus,
    required this.icon,
  });

  @override
  CustomColors copyWith({
    Color? accent1Dark,
    Color? accent1Darker,
    Color? accent3,
    Color? greyWeak,
    Color? greyStrong,
    Color? focus,
    Color? icon,
  }) {
    return CustomColors(
      accent1Dark: accent1Dark ?? this.accent1Dark,
      accent1Darker: accent1Darker ?? this.accent1Darker,
      accent3: accent3 ?? this.accent3,
      greyWeak: greyWeak ?? this.greyWeak,
      greyStrong: greyStrong ?? this.greyStrong,
      focus: focus ?? this.focus,
      icon: icon ?? this.icon,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      accent1Dark: Color.lerp(accent1Dark, other.accent1Dark, t)!,
      accent1Darker: Color.lerp(accent1Darker, other.accent1Darker, t)!,
      accent3: Color.lerp(accent3, other.accent3, t)!,
      greyWeak: Color.lerp(greyWeak, other.greyWeak, t)!,
      greyStrong: Color.lerp(greyStrong, other.greyStrong, t)!,
      focus: Color.lerp(focus, other.focus, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
    );
  }
}

class AppTheme {
  static ThemeData light() {
    return _buildTheme(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightAccent1,
        primaryContainer: AppColors.lightAccent1Darker,
        secondary: AppColors.lightAccent2,
        surface: AppColors.lightBg1,
        surfaceDim: AppColors.darkGreyStrong,
        error: AppColors.lightError,
        onPrimary: AppColors.lightAccentTxt,
        onSecondary: AppColors.lightAccentTxt,
        onSurface: AppColors.lightTxt,
        onError: AppColors.lightTxt,
        shadow: AppColors.darkGrey,
      ),
      customColors: const CustomColors(
        accent1Dark: AppColors.lightAccent1Dark,
        accent1Darker: AppColors.lightAccent1Darker,
        accent3: AppColors.lightAccent3,
        greyWeak: AppColors.lightGreyWeak,
        greyStrong: AppColors.lightGreyStrong,
        focus: AppColors.lightFocus,
        icon: AppColors.lightIcon,
      ),
    );
  }

  static ThemeData dark() {
    return _buildTheme(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.darkAccent1,
        primaryContainer: AppColors.darkAccent1Darker,
        secondary: AppColors.darkAccent2,
        surface: AppColors.darkBg1,
        surfaceDim: AppColors.darkSurface,
        error: AppColors.darkError,
        onPrimary: AppColors.darkAccentTxt,
        onSecondary: AppColors.darkAccentTxt,
        onSurface: AppColors.darkTxt,
        onError: AppColors.darkTxt,
        shadow: AppColors.darkSurface,
      ),
      customColors: CustomColors(
        accent1Dark: AppColors.darkAccent1Dark,
        accent1Darker: AppColors.darkAccent1Darker,
        accent3: AppColors.darkAccent3,
        greyWeak: AppColors.darkGreyWeak,
        greyStrong: AppColors.darkGreyStrong,
        focus: AppColors.darkFocus,
        icon: AppColors.darkIcon,
      ),
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required CustomColors customColors,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        brightness: brightness,
        extensions: [customColors],
        fontFamily: "UntitledSans",

        // Text theme
        textTheme: AppTextTheme.getTextTheme(
            isDark ? ThemeMode.dark : ThemeMode.light),

        // Visual density and platform adjustments
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Component themes
        appBarTheme: AppBarTheme(
          systemOverlayStyle:
              isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(
          color: customColors.icon,
        ),
        disabledColor: customColors.greyWeak.withOpacity(0.2),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            minimumSize: const Size(88, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: colorScheme.surface,
            labelStyle: TextStyle(color: customColors.greyWeak),
            hintStyle: TextStyle(color: customColors.greyWeak),
            errorStyle: TextStyle(color: colorScheme.error),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: customColors.greyWeak),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0)),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: colorScheme.surface,
          selectedItemColor: customColors.greyStrong,
          unselectedItemColor: customColors.greyWeak,
        ),

        // Disable splash effects
        splashFactory: NoSplash.splashFactory,
        dialogTheme: const DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ));
  }

  static ThemeData fromType(ThemeType type) {
    return type == ThemeType.light ? light() : dark();
  }
}
