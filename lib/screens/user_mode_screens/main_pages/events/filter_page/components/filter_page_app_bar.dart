import 'package:flutter/material.dart';

// prefered size of the app bar
class FilterPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FilterPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Filter",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kBottomNavigationBarHeight);
}
