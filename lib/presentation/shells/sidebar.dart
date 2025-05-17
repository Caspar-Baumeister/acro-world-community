import 'package:acroworld/presentation/shells/sidebar_library.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class ShellSideBar extends StatelessWidget {
  const ShellSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22, top: 40),
            child: Image(
              image: AssetImage("assets/muscleup_drawing.png"),
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22, top: 40),
            child: Text(
              "ACROWORLD".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: CustomColors.accentColor),
            ),
          ),
          const SizedBox(height: 50),
          const Expanded(
            child: SingleChildScrollView(
                child: Material(child: ShellSideNavigationBar())),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
