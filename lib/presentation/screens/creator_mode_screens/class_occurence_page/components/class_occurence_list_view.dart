import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_occurence_page/components/class_occurence_card.dart';
import 'package:acroworld/routing/routes/page_routes/creator_page_routes.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';

class ClassOccurenceListView extends StatelessWidget {
  const ClassOccurenceListView({
    super.key,
    required this.classEvents,
    required this.refetch,
  });

  final List<ClassEvent> classEvents;
  final VoidCallback refetch;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: classEvents.isEmpty
          ? const Center(
              child: Text("No occurences found"),
            )
          : RefreshIndicator(
              onRefresh: () async {
                refetch();
              },
              child: ListView.builder(
                  itemCount: classEvents.length,
                  itemBuilder: (context, index) {
                    final classEvent = classEvents[index];
                    return ClassOccurenceCard(
                      classEvent: classEvent,
                      onViewBookings: () {
                        Navigator.of(context).push(ClassBookingSummaryPageRoute(
                            classEventId: classEvent.id!));
                      },
                      onCancel: () {
                        // cancel class event
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Cancel Event"),
                              content: const Text(
                                  "Are you sure you want to cancel this event?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await ClassesRepository(
                                              apiService:
                                                  GraphQLClientSingleton())
                                          .cancelClassEvent(classEvent.id!)
                                          .then((value) {
                                        // Toast
                                        if (value) {
                                          showSuccessToast("Event cancelled");
                                        } else {
                                          showErrorToast(
                                              "Failed to cancel event");
                                        }
                                        refetch();
                                      });

                                      Navigator.of(context).pop();
                                    } catch (e, s) {
                                      CustomErrorHandler.captureException(e,
                                          stackTrace: s);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }),
            ),
    );
  }
}
