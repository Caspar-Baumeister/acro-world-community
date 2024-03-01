import 'package:flutter/material.dart';

class StandardAppBar extends StatefulWidget implements PreferredSizeWidget {
  const StandardAppBar({super.key, required this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;
  final String title;

  @override
  StandardAppBarState createState() => StandardAppBarState();
}

class StandardAppBarState extends State<StandardAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
    );
  }
}
