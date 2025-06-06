import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/state/provider/invites_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InviteByEmailModal extends StatelessWidget {
  const InviteByEmailModal({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return BaseModal(
      title: "Invite by Email",
      child: Column(
        children: [
          const SizedBox(height: AppPaddings.medium),
          const Text("Enter the email of the user you want to invite"),
          const SizedBox(height: AppPaddings.medium),
          InputFieldComponent(
            controller: emailController,
            labelText: "Email",
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppPaddings.medium),
          StandartButton(
            text: "Invite",
            onPressed: () async {
              if (emailController.text.isNotEmpty) {
                InvitesProvider invitesProvider =
                    Provider.of<InvitesProvider>(context, listen: false);
                await invitesProvider.inviteByEmail(emailController.text);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
