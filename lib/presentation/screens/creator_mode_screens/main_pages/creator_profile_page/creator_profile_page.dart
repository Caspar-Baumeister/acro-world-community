import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/bottom_navbar/creator_mode/creator_mode_primary_bottom_navbar.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/creator_profile_body.dart';
import 'package:flutter/material.dart';

class CreatorProfilePage extends StatelessWidget {
  const CreatorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      appBar: CustomAppbarSimple(
        title: "Creator Profile",
        isBackButton: false,
      ),
      makeScrollable: false,
      bottomNavigationBar: CreatorModePrimaryBottomNavbar(selectedIndex: 3),
      child: CreatorProfileBody(),
    );
  }
}
