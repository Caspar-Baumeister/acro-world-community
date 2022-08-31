import 'package:acroworld/screens/buddy/buddy_body.dart';
import 'package:acroworld/screens/buddy/buddy_app_bar.dart';
import 'package:flutter/material.dart';

class BuddyPage extends StatelessWidget {
  const BuddyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarBuddy(),
      body: BuddyBody(),
    );
  }
}
