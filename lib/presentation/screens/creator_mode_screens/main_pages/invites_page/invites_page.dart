import 'package:acroworld/presentation/components/buttons/floating_action_button.dart';
import 'package:acroworld/presentation/components/custom_tab_view.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/sections/email_invitations_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/sections/event_invitations_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/modals/invite_by_email_modal.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

class InvitesPage extends StatelessWidget {
  const InvitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Stack(
      children: [
        const BasePage(
          makeScrollable: false,
          child: CustomTabView(
            tabTitles: ["Email Invitations", "Event Invitations"],
            tabViews: [
              EmailInvitationsSection(),
              EventInvitationsSection(),
            ],
          ),
        ),
        // Floating Invite by Email Button
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
