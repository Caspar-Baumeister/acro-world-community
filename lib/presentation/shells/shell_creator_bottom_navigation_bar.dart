import 'package:acroworld/presentation/components/bottom_navbar/bottom_navigation_bar.dart';
import 'package:acroworld/presentation/theme.dart';
import 'package:acroworld/provider/riverpod_provider/navigation_provider.dart';
import 'package:acroworld/utils/icons/icon_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShellCreatorBottomNavigationBar extends ConsumerWidget {
  const ShellCreatorBottomNavigationBar(
      {super.key, required this.onItemPressed});

  final void Function(int index) onItemPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref
        .watch(creatorNavigationProvider); // Listen to the navigation provider
    print("Selected index creator: $selectedIndex");
    final notifier = ref.read(creatorNavigationProvider.notifier);

    return Theme(
        // We always use dark theme for the bottom navigation bar
        data: AppTheme.fromType(ThemeType.dark),
        child: BBottomNavigationBar(
          selectedIndex: selectedIndex,
          onItemSelected: (index) {
            notifier.setIndex(index);
            onItemPressed(index);
          },
          items: [
            UiNavigationBarItem(
              icon: Icon(IconLibrary.dashboard.icon),
              title: Text("Bookings"),
            ),
            UiNavigationBarItem(
              icon: Icon(IconLibrary.calendar.icon),
              title: Text("My Events"),
            ),
            UiNavigationBarItem(
              icon: Icon(IconLibrary.invites.icon),
              title: Text("invitations"),
            ),
            UiNavigationBarItem(
              icon: Icon(IconLibrary.profile.icon),
              title: Text("Creator Profile"),
            ),
          ],
        ));
  }
}
