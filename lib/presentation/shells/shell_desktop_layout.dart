import 'package:acroworld/presentation/shells/sidebar.dart';
import 'package:flutter/material.dart';

class ShellDesktopLayout extends StatelessWidget {
  final Widget child;

  const ShellDesktopLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: ShellSideBar(),
          ),
          Container(
            width: 1,
            color: Theme.of(context).colorScheme.surfaceDim,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
