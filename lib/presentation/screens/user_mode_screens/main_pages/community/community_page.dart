import 'package:acroworld/presentation/components/input/modern_search_bar.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/community_app_bar.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/community_query.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  bool isFollowed = false;

  setFollowed(bool newFollowed) {
    setState(() {
      isFollowed = newFollowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: const TeacherAppBar(),
      makeScrollable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: AppDimensions.spacingSmall, top: 8),
            child: FilterRow(
              selectFollowed: setFollowed,
              isFollowed: isFollowed,
            ),
          ),
          Expanded(
            child: TeacherQuery(
              search: "", // No search functionality in main view
              isFollowed: isFollowed,
            ),
          ),
        ],
      ),
    );
  }
}

class FilterRow extends StatelessWidget {
  const FilterRow(
      {super.key, required this.selectFollowed, required this.isFollowed});
  final Function(bool) selectFollowed;
  final bool isFollowed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ModernFilterChip(
              label: "Followed",
              isSelected: isFollowed,
              onSelected: () => selectFollowed(!isFollowed),
              icon: Icons.favorite,
            ),
          ],
        ),
      ),
    );
  }
}
