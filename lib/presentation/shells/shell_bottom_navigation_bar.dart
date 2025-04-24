import 'package:acroworld/presentation/components/bottom_navbar/bottom_navigation_bar.dart';
import 'package:acroworld/presentation/theme.dart';
import 'package:acroworld/provider/riverpod_provider/navigation_provider.dart';
import 'package:acroworld/utils/icons/icon_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShellBottomNavigationBar extends ConsumerWidget {
  const ShellBottomNavigationBar({super.key, required this.onItemPressed});

  final void Function(int index) onItemPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex =
        ref.watch(navigationProvider); // Listen to the navigation provider

    return Theme(
        // We always use dark theme for the bottom navigation bar
        data: AppTheme.fromType(ThemeType.dark),
        child: BBottomNavigationBar(
          selectedIndex: selectedIndex,
          onItemSelected: onItemPressed,
          additionalBottomPadding: MediaQuery.of(context).padding.bottom,
          items: [
            UiNavigationBarItem(
              icon: Icon(IconLibrary.calendar.icon),
              title: Text("Play"),
              disabled: true,
            ),
            UiNavigationBarItem(
              icon: Icon(IconLibrary.community.icon),
              title: Text("Library"),
            ),
            UiNavigationBarItem(
              icon: Icon(IconLibrary.profile.icon),
              title: Text("Settings"),
            ),
            UiNavigationBarItem(
              icon: Icon(IconLibrary.profile.icon),
              title: Text("Settings"),
            ),
          ],
        ));
  }
}
