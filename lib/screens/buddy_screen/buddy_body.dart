import 'package:acroworld/shared/widgets/comming_soon_widget.dart';
import 'package:flutter/material.dart';

class BuddyBody extends StatelessWidget {
  const BuddyBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CommingSoon(
        header: "What is the buddy finder?",
        content:
            "The buddy finder will let you discover other acrobats from all over the world that are also looking for a new trainings and play buddy. All of this will be based on the location that you are in. You will be able to discover and select the right fit for you based on the experience level, preferences and other characteristics.");
  }
}
