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
