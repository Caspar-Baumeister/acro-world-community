import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';

class AppBarTeacher extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const AppBarTeacher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: const Text(
        "Teacher and organiser",
        style: GIGANTIC_TEXT_STYLE,
      ),
    );
  }
}
