# Styling and Theming Refactoring Plan

This document outlines a detailed, incremental plan to refactor the application's styling and theming. The core principle is to ensure the application remains **runnable and testable after every single step**. This is achieved by creating new theme files, gradually migrating code and updating references, and only deleting old files once their content is fully superseded and all references are updated.

## Core Principles:

*   **Incremental Migration**: Changes are broken down into the smallest possible, verifiable steps.
*   **No Downtime**: The application must compile and run without errors after each step.
*   **Testability**: Specific pages or components will be refactored early to allow for visual testing of the new styling system.
*   **New Files First**: New theme files are created and populated before any old files are modified or deleted.
*   **Single Source of Truth**: All styling (colors, typography, dimensions) will eventually be defined in a centralized theme.
*   **Thematic Consistency**: Components will consistently retrieve styling information from `Theme.of(context)`.
*   **Clear Naming Conventions**: Constants will follow a logical and predictable naming scheme.

---

## Phase 0: Preparation - Create New Theme Structure

In this phase, we will create the new, centralized theme files. These files will initially be empty or contain placeholder structures.

### Step 0.1: Create `lib/theme/app_theme.dart`

**Description**: Create the main theme definition file. This will eventually house the `ThemeData` for both light and dark modes, and integrate all other theme-related constants.

**File to Create**: `lib/theme/app_theme.dart`

**Content**:
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Placeholder for custom colors extension (will be defined later)
@immutable
class AppCustomColors extends ThemeExtension<AppCustomColors> {
  const AppCustomColors(); // Placeholder constructor

  @override
  AppCustomColors copyWith() => const AppCustomColors(); // Placeholder

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) {
      return this;
    }
    return const AppCustomColors(); // Placeholder
  }
}

// Placeholder for AppTheme class
class AppTheme {
  static ThemeData light() {
    return ThemeData(); // Placeholder
  }

  static ThemeData dark() {
    return ThemeData(); // Placeholder
  }
}
```

**Verification**: Ensure the file is created and the project still compiles. No functional changes expected.

### Step 0.2: Create `lib/theme/app_colors.dart`

**Description**: Create a new file for defining the core color palette. This will eventually replace `lib/constants/app_colors.dart`.

**File to Create**: `lib/theme/app_colors.dart`

**Content**:
```dart
import 'package:flutter/material.dart';

// Define core color values here.
// These will be used to construct ColorScheme and AppCustomColors.
class AppColors {
  // Light Theme Base Colors
  static const Color lightPrimary = Color(0xFFC7BAA7); // Primary beige
  static const Color lightPrimaryDark = Color(0xFF9E8F7A); // Darker beige
  static const Color lightPrimaryDarker = Color(0xFF776A5B); // Darkest beige
  static const Color lightSecondary = Color(0xFF8E9B9B); // Muted teal
  static const Color lightAccent = Color(0xFFB1956C); // Warm brown

  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF2C2C2C);
  static const Color lightTextMuted = Color(0xFFAFAFAF); // lightGreyWeak
  static const Color lightTextStrong = Color(0xFF2C2C2C); // lightGreyStrong
  static const Color lightError = Color(0xFFD32F2F);
  static const Color lightWarning = Color(0xFF8B0000); // bloodyWarning
  static const Color lightFocus = Color(0xFF9E8F7A);
  static const Color lightIcon = Color(0xFF2C2C2C);

  // Dark Theme Base Colors
  static const Color darkPrimary = Color(0xFFC7BAA7); // Keep primary consistent
  static const Color darkPrimaryLight = Color(0xFFAA9D8A); // Lighter for dark mode
  static const Color darkPrimaryLighter = Color(0xFF8E8270); // Mid-tone for dark mode
  static const Color darkSecondary = Color(0xFFA5B2B2); // Lighter teal for contrast
  static const Color darkAccent = Color(0xFFC7A87D); // Lighter warm brown

  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF242424);
  static const Color darkText = Color(0xFFF5F5F5);
  static const Color darkTextMuted = Color(0xFF8A8A8A); // darkGreyWeak
  static const Color darkTextStrong = Color(0xFFE0E0E0); // darkGreyStrong
  static const Color darkError = Color(0xFFEF5350);
  static const Color darkFocus = Color(0xFFAA9D8A);
  static const Color darkIcon = Color(0xFFF5F5F5);

  // General Utility Colors (if not theme-dependent)
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF757575);
  static const Color red = Color(0xFFD32F2F);
  static const Color green = Color(0xFF4CAF50);
  static const Color orange = Color(0xFFFF9800);
}
```

**Verification**: Ensure the file is created and the project still compiles. No functional changes expected.

### Step 0.3: Create `lib/theme/app_dimensions.dart`

**Description**: Create a new file for defining common dimensions and spacing values. This will eventually replace `lib/constants/app_dimensions.dart`. We will also use this opportunity to rename constants to a more consistent pattern.

**File to Create**: `lib/theme/app_dimensions.dart`

**Content**:
```dart
class AppDimensions {
  // Spacing (Padding and Margins)
  static const double spacingExtraSmall = 4.0; // Corresponds to tiny
  static const double spacingSmall = 8.0; // Corresponds to smallPadding
  static const double spacingMedium = 16.0; // Corresponds to xMediumPadding
  static const double spacingLarge = 24.0; // Corresponds to largePadding
  static const double spacingExtraLarge = 32.0; // Corresponds to extraLargePadding
  static const double spacingHuge = 50.0; // Corresponds to extraLargePadding (if needed for larger values)

