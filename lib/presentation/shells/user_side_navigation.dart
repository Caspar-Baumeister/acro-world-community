import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserDestopSideNavigationBar extends StatelessWidget {
  const UserDestopSideNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
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
          title: const Text("Community"),
          leading: const Icon(Icons.group),
          onTap: () => context.go('/community'),
        ),
        ListTile(
          title: const Text("Profile"),
          leading: const Icon(Icons.settings),
          onTap: () => context.go('/profile'),
        ),
      ],
    );
  }
}
