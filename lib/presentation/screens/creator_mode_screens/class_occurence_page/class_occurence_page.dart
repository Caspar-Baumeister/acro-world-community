import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/loading_widget.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/routing/routes/page_routes/creator_page_routes.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';

class ClassOccurencePage extends StatelessWidget {
  const ClassOccurencePage({super.key, required this.classModel});

  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
    return BasePage(
        appBar: CustomAppbarSimple(
          title: "${classModel.name} Occurences",
          isBackButton: true,
        ),
        makeScrollable: false,
        child: ClassOccurenceBody(classModel: classModel));
  }
}

//class occurence body
class ClassOccurenceBody extends StatefulWidget {
  const ClassOccurenceBody({super.key, required this.classModel});

  final ClassModel classModel;

  @override
  State<ClassOccurenceBody> createState() => _ClassOccurenceBodyState();
}

class _ClassOccurenceBodyState extends State<ClassOccurenceBody> {
  // switch value for upcoming and past events
  bool showPastEvents = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // switch between upcoming and past events
        Padding(
          padding: const EdgeInsets.only(
              left: AppPaddings.large,
              top: AppPaddings.small,
              right: AppPaddings.large),
          child: Row(
            children: [
              Switch(
                value: showPastEvents,
                onChanged: (value) {
                  setState(() {
                    showPastEvents = value;
                  });
                },
                activeTrackColor: CustomColors.successBgColorSec,
                activeColor: CustomColors.successBgColor,
                inactiveTrackColor: CustomColors.secondaryBackgroundColor,
                inactiveThumbColor: CustomColors.iconColor,
              ),
              SizedBox(width: AppPaddings.small),
              Text(
                "show also past events",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),

        // list of occurences
        FutureBuilder<List<ClassEvent>>(
          future: ClassesRepository(apiService: GraphQLClientSingleton())
              .getUpcomingClassEventsById(
                  widget.classModel.id!, showPastEvents),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            } else if (snapshot.hasError) {
              CustomErrorHandler.captureException(snapshot.error!,
                  stackTrace: snapshot.stackTrace);
              return ErrorWidget(snapshot.error!);
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Expanded(
                child: const Center(
                  child: Text("No occurences found"),
                ),
              );
            } else {
              return Expanded(
                  child: ClassOccurenceListView(
                      classEvents: snapshot.data!,
                      refetch: () {
                        setState(() {});
                      }));
            }
          },
        ),
      ],
    );
  }
}

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

class ClassOccurenceCard extends StatelessWidget {
  const ClassOccurenceCard({
    super.key,
    required this.classEvent,
    required this.onCancel,
    required this.onViewBookings,
  });

  final ClassEvent classEvent;
  final VoidCallback onCancel;
  final VoidCallback onViewBookings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getFormattedDateRange(
                    classEvent.startDateDT, classEvent.endDateDT),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              classEvent.isCancelled == true
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: const Text(
                        "Canceled",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onViewBookings,
                    child: Text(
                      'View Bookings',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: classEvent.isCancelled == true
                        ? () => showInfoToast(
                            "Already canceled. You cannot undo this action.")
                        : onCancel,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: classEvent.isCancelled == true
                              ? Colors.grey
                              : Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
