import 'package:acroworld/presentation/shells/sidebar.dart';
import 'package:flutter/material.dart';

class ShellDesktopLayout extends StatelessWidget {
  final Widget child;
  final bool isCreator;

  const ShellDesktopLayout(
      {super.key, required this.child, required this.isCreator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 300,
            child: ShellSideBar(
              isCreator: isCreator,
            ),
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
