import 'package:acroworld/presentation/components/settings_drawer.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/profile_body.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    print("ProfilePage build");
    return BasePage(
      endDrawer: const SettingsDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: false,
        elevation: 0,
      ),
      makeScrollable: false,
      // bottomNavigationBar: const PrimaryBottomNavbar(selectedIndex: 3),
      child: const ProfileBody(),
    );
  }
}
