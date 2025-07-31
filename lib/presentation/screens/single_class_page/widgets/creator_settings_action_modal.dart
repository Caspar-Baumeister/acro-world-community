import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/teacher_event_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/routing/routes/page_routes/creator_page_routes.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/theme/app_theme.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider;

class CreatorSettingsActionModal extends ConsumerWidget {
  const CreatorSettingsActionModal(
      {super.key,
      required this.classModel,
      required this.classEventId,
      required this.classEvent});

  final ClassModel classModel;
  final String? classEventId;
  final ClassEvent? classEvent;

  @override
  Widget build(BuildContext context, ref) {
    final userAsync = ref.watch(userRiverpodProvider);
    return BaseModal(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            ListTile(
              title: const Text("Edit"),
              leading: Icon(Icons.edit, color: Theme.of(context).iconTheme.color),
              onTap: () async {
                // Perform the asynchronous operation
                await provider.Provider.of<EventCreationAndEditingProvider>(
                        context,
                        listen: false)
                    .setClassFromExisting(classModel.urlSlug!, true, false);

                // Now pop the current widget and push the next page safely
                Navigator.of(context).pop();
                // use widgetsbinding to push the next page

                context.pushNamed(createEditEventRoute,
                    queryParameters: {'isEditing': 'true'});
              },
            ),
            ListTile(
              title: const Text("Bookings"),
              leading: Icon(Icons.book_outlined, color: Theme.of(context).iconTheme.color),
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
              leading: Icon(Icons.calendar_view_month_sharp, color: Theme.of(context).iconTheme.color),
              onTap: () {
                Navigator.of(context)
                    .push(ClassOccurencePageRoute(classModel: classModel));
              },
            ),
            if (classModel.amountActiveFlaggs != null &&
                classModel.amountActiveFlaggs! > 0)
              ListTile(
                title: Text("Resolve flags",
                    style: Theme.of(context).textTheme.bodyMedium),
                leading: Icon(
                  Icons.flag_circle_outlined, color: Theme.of(context).iconTheme.color,
                ),
                onTap: () {
                  if (userAsync.value == null) {
                    showErrorToast("User not found");
                    return;
                  }
                  // Show modal
                  _showFlagDialog(context, userAsync.value!.id!);
                },
              ),
            ListTile(
              title: Text("Delete",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.error)),
              leading: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
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

  void _showFlagDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingMedium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.flag_circle_outlined,
                    color: Theme.of(context).colorScheme.error, size: AppDimensions.iconSizeDialog),
                const SizedBox(height: AppDimensions.spacingMedium),
                Text(
                  "Resolve Flags",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: AppDimensions.spacingSmall),
                Text(
                  "Flags help the community keep the platform updated. If a class gets 5 or more active flags, it will be removed.",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                ),
                const SizedBox(height: AppDimensions.spacingSmall),
                Text(
                  "Are you sure, that this class is still happening and you want to resolve the flags?",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                ),
                const SizedBox(height: AppDimensions.spacingMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Close",
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                    ),
                    StandartButton(
                      text: "Resolve Flags",
                      width: MediaQuery.of(context).size.width * 0.3,
                      isFilled: true,
                      onPressed: () {
                        // Resolve flags
                        ClassesRepository(apiService: GraphQLClientSingleton())
                            .resolveAllClassFlags(classModel.id!)
                            .then((value) {
                          if (value) {
                            showSuccessToast("Flags resolved, reload page");
                            provider.Provider.of<TeacherEventsProvider>(context,
                                    listen: false)
                                .fetchMyEvents(userId, isRefresh: true);
                            Navigator.of(context).pop();
                          } else {
                            throw Exception("value not true");
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DeleteClassModal extends ConsumerWidget {
  const DeleteClassModal({super.key, required this.classModel});

  final ClassModel classModel;

  @override
  Widget build(BuildContext context, ref) {
    final userAsync = ref.watch(userRiverpodProvider);
    return BaseModal(
      child: Column(
        children: [
          // title
          Text("Delete ${classModel.name}", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppDimensions.spacingLarge),
          // description
          Text(
            "Are you sure you want to delete this class? This will delete all occurences of this class and cannot be undone.",
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          // open bookings
          // TODO add open bookings
          // delete button
          StandartButton(
              text: "Delete",
              onPressed: () {
                try {
                  // Delete class
                  ClassesRepository(apiService: GraphQLClientSingleton())
                      .deleteClass(classModel.id!)
                      .then((value) {
                    if (value) {
                      showSuccessToast("Class deleted");
                      if (userAsync.value == null) {
                        showErrorToast("User not found");
                        return;
                      }

                      provider.Provider.of<TeacherEventsProvider>(context,
                              listen: false)
                          .fetchMyEvents(userAsync.value!.id!, isRefresh: true);
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MyEventsPageRoute(), (route) => false);
                      context.replaceNamed(myEventsRoute);
                    } else {
                      throw Exception("value not true");
                    }
                  });
                } catch (e, s) {
                  // Show error
                  CustomErrorHandler.captureException(e, stackTrace: s);
                  showErrorToast("Failed to delete class");
                }
              }, isFilled: true, buttonFillColor: Theme.of(context).colorScheme.error,)
        ],
      ),
    );
  }
}
