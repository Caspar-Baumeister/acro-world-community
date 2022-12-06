import 'package:flutter/material.dart';

class StandardAppBar extends StatefulWidget implements PreferredSizeWidget {
  const StandardAppBar({Key? key, required this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;
  final String title;

  @override
  _StandardAppBarState createState() => _StandardAppBarState();
}

class _StandardAppBarState extends State<StandardAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(widget.title));
  }
}
