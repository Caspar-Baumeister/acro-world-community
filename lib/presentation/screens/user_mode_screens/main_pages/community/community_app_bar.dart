import 'package:acroworld/presentation/components/appbar/base_appbar.dart';
import 'package:acroworld/presentation/components/input/modern_search_bar.dart';
import 'package:flutter/material.dart';

class TeacherAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onSearchChanged;

  const TeacherAppBar({super.key, required this.onSearchChanged});

  @override
  TeacherAppBarState createState() => TeacherAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TeacherAppBarState extends State<TeacherAppBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    widget.onSearchChanged(_controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseAppbar(
      title: ModernSearchBar(
        controller: _controller,
        hintText: 'Search teachers...',
        onChanged: (value) => widget.onSearchChanged(value),
        showFilterButton: false,
      ),
    );
  }
}
