// lib/routing/app_router.dart

import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/presentation/shells/shell_bottom_navigation_bar.dart';
import 'package:acroworld/presentation/shells/shell_desktop_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Wraps your shell and keeps track of which tab is active by
/// inspecting the current GoRouter location.
class UserMainPageShell extends StatelessWidget {
  final Widget child;
  const UserMainPageShell({super.key, required this.child});

  // your top‐level tab destinations:
  static const _paths = [
    '/discover',
    '/activity',
    '/community',
    '/profile',
  ];

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return ShellDesktopLayout(child: child);
    }
    return Scaffold(
      body: child,
      bottomNavigationBar: ShellBottomNavigationBar(
        onItemPressed: (index) {
          context.go(_paths[index]);
        },
      ),
    );
  }
}
