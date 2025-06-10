import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightTxt = Color(0xFF2C2C2C);
  static const Color lightIcon = Color(0xFF2C2C2C);
  static const Color lightAccentTxt = Color(0xFFFAFAFA);
  static const Color lightBg1 = Color(0xFFFAFAFA);
  static const Color lightBg2 = Color(0xFFF0F0F0);
  static const Color lightSurface = Color(0xFFFFFFFF);

  // Primary and variants
  static const Color lightAccent1 = Color(0xFFC7BAA7); // Primary beige
  static const Color lightAccent1Dark = Color(0xFF9E8F7A); // Darker beige
  static const Color lightAccent1Darker = Color(0xFF776A5B); // Darkest beige

  // Secondary colors
  static const Color lightAccent2 = Color(0xFF8E9B9B); // Muted teal
  static const Color lightAccent3 = Color(0xFFB1956C); // Warm brown

  // Utility colors
  static const Color lightGreyWeak = Color(0xFFAFAFAF);
  static const Color lightGrey = Color(0xFF757575);
  static const Color lightGreyStrong = Color(0xFF2C2C2C);
  static const Color lightError = Color(0xFFD32F2F);
  static const Color bloodyWarning = Color(0xFF8B0000); //Volume_warning_D
  static const Color lightFocus = Color(0xFF9E8F7A);

  // Dark Theme Colors
  static const Color darkTxt = Color(0xFFF5F5F5);
  static const Color darkIcon = Color(0xFFF5F5F5);
  static const Color darkAccentTxt = Color(0xFF2C2C2C);
  static const Color darkBg1 = Color(0xFF1A1A1A);
  static const Color darkBg2 = Color(0xFF2C2C2C);
  static const Color darkSurface = Color(0xFF242424);

  // Primary and variants
  static const Color darkAccent1 = Color(0xFFC7BAA7); // Keep primary consistent
  static const Color darkAccent1Dark =
      Color(0xFFAA9D8A); // Lighter for dark mode
  static const Color darkAccent1Darker =
      Color(0xFF8E8270); // Mid-tone for dark mode

  // Secondary colors
  static const Color darkAccent2 =
      Color(0xFFA5B2B2); // Lighter teal for contrast
  static const Color darkAccent3 = Color(0xFFC7A87D); // Lighter warm brown

  // Utility colors
  static const Color darkGreyWeak = Color(0xFF8A8A8A);
  static const Color darkGrey = Color(0xFFB0B0B0);
  static const Color darkGreyStrong = Color(0xFFE0E0E0);
  static const Color darkError = Color(0xFFEF5350);
  static const Color darkFocus = Color(0xFFAA9D8A);

  //Switch Button Colors:
  static const Color lightBrownWeak = Color(0xFFEFEBE9); // == to Colors.brown.shade50
  static const Color lightBrown = Color(0xFFD7CCC8); // == to Colors.brown.shade100
}
