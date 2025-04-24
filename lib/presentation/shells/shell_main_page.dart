import 'package:acroworld/presentation/shells/shell_bottom_navigation_bar.dart';
import 'package:acroworld/presentation/shells/shell_desktop_layout.dart';
import 'package:acroworld/provider/riverpod_provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Wraps around the main pages of the app to provide
// - the bottom navigationbar
class ShellMainPage extends ConsumerWidget {
  final StatefulNavigationShell child;

  const ShellMainPage({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onNavigationTapped(int index) {
      child.goBranch(index, initialLocation: index == child.currentIndex);

      // Update the index in the navigation provider
      ref.read(navigationProvider.notifier).setIndex(index);
    }

    Widget body;

    if (MediaQuery.of(context).size.width > 900) {
      body = ShellDesktopLayout(child: child);
    } else {
      body = Scaffold(
        body: child,
        bottomNavigationBar:
            ShellBottomNavigationBar(onItemPressed: onNavigationTapped),
      );
    }

    return Scaffold(body: body);
  }
}
