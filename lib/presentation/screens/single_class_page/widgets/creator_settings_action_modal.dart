import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/teacher_event_provider.dart';
import 'package:acroworld/routing/routes/page_routes/creator_page_routes.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatorSettingsActionModal extends StatelessWidget {
  const CreatorSettingsActionModal(
      {super.key,
      required this.classModel,
      required this.classEventId,
      required this.classEvent});

  final ClassModel classModel;
  final String? classEventId;
  final ClassEvent? classEvent;

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
                    .setClassFromExisting(classModel.urlSlug!, true);

                // Now pop the current widget and push the next page safely
                Navigator.of(context).pop();

                Navigator.of(context).push(CreateAndEditEventPageRoute(
                    isEditing: true, classModel: classModel));
              },
            ),
            ListTile(
              title: const Text("Bookings"),
              leading: const Icon(Icons.book_outlined),
              onTap: () {
                if (classEventId == null) {
                  Navigator.of(context).push(DashboardPageRoute());
                } else {
                  Navigator.of(context).push(ClassBookingSummaryPageRoute(
                      classEventId: classEventId!));
                }
              },
            ),
            ListTile(
              title:
                  Text(classEventId == null ? "Occurences" : "All Occurences"),
              leading: const Icon(Icons.calendar_view_month_sharp),
              onTap: () {
                Navigator.of(context)
                    .push(ClassOccurencePageRoute(classModel: classModel));
              },
            ),
            ListTile(
              title: Text("Delete",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: CustomColors.errorBorderColor)),
              leading: const Icon(
                Icons.delete,
                color: CustomColors.errorBorderColor,
              ),
              onTap: () {
                // Delete class

                // TODO implement protection if there are any bookings

                // Show modal
                buildMortal(context, DeleteClassModal(classModel: classModel));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteClassModal extends StatelessWidget {
  const DeleteClassModal({super.key, required this.classModel});

  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      child: Column(
        children: [
          // title
          Text("Delete ${classModel.name}"),
          const SizedBox(height: AppPaddings.large),
          // description
          Text(
            "Are you sure you want to delete this class? This will delete all occurences of this class and cannot be undone.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppPaddings.medium),
          // open bookings
          // TODO add open bookings
          // delete button
          StandardButton(
              text: "Delete",
              onPressed: () {
                try {
                  // Delete class
                  ClassesRepository(apiService: GraphQLClientSingleton())
                      .deleteClass(classModel.id!)
                      .then((value) {
                    if (value) {
                      showSuccessToast("Class deleted");

                      Provider.of<TeacherEventsProvider>(context, listen: false)
                          .fetchMyEvents(isRefresh: true);
                      Navigator.of(context).pushAndRemoveUntil(
                          MyEventsPageRoute(), (route) => false);
                    } else {
                      throw Exception("value not true");
                    }
                  });
                } catch (e, s) {
                  // Show error
                  CustomErrorHandler.captureException(e, stackTrace: s);
                  showErrorToast("Failed to delete class");
                }
              }),
        ],
      ),
    );
  }
}
