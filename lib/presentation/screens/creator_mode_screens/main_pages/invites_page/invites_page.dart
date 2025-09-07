import 'package:acroworld/presentation/components/buttons/floating_action_button.dart';
import 'package:acroworld/presentation/components/custom_tab_view.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/sections/email_invitations_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/sections/event_invitations_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/modals/invite_by_email_modal.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

class InvitesPage extends StatefulWidget {
  const InvitesPage({super.key});

  @override
  State<InvitesPage> createState() => _InvitesPageState();
}

class _InvitesPageState extends State<InvitesPage> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Stack(
      children: [
        BasePage(
          makeScrollable: false,
          child: CustomTabView(
            tabTitles: ["Email Invitations", "Event Invitations"],
            tabViews: const [
              EmailInvitationsSection(),
              EventInvitationsSection(),
            ],
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
          ),
        ),
        // Floating Invite by Email Button - only show on "Email Invitations" tab (index 0)
        if (_currentTabIndex == 0)
          CustomFloatingActionButton(
            title: "Invite by Email",
            subtitle: "Send invitations to teachers",
            onPressed: () => buildMortal(context, const InviteByEmailModal()),
            backgroundColor: colorScheme.secondary,
            textColor: Colors.white,
          ),
      ],
    );
  }
}
