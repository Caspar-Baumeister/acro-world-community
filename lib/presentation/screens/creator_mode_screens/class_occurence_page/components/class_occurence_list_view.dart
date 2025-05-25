import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_occurence_page/components/class_occurence_card.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ClassOccurenceListView extends StatefulWidget {
  const ClassOccurenceListView({
    super.key,
    required this.classEvents,
    required this.refetch,
  });

  final List<ClassEvent> classEvents;
  final VoidCallback refetch;

  @override
  State<ClassOccurenceListView> createState() => _ClassOccurenceListViewState();
}

class _ClassOccurenceListViewState extends State<ClassOccurenceListView> {
  @override
  void initState() {
    super.initState();
    // Listen to the specific refetch event
    Provider.of<EventBusProvider>(context, listen: false)
        .listenToRefetchEventHighlightsQuery((event) {
      _callRefetch();
      // Call your refetch logic here
    });
  }

  void _callRefetch() {
    try {
      print("Refetching class occurences");
      widget.refetch();
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.classEvents.isEmpty
          ? const Center(
              child: Text("No occurences found"),
            )
          : RefreshIndicator(
              onRefresh: () async {
                widget.refetch();
              },
              child: ListView.builder(
                  itemCount: widget.classEvents.length,
                  itemBuilder: (context, index) {
                    final classEvent = widget.classEvents[index];
                    return ClassOccurenceCard(
                      classEvent: classEvent,
                      onViewBookings: () {
                        context.pushNamed(
                          classBookingSummaryRoute,
                          pathParameters: {
                            'classEventId': classEvent.id!,
                          },
                        );
                      },
                      onCancel: () async {
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
                                        widget.refetch();
                                      });
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) async {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      });
                                    } catch (e, s) {
                                      CustomErrorHandler.captureException(e,
                                          stackTrace: s);
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) async {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      });
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
