import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/invites_body.dart';
import 'package:flutter/material.dart';

class InvitesPage extends StatelessWidget {
  const InvitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(makeScrollable: false, child: InvitesBody());
  }
}
