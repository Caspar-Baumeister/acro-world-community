import 'package:acroworld/presentation/components/appbar/base_appbar.dart';
import 'package:acroworld/presentation/components/input/modern_search_bar.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeacherAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TeacherAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAppbar(
      title: ModernSearchBar(
        hintText: 'Search teachers...',
        readOnly: true,
        onTap: () => context.pushNamed(teacherSearchRoute),
        showFilterButton: false, // No filter button, using FilterRow instead
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
