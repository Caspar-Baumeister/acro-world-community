import 'package:acroworld/presentation/components/bottom_navbar/modern_bottom_navigation_bar.dart';
import 'package:acroworld/provider/riverpod_provider/navigation_provider.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_events_provider.dart';
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

    final pendingCount = ref.watch(teacherEventsProvider).pendingInvitesCount;

    return ModernBottomNavigationBar(
      selectedIndex: selectedIndex,
      onItemSelected: (index) {
        notifier.setIndex(index);
        onItemPressed(index);
      },
      items: [
        ModernNavigationBarItem(
          icon: IconLibrary.dashboard.icon,
          selectedIcon: IconLibrary.dashboard.icon,
          label: "Bookings",
        ),
        ModernNavigationBarItem(
          icon: IconLibrary.calendar.icon,
          selectedIcon: IconLibrary.calendar.icon,
          label: "Listings",
        ),
        ModernNavigationBarItem(
          icon: IconLibrary.invites.icon,
          selectedIcon: IconLibrary.invites.icon,
          label: "Invitations",
          badgeCount: pendingCount > 0 ? pendingCount : null,
        ),
        ModernNavigationBarItem(
          icon: IconLibrary.profile.icon,
          selectedIcon: IconLibrary.profile.icon,
          label: "Profile",
        ),
      ],
    );
  }
}
