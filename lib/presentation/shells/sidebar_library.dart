import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShellSideNavigationBar extends ConsumerWidget {
  const ShellSideNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          title: const Text("Home"),
          leading: const Icon(Icons.home),
          onTap: () => context.go('/home'),
        ),
        ListTile(
          title: const Text("Profile"),
          leading: const Icon(Icons.person),
          onTap: () => context.go('/profile'),
        ),
        ListTile(
          title: const Text("Settings"),
          leading: const Icon(Icons.settings),
          onTap: () => context.go('/settings'),
        ),
        // Add more items as needed
      ],
    );
  }
}
