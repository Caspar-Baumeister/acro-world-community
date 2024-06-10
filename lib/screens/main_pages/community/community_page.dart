import 'package:acroworld/components/bottom_navbar/primary_bottom_navbar.dart';
import 'package:acroworld/screens/base_page.dart';
import 'package:acroworld/screens/main_pages/community/community_app_bar.dart';
import 'package:acroworld/screens/main_pages/community/community_query.dart';
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
      bottomNavigationBar: const PrimaryBottomNavbar(selectedIndex: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 8),
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
    // TODO: implement initState
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
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: !_isSelected ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: !_isSelected ? Colors.black : Colors.white),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              color: !_isSelected ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
