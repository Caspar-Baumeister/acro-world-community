import 'package:acroworld/components/bottom_navbar/primary_bottom_navbar.dart';
import 'package:acroworld/components/settings_drawer.dart';
import 'package:acroworld/screens/base_page.dart';
import 'package:acroworld/screens/user_mode_screens/main_pages/profile/profile_body.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: const PrimaryBottomNavbar(selectedIndex: 3),
      child: const ProfileBody(),
    );
  }
}
