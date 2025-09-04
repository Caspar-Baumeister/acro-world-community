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
  String search = "";
  bool isFollowed = false;

  setSearch(String newSearch) {
    setState(() {
      search = newSearch;
    });
  }

  setFollowed(bool newFollowed) {
    setState(() {
      isFollowed = newFollowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: TeacherAppBar(onSearchChanged: setSearch),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: AppDimensions.spacingSmall,
                top: AppDimensions.spacingSmall),
            child: FilterRow(
              selectFollowed: setFollowed,
              isFollowed: isFollowed,
            ),
          ),
          TeacherQuery(
            search: search,
            isFollowed: isFollowed,
          )
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
    return SingleChildScrollView(
      child: Row(
        children: [
          FilterBubble(
              label: "Followed",
              onTap: selectFollowed,
              initialValue: isFollowed)
        ],
      ),
    );
  }
}

class FilterBubble extends StatefulWidget {
  final String label;
  final Function(bool) onTap;
  final bool initialValue;

  const FilterBubble(
      {super.key,
      required this.label,
      required this.onTap,
      required this.initialValue});

  @override
  FilterBubbleState createState() => FilterBubbleState();
}

class FilterBubbleState extends State<FilterBubble> {
  late bool _isSelected;

  @override
  void initState() {
    _isSelected = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await widget.onTap(!_isSelected);
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Container(
        margin:
            const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSmall),
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMedium,
            vertical: AppDimensions.spacingSmall),
        decoration: BoxDecoration(
          color: !_isSelected
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
              color: !_isSelected
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.surface),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              color: !_isSelected
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }
}
