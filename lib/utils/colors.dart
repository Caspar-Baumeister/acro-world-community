// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

// Marcus Color picks

// const Color COLOR1 = Color(0xFF606c38);
// const Color COLOR2 = Color(0xFF03071e);
// const Color COLOR3 = Color(0xFFffba08);
// const Color COLOR4 = Color(0xFF183a37);
// const Color COLOR5 = Color(0xFFfb8b24);
// const Color COLOR6 = Color(0xFF223843);
// const Color COLOR7 = Color(0xFF0f4c5c);

// COLORS
// try to use colors in the theme and not arbetrarly in the app

// const Color PRIMARY_COLOR = Color.fromARGB(255, 0, 95, 172);
// const Color SECONDARY_COLOR = Color.fromARGB(255, 150, 208, 255);

// const Color CustomColors.secondaryBackgroundColor = Color(0xFFe4e2e3);
// const Color CustomColors.lightTextColor = Color.fromARGB(255, 132, 132, 132);
// const Color LINK_COLOR = Color.fromARGB(255, 0, 54, 98);
// const Color CustomColors.errorTextColor = Color.fromARGB(255, 152, 0, 0);
// const Color CustomColors.successTextColor = Color.fromARGB(255, 0, 110, 4);
// const Color STANDART_BORDER_COLOR = Color.fromARGB(255, 0, 0, 0);
// const Color CustomColors.highlightedColor = const Color.fromARGB(255, 255, 241, 241);
const Color BACKGROUND_COLOR = Color.fromARGB(255, 255, 255, 255);
// dark grey
const Color DARK_GREY = Color.fromARGB(255, 79, 79, 79);

// const Color PRIMARY_COLOR = COLOR2; //Color(0xFF772f1a);
// const Color APPBAR_COLOR = PRIMARY_COLOR;
// const Color SECONDARY_COLOR = Color(0xFFe4e2e3);
// const Color ACTIVE_COLOR = PRIMARY_COLOR;
// const Color NOT_ACTIVE_COLOR = Color(0xFFe4e2e3);
// const Color CONFIRMED_COLOR = Color(0xFF6c8484);
// const Color BUTTON_FILL_COLOR = PRIMARY_COLOR;
// const Color BUTTON_TEXT_COLOR = PRIMARY_COLOR;
// const Color STANDART_TEXT_COLOR = Colors.black;
// const Color UNIMPORTANT_TEXT_COLOR = Color.fromARGB(255, 79, 79, 79);

// const Color _whiteGreen = Color.fromARGB(255, 255, 255, 255);
const Color _highlight_green = Color.fromARGB(255, 237, 255, 237);
const Color _lightGreen = Color(0xFF588157);
const Color _lightGreenSecond = Color.fromARGB(150, 88, 129, 87);
const Color _darkGreen = Color(0xFF1D2E28);
const Color _blackGreen = Color.fromARGB(255, 0, 30, 10);
const Color _lightGreyColor = Color.fromARGB(255, 200, 200, 200);
const Color _black = Color(0xFF000000);
const Color _white = Color(0xFFFFFFFF);
const Color _red = Color(0xFFAD3B3B);
const Color _grey = Color(0xFF707070);
const Color _blue = Color.fromARGB(255, 0, 54, 98);
const Color _lightestGreen = Color(0xFFd4ded5);
const Color _lightOrgange = Color(0xFFfb8b24);
const Color _lightestOrgange = Color(0xFFfce8d5);

class CustomColors {
  // COLOR SCHEME //
  static const Color primaryColor = _darkGreen;
  static const Color accentColor = _lightGreen;

  static const Color highlightedColor = _highlight_green;

// BACKGROUND COLORS //
  static const Color successBgColor = _lightGreen;
  static const Color successBgColorSec = _lightGreenSecond;
  static const Color infoBgColor = _grey;
  static const Color backgroundColor = _white;
  static const Color secondaryBackgroundColor = _lightestGreen;
// BORDER COLORS //
  static const Color inactiveBorderColor = _grey;
  static const Color activeBorderColor = _darkGreen;
  static const Color errorBorderColor = _red;
  static const Color warningColor = _lightOrgange;
  static const Color backgroundWarningColor = _lightestOrgange;

// TEXT COLORS //
  static const Color errorTextColor = _red;
  static const Color successTextColor = _lightGreen;

  static const Color lightTextColor = _grey;
  static const Color lightestTextColor = _lightGreyColor;
  static const Color disabledTextColor = _grey;
  static const Color linkTextColor = _blue;
  static const Color whiteTextColor = _white;

  static const Color primaryTextColor = _blackGreen;
  static const Color secondaryTextColor = _darkGreen;

  static const Color iconColor = _black;

  // Adding new colors for guest profile
  static const Color surfaceColor = Color(0xFFE7F0E7); // Light green surface
  static const Color buttonPrimaryLight =
      Color(0xFFEAF2EA); // Very light green for secondary button
  static const Color subtitleText =
      Color(0xFF49735E); // Muted green for secondary text
}
