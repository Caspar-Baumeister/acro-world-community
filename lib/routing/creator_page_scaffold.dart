// lib/routing/app_router.dart

import 'package:acroworld/presentation/shells/shell_creator_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Wraps your shell and keeps track of which tab is active by
/// inspecting the current GoRouter location.
class CreatorPageScaffold extends StatelessWidget {
  final Widget child;
  const CreatorPageScaffold({super.key, required this.child});

  // your top‐level tab destinations:
  static const _paths = [
    '/creator-dashboard',
    '/my-events',
    '/invite',
    '/creator-profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: ShellCreatorBottomNavigationBar(
        onItemPressed: (index) {
          context.go(_paths[index]);
        },
      ),
    );
  }
}
