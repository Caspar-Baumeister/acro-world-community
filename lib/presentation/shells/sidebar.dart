import 'package:acroworld/presentation/shells/sidebar_library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellSideBar extends StatelessWidget {
  const ShellSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: AssetImage("assets/muscleup_drawing.png"),
            height: 200,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22, top: 40),
            child: Text(
              "ACROWORLD".toUpperCase(),
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          const SizedBox(height: 50),
          const Expanded(
            child: SingleChildScrollView(child: ShellSideNavigationBar()),
          ),
          const SizedBox(height: 50),
          Column(
            children: [
              ListTile(
                title: const Text("Settings"),
                leading: const Icon(Icons.settings),
                onTap: () => context.go('/settings'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
