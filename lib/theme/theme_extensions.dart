import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Extension on BuildContext for easy access to theme properties
/// Usage: context.colors.primary, context.textStyles.bodyMedium, etc.
extension ThemeX on BuildContext {
  /// Access the current ThemeData
  ThemeData get theme => Theme.of(this);

  /// Access the ColorScheme for semantic colors
  ColorScheme get colors => theme.colorScheme;

  /// Access the TextTheme for typography
  TextTheme get textStyles => theme.textTheme;

  /// Access custom app colors (accent, muted text, etc.)
  AppCustomColors get customColors => theme.extension<AppCustomColors>()!;

  /// Check if current theme is dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;
}

/// Extension for spacing values
extension SpacingX on BuildContext {
  /// Extra small spacing: 4.0
  double get spacingXS => AppDimensions.spacingExtraSmall;

  /// Small spacing: 8.0
  double get spacingSM => AppDimensions.spacingSmall;

  /// Medium spacing: 16.0
  double get spacingMD => AppDimensions.spacingMedium;

  /// Large spacing: 24.0
  double get spacingLG => AppDimensions.spacingLarge;

  /// Extra large spacing: 32.0
  double get spacingXL => AppDimensions.spacingExtraLarge;

  /// Huge spacing: 50.0
  double get spacingXXL => AppDimensions.spacingHuge;
}

/// Extension for border radius values
extension RadiusX on BuildContext {
  /// Small radius: 4.0
  BorderRadius get radiusSM => BorderRadius.circular(AppDimensions.radiusSmall);

  /// Medium radius: 8.0
  BorderRadius get radiusMD =>
      BorderRadius.circular(AppDimensions.radiusMedium);

  /// Large radius: 16.0
  BorderRadius get radiusLG => BorderRadius.circular(AppDimensions.radiusLarge);

  /// Full/circular radius: 999.0
  BorderRadius get radiusFull => BorderRadius.circular(999);
}

/// Extension for icon sizes
extension IconSizeX on BuildContext {
  /// Tiny icon: 16.0
  double get iconTiny => AppDimensions.iconSizeTiny;

  /// Small icon: 24.0
  double get iconSM => AppDimensions.iconSizeSmall;

  /// Medium icon: 32.0
  double get iconMD => AppDimensions.iconSizeMedium;

  /// Large icon: 40.0
  double get iconLG => AppDimensions.iconSizeLarge;

  /// Extra large icon: 44.0
  double get iconXL => AppDimensions.iconSizeExtraLarge;
}

/// Convenience class for common EdgeInsets using AppDimensions
class AppEdgeInsets {
  /// All sides with extra small spacing
  static const EdgeInsets allXS =
      EdgeInsets.all(AppDimensions.spacingExtraSmall);

  /// All sides with small spacing
  static const EdgeInsets allSM = EdgeInsets.all(AppDimensions.spacingSmall);

  /// All sides with medium spacing
  static const EdgeInsets allMD = EdgeInsets.all(AppDimensions.spacingMedium);

  /// All sides with large spacing
  static const EdgeInsets allLG = EdgeInsets.all(AppDimensions.spacingLarge);

  /// Horizontal with small, vertical with extra small
  static const EdgeInsets cardPadding = EdgeInsets.symmetric(
    horizontal: AppDimensions.spacingSmall,
    vertical: AppDimensions.spacingExtraSmall,
  );

  /// Standard page padding (horizontal medium)
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: AppDimensions.spacingMedium,
  );

  /// Standard section padding
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    horizontal: AppDimensions.spacingMedium,
    vertical: AppDimensions.spacingSmall,
  );
}

/// Standard border radius constants using AppDimensions
class AppBorderRadius {
  static final BorderRadius small =
      BorderRadius.circular(AppDimensions.radiusSmall);
  static final BorderRadius medium =
      BorderRadius.circular(AppDimensions.radiusMedium);
  static final BorderRadius large =
      BorderRadius.circular(AppDimensions.radiusLarge);
  static final BorderRadius full = BorderRadius.circular(999);

  /// Card-specific radius (large)
  static final BorderRadius card =
      BorderRadius.circular(AppDimensions.radiusLarge);

  /// Button-specific radius (medium)
  static final BorderRadius button =
      BorderRadius.circular(AppDimensions.radiusMedium);

  /// Input field radius (medium)
  static final BorderRadius input =
      BorderRadius.circular(AppDimensions.radiusMedium);
}

/// Standard box shadows for consistent elevation
class AppShadows {
  static List<BoxShadow> get small => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get medium => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get large => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  /// Shadow for cards
  static List<BoxShadow> card(ColorScheme colorScheme) => [
        BoxShadow(
          color: colorScheme.shadow.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Shadow for elevated buttons/FABs
  static List<BoxShadow> elevated(ColorScheme colorScheme) => [
        BoxShadow(
          color: colorScheme.shadow.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}

