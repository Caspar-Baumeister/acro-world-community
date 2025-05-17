import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 904;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 904;

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return mobile;
    } else {
      return desktop;
    }
  }
}