  // Vertical Spacing (height_size_box)
  static const double heightSpacingSmall = 16.0; // sHeighSbox
  static const double heightSpacingMedium = 28.0; // smHeighSbox
  static const double heightSpacingLarge = 36.0; // mHeighSbox

  // Horizontal Spacing (width_size_box)
  static const double widthSpacingExtraSmall = 1.5; // specialSwitchWidthSbox
  static const double widthSpacingSmall = 2.0; // xxsWidthSbox
  static const double widthSpacingLarge = 100.0; // XLWidthSbox

  // Corner Radius
  static const double radiusSmall = 4.0; // smallRadius
  static const double radiusMedium = 8.0; // mediumRadius
  static const double radiusLarge = 16.0; // largeRadius

  // Elevation
  static const double elevationNone = 0.0; // noElevation
  static const double elevationSmall = 2.0; // sElevation
  static const double elevationMedium = 4.0; // elevation
  static const double elevationLarge = 8.0; // mElevation

  // Component Dimensions
  static const double buttonHeight = 48.0;
  static const double appBarHeight = 56.0;

  // Icon Sizes
  static const double iconSizeSmall = 24.0; // iconSmall
  static const double iconSizeMedium = 32.0; // iconMedium
  static const double iconSizeLarge = 40.0; // iconLarge
  static const double iconSizeExtraLarge = 44.0; // iconSpecialLarge
  static const double iconSizeDialog = 48.0; // iconSpecialDialogLarge

