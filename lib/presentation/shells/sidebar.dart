import 'package:acroworld/presentation/shells/creator_side_navigation.dart';
import 'package:acroworld/presentation/shells/user_side_navigation.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class ShellSideBar extends StatelessWidget {
  const ShellSideBar({super.key, required this.isCreator});

  final bool isCreator;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Center(
            child: Image(
              image: AssetImage("assets/muscleup_drawing.png"),
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          Center(
            child: Text(
              "ACROWORLD".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: CustomColors.accentColor),
            ),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: SingleChildScrollView(
                child: isCreator
                    ? const CreatorDestopSideNavigationBar()
                    : const UserDestopSideNavigationBar()),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
