import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/bottom_navbar/modern_bottom_navigation_bar.dart';
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
    CustomErrorHandler.logDebug("Selected index: $selectedIndex");
    final notifier = ref.read(navigationProvider.notifier);

    return ModernBottomNavigationBar(
      selectedIndex: selectedIndex,
      onItemSelected: (index) {
        notifier.setIndex(index);
        onItemPressed(index);
      },
      items: [
        ModernNavigationBarItem(
          icon: IconLibrary.world.icon,
          selectedIcon: IconLibrary.world.icon,
          label: "Events",
        ),
        ModernNavigationBarItem(
          icon: IconLibrary.community.icon,
          selectedIcon: IconLibrary.community.icon,
          label: "Community",
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
