import 'package:flutter/material.dart';

class AllCommunitiesAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const AllCommunitiesAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: const Text("Join a new community",
          style: TextStyle(color: Colors.black)),
      leading: const BackButton(color: Colors.black),
    );
  }
}
