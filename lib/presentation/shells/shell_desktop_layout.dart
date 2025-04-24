import 'package:acroworld/presentation/shells/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellDesktopLayout extends StatelessWidget {
  final StatefulNavigationShell child;

  const ShellDesktopLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 300,
          child: ShellSideBar(),
        ),
        Container(
          width: 1,
          color: Theme.of(context).colorScheme.surfaceDim,
        ),
        Expanded(child: child),
      ],
    );
  }
}
