import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

const double _fontSizeDisplayLarge = 26.0;
const double _fontSizeDisplayMedium = 24.0;
const double _fontSizeDisplaySmall = 22.0;
const double _fontSizeHeadlineMedium = 20.0;
const double _fontSizeHeadlineSmall = 18.0;
const double _fontSizeTitleLarge = 16.0;
const double _fontSizeTitleMedium = 14.0;
const double _fontSizeTitleSmall = 12.0;
const double _fontSizeBodyLarge = 16.0;
const double _fontSizeBodyMedium = 14.0;
const double _fontSizeBodySmall = 12.0;
const double _fontSizeLabelLarge = 14.0;
const double _fontSizeLabelSmall = 10.0;

TextStyle displayLargeTextStyle(Color color) => TextStyle(
      fontSize: _fontSizeDisplayLarge,
      fontWeight: FontWeight.bold,
      color: color,
    );

TextStyle displayMediumTextStyle(Color color) => TextStyle(
      fontSize: _fontSizeDisplayMedium,
      fontWeight: FontWeight.w600,
      color: color,
    );

TextStyle displaySmallTextStyle(Color color) => TextStyle(
      fontSize: _fontSizeDisplaySmall,
      fontWeight: FontWeight.w500,
      color: color,
    );

TextStyle headlineMediumTextStyle(Color color) => TextStyle(
      fontSize: _fontSizeHeadlineMedium,
      fontWeight: FontWeight.bold,
      color: color,
    );

TextStyle headlineSmallTextStyle(Color color) => TextStyle(
      fontSize: _fontSizeHeadlineSmall,
      fontWeight: FontWeight.w500,
      color: color,
    );

TextStyle titleLargeTextStyle(Color color) => TextStyle(
      fontSize: _fontSizeTitleLarge,
      fontWeight: FontWeight.w600,
      color: color,
    );

TextStyle titleMediumTextStyle(Color color) => TextStyle(
      fontSize: _fontSizeTitleMedium,
      fontWeight: FontWeight.w600,
      color: color,
    );

TextStyle titleSmallTextStyle(Color color) => TextStyle(
      fontSize: _fontSizeTitleSmall,
      fontWeight: FontWeight.w600,
      color: color,
    );

TextStyle bodyLargeTextStyle(Color color) => TextStyle(
      fontSize: _fontSizeBodyLarge,
      fontWeight: FontWeight.normal,
      color: color,
    );

TextStyle bodyMediumTextStyle(Color color) => TextStyle(
      fontSize: _fontSizeBodyMedium,
      fontWeight: FontWeight.normal,
      color: color,
    );

TextStyle labelLargeTextStyle(Color color) => TextStyle(
      fontSize: _fontSizeLabelLarge,
      fontWeight: FontWeight.w500,
      color: color,
    );

TextStyle bodySmallTextStyle(Color color) => TextStyle(
      fontSize: _fontSizeBodySmall,
      fontWeight: FontWeight.normal,
      color: color,
    );

TextStyle labelSmallTextStyle(Color color) => TextStyle(
      fontSize: _fontSizeLabelSmall,
      fontWeight: FontWeight.normal,
      color: color,
    );

class CustomHtmlStyle {
  Style headlineStyle = Style(
    fontSize: FontSize(_fontSizeHeadlineSmall),
    fontWeight: FontWeight.w800,
    color: CustomColors.primaryTextColor,
    maxLines: 2,
    textOverflow: TextOverflow.ellipsis,
  );
}
