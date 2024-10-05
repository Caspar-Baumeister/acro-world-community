import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class CreatorSettingsActionModal extends StatelessWidget {
  const CreatorSettingsActionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      child: Container(
        color: CustomColors.backgroundColor,
        child: Column(
          children: [
            ListTile(
              title: const Text("Edit"),
              leading: const Icon(Icons.edit),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Delete"),
              leading: const Icon(Icons.delete),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Bookings"),
              leading: const Icon(Icons.delete),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Occurences (for cancel classes)"),
              leading: const Icon(Icons.delete),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
