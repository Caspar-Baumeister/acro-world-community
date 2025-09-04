import 'package:acroworld/presentation/components/appbar/base_appbar.dart';
import 'package:acroworld/presentation/components/input/modern_search_bar.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/search_delegate/teacher_search_delegate.dart';
import 'package:flutter/material.dart';

class TeacherAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TeacherAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAppbar(
      title: ModernSearchBar(
        hintText: 'Search teachers...',
        readOnly: true,
        onTap: () => showSearch(
          context: context,
          delegate: TeacherSearchDelegate(),
        ),
        showFilterButton: false, // No filter button, using FilterRow instead
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
