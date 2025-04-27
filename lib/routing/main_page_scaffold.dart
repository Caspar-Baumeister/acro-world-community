// lib/routing/app_router.dart

import 'package:acroworld/presentation/shells/shell_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Wraps your shell and keeps track of which tab is active by
/// inspecting the current GoRouter location.
class MainPageScaffold extends StatelessWidget {
  final Widget child;
  const MainPageScaffold({super.key, required this.child});

  // your top‐level tab destinations:
  static const _paths = [
    '/discover',
    '/activity',
    '/community',
    '/profile',
  ];

  int _computeIndex(String location) {
    print("try to compute index for $location");
    // pick the first matching prefix in order:
    for (var i = 0; i < _paths.length; i++) {
      if (location.startsWith(_paths[i])) return i;
    }
    return 0; // default to first
  }

  @override
  Widget build(BuildContext context) {
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
