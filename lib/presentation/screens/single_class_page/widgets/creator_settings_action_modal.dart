import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatorSettingsActionModal extends StatelessWidget {
  const CreatorSettingsActionModal({super.key, required this.classModel});

  final ClassModel classModel;

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
              onTap: () async {
                // Perform the asynchronous operation
                await Provider.of<EventCreationAndEditingProvider>(context,
                        listen: false)
                    .setClassFromExisting(classModel.urlSlug!);

                // Now pop the current widget and push the next page safely
                Navigator.of(context).pop();

                Navigator.of(context).push(CreateAndEditEventPageRoute(
                    isEditing: true, classModel: classModel));
              },
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
