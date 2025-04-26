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
          title: const Text("Discover"),
          leading: const Icon(Icons.home),
          onTap: () => context.go('/discover'),
        ),
        ListTile(
          title: const Text("Activity"),
          leading: const Icon(Icons.person),
          onTap: () => context.go('/activity'),
        ),
        ListTile(
          title: const Text("Profile"),
          leading: const Icon(Icons.settings),
          onTap: () => context.go('/profile'),
        ),
        // Add more items as needed
      ],
    );
  }
}
