import 'package:flutter/material.dart';

class AppBarTeacher extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const AppBarTeacher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: const Text(
        "Teacher",
        style: TextStyle(color: Colors.black),
      ),
      // actions: const [
      //   Icon(
      //     Icons.search,
      //     color: Colors.black,
      //   ),
      //   Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 8.0),
      //     child: Icon(
      //       Icons.filter_list_outlined,
      //       color: Colors.black,
      //     ),
      //   )
      // ],
    );
  }
}
