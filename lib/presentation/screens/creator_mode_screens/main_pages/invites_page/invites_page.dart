import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/bottom_navbar/creator_mode/creator_mode_primary_bottom_navbar.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:flutter/material.dart';

class InvitesPage extends StatelessWidget {
  const InvitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
        appBar: const CustomAppbarSimple(
          title: "Invites",
          isBackButton: false,
        ),
        makeScrollable: false,
        bottomNavigationBar:
            const CreatorModePrimaryBottomNavbar(selectedIndex: 2),
        child: Container());
  }
}