import 'package:flutter/material.dart';

class AWCommunityAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AWCommunityAppBar({Key? key, required this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0
  final String title;

  @override
  _AWCommunityAppBarState createState() => _AWCommunityAppBarState();
}

class _AWCommunityAppBarState extends State<AWCommunityAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(widget.title));
  }
}
