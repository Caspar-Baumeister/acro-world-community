import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/profile_body.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    print("ProfilePage build");
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const ProfileBody(),
    );
  }
}
