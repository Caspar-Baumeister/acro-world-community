// lib/routing/app_router.dart

import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/presentation/shells/shell_bottom_navigation_bar.dart';
import 'package:acroworld/presentation/shells/shell_desktop_layout.dart';
import 'package:acroworld/provider/riverpod_provider/navigation_provider.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).uri.path;

    // Sync the navigation provider with the current route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userIndex = _userPaths.indexOf(currentLocation);
      if (userIndex != -1) {
        ref.read(navigationProvider.notifier).setIndex(userIndex);
      }
    });

    if (Responsive.isDesktop(context)) {
      return ShellDesktopLayout(child: child);
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: ShellBottomNavigationBar(
        onItemPressed: (index) {
          context.go(_userPaths[index]);
        },
      ),
    );
  }
}
