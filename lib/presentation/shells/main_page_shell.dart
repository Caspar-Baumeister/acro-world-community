// lib/routing/app_router.dart

import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/presentation/shells/shell_bottom_navigation_bar.dart';
import 'package:acroworld/presentation/shells/shell_creator_bottom_navigation_bar.dart';
import 'package:acroworld/presentation/shells/shell_desktop_layout.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Wraps your shell and keeps track of which tab is active by
/// inspecting the current GoRouter location.
class MainPageShell extends StatelessWidget {
  final Widget child;
  const MainPageShell({super.key, required this.child});

  // your top‐level tab destinations:
  static const _userPaths = [
    '/discover',
    '/activity',
    '/community',
    '/profile',
  ];

  static const _creatorPaths = [
    '/creator-dashboard',
    '/my-events',
    '/invite',
    '/creator-profile',
  ];

  @override
  Widget build(BuildContext context) {
    bool isCreator =
        Provider.of<UserRoleProvider>(context, listen: false).isCreator;
    if (Responsive.isDesktop(context)) {
      return ShellDesktopLayout(isCreator: isCreator, child: child);
    }
    return Scaffold(
      body: child,
      bottomNavigationBar: isCreator
          ? ShellCreatorBottomNavigationBar(
              onItemPressed: (index) {
                context.go(_creatorPaths[index]);
              },
            )
          : ShellBottomNavigationBar(
              onItemPressed: (index) {
                context.go(_userPaths[index]);
              },
            ),
    );
  }
}
