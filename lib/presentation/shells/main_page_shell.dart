// lib/routing/app_router.dart

import 'package:acroworld/presentation/components/buttons/floating_creator_mode_button.dart';
import 'package:acroworld/presentation/components/buttons/floating_user_mode_button.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/presentation/shells/shell_bottom_navigation_bar.dart';
import 'package:acroworld/presentation/shells/shell_creator_bottom_navigation_bar.dart';
import 'package:acroworld/presentation/shells/shell_desktop_layout.dart';
import 'package:acroworld/provider/riverpod_provider/user_role_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Wraps your shell and keeps track of which tab is active by
/// inspecting the current GoRouter location.
class MainPageShell extends ConsumerWidget {
  final Widget child;
  const MainPageShell({super.key, required this.child});

  // your top‐level tab destinations:
  static const _userPaths = [
    '/',
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
  Widget build(BuildContext context, WidgetRef ref) {
    bool isCreator = ref.watch(userRoleProvider);
    final currentLocation = GoRouterState.of(context).uri.path;
    
    if (Responsive.isDesktop(context)) {
      return ShellDesktopLayout(isCreator: isCreator, child: child);
    }
    
    // Determine which floating button to show based on current route
    Widget? floatingButton;
    if (isCreator && currentLocation == '/creator-profile') {
      // Show user mode button only on creator profile page
      floatingButton = const FloatingUserModeButton();
    } else if (!isCreator && currentLocation == '/profile') {
      // Show creator mode button only on user profile page
      floatingButton = const FloatingCreatorModeButton();
    }
    
    return Scaffold(
      body: Stack(
        children: [
          child,
          // Floating mode switch button (only on specific screens)
          if (floatingButton != null) floatingButton,
        ],
      ),
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
