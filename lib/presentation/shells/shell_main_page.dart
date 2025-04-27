import 'package:acroworld/presentation/shells/shell_desktop_layout.dart';
import 'package:acroworld/provider/riverpod_provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Wraps around the main pages of the app with common UI elements
// such as a bottom navigation bar
class ShellMainPage extends ConsumerWidget {
  final StatefulNavigationShell child;

  const ShellMainPage({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (MediaQuery.of(context).size.width > 900) {
      return Scaffold(body: ShellDesktopLayout(child: child));
    } else {
      void onNavigationTapped(int index) {
        child.goBranch(index, initialLocation: index == child.currentIndex);

        // Update the index in the navigation provider
        ref.read(navigationProvider.notifier).setIndex(index);
      }

      return child;
    }
  }
}
