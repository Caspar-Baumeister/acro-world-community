import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acroworld/theme/app_colors.dart';
import 'package:acroworld/theme/app_text_styles.dart';

enum ThemeType { light, dark, auto }

@immutable
class AppCustomColors extends ThemeExtension<AppCustomColors> {
  final Color primaryDark;
  final Color primaryDarker;
  final Color accent;
  final Color textMuted;
  final Color textStrong;
  final Color focus;
  final Color icon;
  final Color warning;

  const AppCustomColors({
    required this.primaryDark,
    required this.primaryDarker,
    required this.accent,
    required this.textMuted,
    required this.textStrong,
    required this.focus,
    required this.icon,
    required this.warning,
  });

  @override
  AppCustomColors copyWith({
    Color? primaryDark,
    Color? primaryDarker,
    Color? accent,
    Color? textMuted,
    Color? textStrong,
    Color? focus,
    Color? icon,
    Color? warning,
  }) {
    return AppCustomColors(
      primaryDark: primaryDark ?? this.primaryDark,
      primaryDarker: primaryDarker ?? this.primaryDarker,
      accent: accent ?? this.accent,
      textMuted: textMuted ?? this.textMuted,
      textStrong: textStrong ?? this.textStrong,
      focus: focus ?? this.focus,
      icon: icon ?? this.icon,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) {
      return this;
    }
    return AppCustomColors(
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryDarker: Color.lerp(primaryDarker, other.primaryDarker, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textStrong: Color.lerp(textStrong, other.textStrong, t)!,
      focus: Color.lerp(focus, other.focus, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}

class AppTheme {
  static ThemeData light() {
    return _buildTheme(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightSecondary,
        surface: AppColors.lightBackground, // Main background
        surfaceContainer: AppColors.lightSurface, // Card/modal background
        error: AppColors.lightError,
        onPrimary: AppColors.lightText, // Text on primary
        onSecondary: AppColors.lightText, // Text on secondary
        onSurface: AppColors.lightText, // Text on surface/background
        onError: AppColors.lightText, // Text on error
        outline: AppColors.lightBorders, // Borders/Dividers
      ),
      customColors: const AppCustomColors(
        primaryDark: AppColors.lightPrimaryDark,
        primaryDarker: AppColors.lightPrimaryDarker,
        accent: AppColors.lightAccent,
        textMuted: AppColors.lightTextMuted,
        textStrong: AppColors.lightTextStrong,
        focus: AppColors.lightFocus,
        icon: AppColors.lightIcon,
        warning: AppColors.lightWarning,
      ),
    );
  }

  static ThemeData dark() {
    return _buildTheme(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkSecondary,
        surface: AppColors.darkBackground, // Main background
        surfaceContainer: AppColors.darkSurface, // Card/modal background
        error: AppColors.darkError,
        onPrimary: AppColors.darkText, // Text on primary
        onSecondary: AppColors.darkText, // Text on secondary
        onSurface: AppColors.darkText, // Text on surface/background
        onError: AppColors.darkText, // Text on error
        outline: AppColors.darkBorders, // Borders/Dividers
      ),
      customColors: const AppCustomColors(
        primaryDark: AppColors.darkPrimaryLight,
        primaryDarker: AppColors.darkPrimaryLighter,
        accent: AppColors.darkAccent,
        textMuted: AppColors.darkTextMuted,
        textStrong: AppColors.darkTextStrong,
        focus: AppColors.darkFocus,
        icon: AppColors.darkIcon,
        warning: AppColors.darkWarning,
      ),
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required AppCustomColors customColors,
  }) {
    final isDark = brightness == Brightness.dark;

    // TextTheme with dynamic colors
    TextTheme getTextTheme(Brightness mode) {
      Color textColor = mode == Brightness.dark ? AppColors.darkText : AppColors.lightText;
      return TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: textColor),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: textColor),
        displaySmall: AppTextStyles.displaySmall.copyWith(color: textColor),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: textColor),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: textColor),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: textColor),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: textColor),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: textColor),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: textColor),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: textColor),
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      extensions: [customColors],
      fontFamily: "UntitledSans",

      // Text theme
      textTheme: getTextTheme(brightness),

      // Visual density and platform adjustments
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Component themes
      appBarTheme: AppBarTheme(
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      iconTheme: IconThemeData(
        color: customColors.icon,
      ),
      disabledColor: customColors.textMuted.withOpacity(0.2),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainer, // Use surfaceContainer for input fields
        labelStyle: TextStyle(color: customColors.textMuted),
        hintStyle: TextStyle(color: customColors.textMuted),
        errorStyle: TextStyle(color: colorScheme.error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide(color: customColors.textMuted),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: customColors.textStrong,
        unselectedItemColor: customColors.textMuted,
      ),

      // Disable splash effects
      splashFactory: NoSplash.splashFactory,
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        backgroundColor: colorScheme.surfaceContainer,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionHandleColor: colorScheme.primary,
      ),
      highlightColor: Colors.transparent, // No highlight on tap
    );
  }

  static ThemeData fromType(ThemeType type) {
    return type == ThemeType.light ? light() : dark();
  }
}
