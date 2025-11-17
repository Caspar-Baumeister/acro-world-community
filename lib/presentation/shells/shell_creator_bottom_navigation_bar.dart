import 'package:acroworld/presentation/components/bottom_navbar/modern_bottom_navigation_bar.dart';
import 'package:acroworld/provider/riverpod_provider/navigation_provider.dart';
import 'package:acroworld/provider/riverpod_provider/pending_invites_badge_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
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
    final pendingCount = ref.watch(pendingInvitesBadgeProvider);

    // Initialize pending invites badge when creator mode is active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userAsync = ref.read(userRiverpodProvider);
      userAsync.whenData((user) {
        if (user?.id != null) {
          ref
              .read(pendingInvitesBadgeProvider.notifier)
              .fetchPendingCount(user!.id!);
        }
      });
    });

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.15),
            Theme.of(context).colorScheme.surface,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ModernBottomNavigationBar(
        backgroundColor: Colors.transparent,
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
            badgeCount: pendingCount,
          ),
          ModernNavigationBarItem(
            icon: IconLibrary.profile.icon,
            selectedIcon: IconLibrary.profile.icon,
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
