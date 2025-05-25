import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatorDestopSideNavigationBar extends StatelessWidget {
  const CreatorDestopSideNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    //     '/creator-dashboard',
    // '/my-events',
    // '/invite',
    // '/creator-profile',
    return Column(
      children: [
        ListTile(
          title: const Text("Bookings"),
          leading: const Icon(Icons.home),
          onTap: () => context.go('/creator-dashboard'),
        ),
        ListTile(
          title: const Text("My Events"),
          leading: const Icon(Icons.person),
          onTap: () => context.go('/my-events'),
        ),
        ListTile(
          title: const Text("Invitations"),
          leading: const Icon(Icons.group),
          onTap: () => context.go('/invite'),
        ),
        ListTile(
          title: const Text("Profile"),
          leading: const Icon(Icons.settings),
          onTap: () => context.go('/creator-profile'),
        ),
      ],
    );
  }
}
