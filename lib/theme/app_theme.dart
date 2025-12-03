import 'package:acroworld/theme/app_colors.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        onPrimary: Colors.white, // White text on primary for good contrast
        onSecondary: AppColors.lightText, // Text on secondary
        onSurface: AppColors.lightText, // Text on surface/background
        onError: AppColors.lightText, // Text on error
        outline: AppColors.lightBorders, // Borders/Dividers
      ),
      customColors: AppCustomColors(
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
        onPrimary: Colors.white, // White text on primary for good contrast
        onSecondary: AppColors.darkText, // Text on secondary
        onSurface: AppColors.darkText, // Text on surface/background
        onError: AppColors.darkText, // Text on error
        outline: AppColors.darkBorders, // Borders/Dividers
      ),
      customColors: AppCustomColors(
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

    // TextTheme with dynamic colors - includes all text styles from Style Guide
    TextTheme getTextTheme(Brightness mode) {
      Color textColor =
          mode == Brightness.dark ? AppColors.darkText : AppColors.lightText;
      return TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: textColor),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: textColor),
        displaySmall: AppTextStyles.displaySmall.copyWith(color: textColor),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: textColor),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: textColor),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: textColor),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: textColor),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: textColor),
        titleSmall: AppTextStyles.titleSmall.copyWith(color: textColor),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: textColor),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: textColor),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: textColor),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: textColor),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: textColor),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: textColor),
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      extensions: [customColors],
      // Using system font for optimal performance and native feel
      // To use a custom font, add it to pubspec.yaml assets and specify here

      // Text theme
      textTheme: getTextTheme(brightness),

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
        fillColor: colorScheme
            .surfaceContainer, // Use surfaceContainer for input fields
        labelStyle: TextStyle(color: customColors.textMuted),
        hintStyle: TextStyle(color: customColors.textMuted),
        errorStyle: TextStyle(color: colorScheme.error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide(color: customColors.textMuted),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: customColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),

      // Disable splash effects for modern feel
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,

      // Card theme
      cardTheme: CardThemeData(
        elevation: AppDimensions.elevationSmall,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        color: colorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingSmall,
          vertical: AppDimensions.spacingExtraSmall,
        ),
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        backgroundColor: colorScheme.surfaceContainer,
        elevation: AppDimensions.elevationLarge,
      ),

      // Drawer theme
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(0.2),
        thickness: 1,
        space: AppDimensions.spacingMedium,
      ),

      // List tile theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMedium,
          vertical: AppDimensions.spacingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: AppDimensions.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
      ),

      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
      ),

      // Text selection theme
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionHandleColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withOpacity(0.2),
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? colorScheme.surfaceContainer : colorScheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: isDark ? colorScheme.onSurface : colorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData fromType(ThemeType type) {
    return type == ThemeType.light ? light() : dark();
  }
}
