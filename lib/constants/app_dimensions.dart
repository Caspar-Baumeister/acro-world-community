import 'package:flutter/material.dart';

class AppDimensions {
  // Padding and Margins
  static const double smallPadding = 5;
  static const double specialSPadding = 6; //
  static const double specialmediumPadding = 8; //
  static const double mediumPadding = 10;
  static const double mxMPadding = 12; //
  static const double xMediumPadding = 16;
  static const double trackWidthCalculPadding = 20;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 50.0;

  // Vertical Spacing (height_size_box)
  static const double sHeighSbox = 16.0;
  static const double smHeighSbox = 28.0;
  static const double mHeighSbox = 36.0; //

  // Horizontal Spacing (width_size_box)
  static const double specialSwitchWidthSbox = 1.5;
  static const double xxsWidthSbox = 2.0;
  static const double XLWidthSbox = 100.0;

  // Corner Radius
  static const double smallRadius = 4.0;
  static const double specialsmallRadius = 6.0;
  static const double mediumRadius = 8.0;
  static const double largeRadius = 16.0;

  // Other Dimensions
  static const double noElevation = 0.0;
  static const double sElevation = 2.0; //
  static const double elevation = 4.0;
  static const double mElevation = 8.0; //
  static const double buttonHeight = 48.0;
  static const double appBarHeight = 56.0;

  // Icon Sizes
  static const double iconSmall = 24.0;
  static const double iconMedium = 32.0;
  static const double iconLarge = 40.0;
  static const double iconSpecialLarge = 44.0; //
  static const double iconSpecialDialogLarge = 48.0;

  // Fonts Sizes
  static const double classicFontSize = 15.0;
}

class AppSpacing {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;

  const AppSpacing._();
}

class AppBorders {
  static const BorderRadius defaultRadius =
      BorderRadius.all(Radius.circular(8.0));

  const AppBorders._();
}