  // Font Sizes (These will be primarily managed by TextTheme, but kept here for reference if needed)
  static const double fontSizeClassic = 15.0;
}
```

**Verification**: Ensure the file is created and the project still compiles. No functional changes expected.

### Step 0.4: Create `lib/theme/app_text_styles.dart`

**Description**: Create a new file for defining the application's text styles. This will eventually replace `lib/constants/app_text_styles.dart`. We will remove color properties from these definitions, as colors will be applied dynamically via `Theme.of(context).textTheme`.

**File to Create**: `lib/theme/app_text_styles.dart`

**Content**:
```dart
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.3,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.6,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.8,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.2,
  );
}
```

**Verification**: Ensure the file is created and the project still compiles. No functional changes expected.

---

## Phase 1: Consolidate Theme Definitions - Initial Setup

In this phase, we will populate the new theme files with the existing definitions and make the `router_app.dart` point to the new theme. The old theme files will remain in place for now.

### Step 1.1: Populate `lib/theme/app_theme.dart` with `ThemeData` and `AppCustomColors`

**Description**: Define the `AppCustomColors` extension and the `AppTheme` class with `light()` and `dark()` methods in `lib/theme/app_theme.dart`. These will use the new `AppColors` and `AppTextStyles` for their definitions.

**Files Involved**:
*   `lib/theme/app_theme.dart`
*   `lib/theme/app_colors.dart`
*   `lib/theme/app_text_styles.dart`

**Changes**:
1.  **Open `lib/theme/app_theme.dart`**:
    *   Add imports for `app_colors.dart` and `app_text_styles.dart`.
    *   Replace the placeholder `AppCustomColors` with the actual implementation, mapping roles to `AppColors`.
    *   Implement the `AppTheme.light()` and `AppTheme.dark()` methods to return `ThemeData` objects, utilizing `AppColors` for `ColorScheme` and `AppCustomColors`, and `AppTextStyles` for `TextTheme`.

**Content for `lib/theme/app_theme.dart` (replace existing content)**:
```dart
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
        primaryContainer: AppColors.lightPrimaryDarker,
        secondary: AppColors.lightSecondary,
        surface: AppColors.lightBackground, // Main background
        surfaceContainer: AppColors.lightSurface, // Card/modal background
        error: AppColors.lightError,
        onPrimary: AppColors.lightText, // Text on primary
        onSecondary: AppColors.lightText, // Text on secondary
        onSurface: AppColors.lightText, // Text on surface/background
        onError: AppColors.lightText, // Text on error
        outline: AppColors.lightTextMuted, // Borders/Dividers
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
        primaryContainer: AppColors.darkPrimaryLighter,
        secondary: AppColors.darkSecondary,
        surface: AppColors.darkBackground, // Main background
        surfaceContainer: AppColors.darkSurface, // Card/modal background
        error: AppColors.darkError,
        onPrimary: AppColors.darkText, // Text on primary
        onSecondary: AppColors.darkText, // Text on secondary
        onSurface: AppColors.darkText, // Text on surface/background
        onError: AppColors.darkText, // Text on error
        outline: AppColors.darkTextMuted, // Borders/Dividers
      ),
      customColors: const AppCustomColors(
        primaryDark: AppColors.darkPrimaryLight,
        primaryDarker: AppColors.darkPrimaryLighter,
        accent: AppColors.darkAccent,
        textMuted: AppColors.darkTextMuted,
        textStrong: AppColors.darkTextStrong,
        focus: AppColors.darkFocus,
        icon: AppColors.darkIcon,
        warning: AppColors.lightWarning, // Assuming warning color is consistent or needs a dark variant
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
      dialogTheme: DialogTheme(
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
```

**Verification**: Ensure the file is created and the project still compiles. No functional changes expected yet.

### Step 1.2: Switch `router_app.dart` to use the new `lib/theme/app_theme.dart`

**Description**: Modify `router_app.dart` to import and use the `AppTheme` from `lib/theme/app_theme.dart`. This is the first major "switch" where the application starts using the new theme system.

**Files Involved**:
*   `lib/router_app.dart`
*   `lib/utils/theme.dart` (will be removed later)

**Changes**:
1.  **Open `lib/router_app.dart`**:
    *   Change `import 'package:acroworld/utils/theme.dart';` to `import 'package:acroworld/theme/app_theme.dart';`.
    *   Update `theme: MyThemes.lightTheme,` to `theme: AppTheme.light(),`.
    *   Remove `import 'package:acroworld/utils/theme.dart';` if it's no longer used.
2.  **No changes to `lib/utils/theme.dart` yet.** It will remain in the project for now.

**Verification**:
*   Run the app.
*   **Crucially, visually inspect the app's appearance.** It should look very similar to before, but now it's drawing its styles from the new `lib/theme/app_theme.dart`. This is your first major test point. If there are visual regressions, it means the new theme definition isn't perfectly mirroring the old one.

---

## Phase 2: Refactor Core Components to Use New Theme

In this phase, we will start refactoring fundamental UI components to consistently use `Theme.of(context)`. This will demonstrate the incremental adoption and allow for early testing of the new theme.

### Step 2.1: Refactor `BaseAppbar` and `CustomAppbarSimple`

**Description**: Update `BaseAppbar` and `CustomAppbarSimple` to retrieve colors and text styles from `Theme.of(context)`.

**Files Involved**:
*   `lib/presentation/components/appbar/base_appbar.dart`
*   `lib/presentation/components/appbar/custom_appbar_simple.dart`
*   `lib/presentation/components/appbar/standard_app_bar/standard_app_bar.dart`

**Changes**:
1.  **Open `lib/presentation/components/appbar/base_appbar.dart`**:
    *   Ensure `AppBar` uses `Theme.of(context).colorScheme.surface` for `backgroundColor` and `Theme.of(context).colorScheme.onSurface` for `foregroundColor` (these should be default, but good to verify).
    *   Ensure `iconTheme` is implicitly handled by `AppBarTheme` in `AppTheme`.
2.  **Open `lib/presentation/components/appbar/custom_appbar_simple.dart`**:
    *   Change `Text(title ?? "", style: Theme.of(context).textTheme.titleLarge)` to `Text(title ?? "", style: Theme.of(context).textTheme.headlineSmall)`. (Adjusting to a more semantically appropriate style from the new `AppTextStyles`).
    *   Ensure `IconButton` uses `Theme.of(context).iconTheme.color` for its color (it should by default).
3.  **Open `lib/presentation/components/appbar/standard_app_bar/standard_app_bar.dart`**:
    *   Similar to `CustomAppbarSimple`, ensure `Text` and `IconButton` use theme properties.

**Verification**:
*   Run the app.
*   Navigate to any page that uses these app bars (e.g., Profile, Account Settings).
*   Visually inspect the app bar's background color, text color, and icon color. They should match the theme.

### Step 2.2: Refactor `BaseBottomNavigationBar` and `BBottomNavigationBar`

**Description**: Update the bottom navigation bar components to use theme-defined colors and dimensions.

**Files Involved**:
*   `lib/presentation/components/bottom_navbar/base_bottom_navbar.dart`
*   `lib/presentation/components/bottom_navbar/bottom_navigation_bar.dart`
*   `lib/presentation/components/bottom_navbar/primary_bottom_navbar_item.dart`
*   `lib/presentation/shells/shell_bottom_navigation_bar.dart`
*   `lib/presentation/shells/shell_creator_bottom_navigation_bar.dart`

**Changes**:
1.  **Open `lib/presentation/components/bottom_navbar/base_bottom_navbar.dart`**:
    *   Replace `AppDimensions.bottomNavBarHeight` with a theme-derived value. For now, keep it as a fixed value or define it in `AppDimensions` and access it via `Theme.of(context).extension<AppDimensions>()!.bottomNavBarHeight` (after adding `AppDimensions` to `AppCustomColors` or as a separate extension). For simplicity, let's assume `AppDimensions` is directly accessible for now.
    *   Replace `AppPaddings.medium` with `AppDimensions.spacingMedium`.
2.  **Open `lib/presentation/components/bottom_navbar/bottom_navigation_bar.dart`**:
    *   Remove `import 'package:acroworld/utils/colors.dart';`.
    *   Replace `CustomColors.primaryTextColor` with `theme.selectedItemColor` or `Theme.of(context).colorScheme.onSurface`.
    *   Replace `CustomColors.secondaryTextColor` with `theme.unselectedItemColor` or `Theme.of(context).colorScheme.onSurface.withOpacity(0.6)`.
    *   Replace `widget.iconDimension` with `Theme.of(context).iconTheme.size` or a value from `AppDimensions`.
3.  **Open `lib/presentation/components/bottom_navbar/primary_bottom_navbar_item.dart`**:
    *   Remove `import 'package:acroworld/utils/colors.dart';`.
    *   Replace `CustomColors.primaryColor` with `Theme.of(context).colorScheme.primary`.
    *   Replace `CustomColors.inactiveBorderColor` with `Theme.of(context).colorScheme.outline`.
    *   Replace `AppDimensions.iconSizeMedium` with `Theme.of(context).iconTheme.size` or a value from `AppDimensions`.
    *   Replace `AppPaddings.small` and `AppPaddings.tiny` with `AppDimensions.spacingSmall` and `AppDimensions.spacingExtraSmall`.
4.  **Open `lib/presentation/shells/shell_bottom_navigation_bar.dart` and `lib/presentation/shells/shell_creator_bottom_navigation_bar.dart`**:
    *   Ensure `BBottomNavigationBar` is correctly themed by `Theme(data: AppTheme.fromType(ThemeType.dark))` as it already is.

**Verification**:
*   Run the app.
*   Visually inspect the bottom navigation bar. Check colors of icons, text, and background for both selected and unselected states. Check spacing.

### Step 2.3: Refactor `StandartButton`

**Description**: Update `StandartButton` to use theme-defined colors and text styles.

**Files Involved**:
*   `lib/presentation/components/buttons/standart_button.dart`

**Changes**:
1.  **Open `lib/presentation/components/buttons/standart_button.dart`**:
    *   Remove `import 'package:acroworld/utils/colors.dart';`.
    *   Replace `CustomColors.primaryColor` with `Theme.of(context).colorScheme.primary`.
    *   Replace `STANDART_ROUNDNESS_STRONG` with `AppDimensions.radiusMedium`.
    *   Replace `Theme.of(context).textTheme.headlineSmall!.copyWith(color: textColor)` with `Theme.of(context).textTheme.labelLarge!.copyWith(color: textColor)` (adjusting to a more semantically appropriate style).
    *   Ensure `Colors.white` is replaced with `Theme.of(context).colorScheme.onPrimary` or `Theme.of(context).colorScheme.surface`.

**Verification**:
*   Run the app.
*   Visually inspect all buttons throughout the app. Check their background, text, and border colors, and text styles.

---

## Phase 3: Refactor Specific Pages/Sections - Incremental Adoption

Now that core components are using the new theme, we can refactor entire pages or sections. This allows for focused testing of the new styling.

### Step 3.1: Refactor Creator Profile Page

**Description**: Update all components within the Creator Profile page to use `Theme.of(context)` for colors, text styles, and dimensions.

**Files Involved**:
*   `lib/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/creator_profile_body.dart`
*   `lib/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/creator_stripe_connect_button.dart`
*   `lib/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/creator_switch_to_user_mode_button.dart`
*   `lib/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/custom_setting_component.dart`
*   `lib/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/edit_creator_profile_button.dart`
*   `lib/presentation/screens/create_creator_profile_pages/create_creator_profile_body.dart` (and its sub-components like image pickers)

**Changes (General Approach)**:
1.  **For each file listed above**:
    *   Remove any direct imports of `lib/utils/colors.dart` or `lib/utils/constants.dart`.
    *   Replace all `CustomColors.someColor` with `Theme.of(context).colorScheme.someColor` or `Theme.of(context).extension<AppCustomColors>()!.someColor`.
    *   Replace all `AppDimensions.someDimension` or `AppPaddings.somePadding` with `AppDimensions.someDimension` (from the new `lib/theme/app_dimensions.dart`) or `Theme.of(context).spacing.someValue` (if a spacing extension is added).
    *   Replace hardcoded `Colors.someColor` with `Theme.of(context).colorScheme.someColor` (e.g., `Colors.black` -> `Theme.of(context).colorScheme.onSurface`).
    *   Ensure `TextStyle` definitions use `Theme.of(context).textTheme` and `.copyWith()` for overrides.

**Verification**:
*   Run the app.
*   Navigate to the Creator Profile page.
*   Thoroughly inspect all elements on this page: text, buttons, icons, spacing, and background colors. Ensure they align with the new theme.

### Step 3.2: Refactor My Events Page

**Description**: Update all components within the My Events page to use `Theme.of(context)` for colors, text styles, and dimensions.

**Files Involved**:
*   `lib/presentation/screens/creator_mode_screens/main_pages/my_events_page/my_events_page.dart`
*   `lib/presentation/screens/creator_mode_screens/main_pages/my_events_page/sections/created_events_by_me_section.dart`
*   `lib/presentation/screens/creator_mode_screens/main_pages/my_events_page/sections/participated_events_section.dart`
*   `lib/presentation/components/class_widgets/class_template_card.dart`
*   `lib/presentation/components/tiles/event_tiles/class_tile.dart`

**Changes (General Approach)**:
1.  **For each file listed above**:
    *   Remove any direct imports of `lib/utils/colors.dart` or `lib/utils/constants.dart`.
    *   Replace all `CustomColors.someColor` with `Theme.of(context).colorScheme.someColor` or `Theme.of(context).extension<AppCustomColors>()!.someColor`.
    *   Replace all `AppDimensions.someDimension` or `AppPaddings.somePadding` with `AppDimensions.someDimension` (from the new `lib/theme/app_dimensions.dart`) or `Theme.of(context).spacing.someValue`.
    *   Replace hardcoded `Colors.someColor` with `Theme.of(context).colorScheme.someColor`.
    *   Ensure `TextStyle` definitions use `Theme.of(context).textTheme` and `.copyWith()` for overrides.

**Verification**:
*   Run the app.
*   Navigate to the My Events page.
*   Thoroughly inspect all elements on this page: text, buttons, icons, spacing, and background colors. Ensure they align with the new theme.

---

## Phase 4: Global Refactoring and Cleanup

This is the final phase where we perform a global sweep to ensure all remaining components use the new theme and then remove the old, redundant files.

### Step 4.1: Global Search and Replace for `CustomColors` and `AppDimensions` direct usage

**Description**: Perform a global search for any remaining direct usages of `CustomColors.` and `AppDimensions.` (from the old `lib/utils/colors.dart` and `lib/utils/constants.dart`). Replace these with their `Theme.of(context)` equivalents or the new `AppDimensions` constants.

**Files Involved**: All `.dart` files in the `lib` directory.

**Changes**:
1.  **Search for `CustomColors.`**: For each occurrence, replace it with `Theme.of(context).colorScheme.someColor` or `Theme.of(context).extension<AppCustomColors>()!.someColor` as appropriate.
2.  **Search for `AppDimensions.`**: For each occurrence, replace it with `AppDimensions.someDimension` (from the new `lib/theme/app_dimensions.dart`).
3.  **Search for `AppPaddings.`**: For each occurrence, replace it with `AppDimensions.spacingSomeValue` (from the new `lib/theme/app_dimensions.dart`).
4.  **Search for `STANDART_ROUNDNESS_STRONG`, `STANDART_ROUNDNESS_LIGHT`, `CLASS_CARD_HEIGHT`, `BOOKING_CARD_HEIGHT`, etc.**: Replace these with their corresponding `AppDimensions` constants.

**Verification**:
*   Run the app.
*   Thoroughly test all major screens and components. This is a large step, so be prepared for potential visual regressions or minor compilation errors that need fixing.

### Step 4.2: Delete Old Theme Files

**Description**: Once all references to the old theme files have been updated, these files can be safely deleted.

**Files to Delete**:
*   `lib/constants/app_colors.dart`
*   `lib/constants/app_dimensions.dart`
*   `lib/constants/app_text_styles.dart`
*   `lib/constants/app_text_theme.dart`
*   `lib/utils/colors.dart`
*   `lib/utils/constants.dart`
*   `lib/utils/text_constants.dart`
*   `lib/utils/theme.dart`

**Changes**:
1.  Delete the specified files from your project.

**Verification**:
*   Run `flutter clean` and `flutter pub get`.
*   Run the app. It should compile and run without any errors related to missing files.

### Step 4.3: Remove Redundant Imports

**Description**: After deleting the old theme files, many `.dart` files will have redundant `import` statements pointing to these non-existent files. Remove these imports.

**Files Involved**: All `.dart` files in the `lib` directory.

**Changes**:
1.  Go through each `.dart` file.
2.  Remove any `import` statements that refer to the files deleted in Step 4.2. Many IDEs (like VS Code or Android Studio) can help automate this with "Organize Imports" or similar features.

**Verification**:
*   Run `flutter analyze` to catch any remaining unused imports or other linting issues.
*   Run the app to ensure no runtime errors.

### Step 4.4: Final Review and Refine `lib/theme/app_theme.dart`

**Description**: Perform a final review of `lib/theme/app_theme.dart` to ensure it is clean, well-organized, and contains all necessary styling definitions. Remove any unused or redundant properties within the `AppCustomColors` extension or `AppTheme` methods.

**Files Involved**:
*   `lib/theme/app_theme.dart`
*   `lib/theme/app_colors.dart`
*   `lib/theme/app_dimensions.dart`
*   `lib/theme/app_text_styles.dart`

**Changes**:
1.  Review `AppCustomColors` and `AppTheme` classes.
2.  Remove any unused color properties from `AppCustomColors` if they are not being used by any component.
3.  Ensure all `TextStyle` definitions in `app_text_styles.dart` are consistent and correctly applied.
4.  Add comments where necessary to explain design decisions.

**Verification**:
*   Thoroughly test the entire application to ensure all styling is consistent and correct.
*   The app should now be fully migrated to the new, centralized theme system.

---

This detailed plan provides a step-by-step guide for refactoring your app's styling, prioritizing stability and testability at each stage. Remember to commit frequently after each successful small step to maintain a stable codebase.