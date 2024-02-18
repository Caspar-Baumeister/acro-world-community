import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/screens/home_screens/events/get_my_teacher_query_wrapper.dart';
import 'package:acroworld/screens/home_screens/events/widgets/bookable_single_class_event_row.dart';
import 'package:acroworld/screens/home_screens/events/widgets/slider_row_event_dashboard.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class EventDashboardBody extends StatefulWidget {
  const EventDashboardBody({super.key});

  @override
  State<EventDashboardBody> createState() => _EventDashboardBodyState();
}

class _EventDashboardBodyState extends State<EventDashboardBody> {
  String? queryResult;

  @override
  Widget build(BuildContext context) {
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);

    List<EventModel> highlights = eventFilterProvider.activeEvents
        .where((element) => element.isHighlighted == true)
        .toList();

    // List<EventModel> bookable = eventFilterProvider.activeEvents
    //     .where((element) => element.pretixName != null)
    //     .toList();

    List<EventModel> festivalsAndCons = eventFilterProvider.activeEvents
        .where((element) => element.eventType == "FestivalsAndCons")
        .toList();

    List<EventModel> trainings = eventFilterProvider.activeEvents
        .where((element) => element.eventType == "Trainings")
        .toList();

    List<EventModel> retreats = eventFilterProvider.activeEvents
        .where((element) => element.eventType == "Retreats")
        .toList();

    List<EventModel> workshops = eventFilterProvider.activeEvents
        .where((element) => element.eventType == "Workshops")
        .toList();

    List<EventModel> upcoming = eventFilterProvider.activeEvents
        .where((element) =>
            DateTime.parse(element.startDate!)
                .difference(DateTime.now())
                .inDays <
            90)
        .toList();

    if (queryResult == "error") {
      return ErrorWidget("refetching the events trew an error");
    }

    return RefreshIndicator(
      onRefresh: () => refetchEvents(eventFilterProvider),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                  bottom: AppPaddings.large, top: AppPaddings.medium),
              child: BookableSingleClassEventRow(),
            ),
            highlights.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppPaddings.large, top: AppPaddings.medium),
                    child: SliderRowEventDashboard(
                      onViewAll: () => eventFilterProvider.changeHighlighted(),
                      header: "Highlights",
                      events: highlights,
                    ),
                  )
                : Container(),

            // bookable.isNotEmpty
            //     ? Padding(
            //         padding: const EdgeInsets.only(
            //             bottom: AppPaddings.large, top: AppPaddings.medium),
            //         child: SliderRowEventDashboard(
            //           onViewAll: () {
            //             eventFilterProvider.resetFilter();
            //             for (EventModel date in upcoming) {
            //               eventFilterProvider.tryAddingActiveEventDates(
            //                   DateTime.parse(date.startDate!));
            //             }
            //           },
            //           header: "Direct Booking",
            //           events: bookable,
            //         ),
            //       )
            //     : Container(),
            const GetMyTeacherQueryWrapper(),
            upcoming.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppPaddings.large, top: AppPaddings.medium),
                    child: SliderRowEventDashboard(
                      onViewAll: () {
                        eventFilterProvider.resetFilter();
                        for (EventModel date in upcoming) {
                          eventFilterProvider.tryAddingActiveEventDates(
                              DateTime.parse(date.startDate!));
                        }
                      },
                      header: "Upcoming",
                      events: upcoming,
                    ),
                  )
                : Container(),
            festivalsAndCons.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppPaddings.large, top: AppPaddings.medium),
                    child: SliderRowEventDashboard(
                      onViewAll: () => eventFilterProvider
                          .setActiveCategory(["FestivalsAndCons"]),
                      header: "Festivals and Cons",
                      events: festivalsAndCons,
                    ),
                  )
                : Container(),
            workshops.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppPaddings.large, top: AppPaddings.medium),
                    child: SliderRowEventDashboard(
                      onViewAll: () =>
                          eventFilterProvider.setActiveCategory(["Workshops"]),
                      header: "Workshops",
                      events: workshops,
                    ),
                  )
                : Container(),
            trainings.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppPaddings.large, top: AppPaddings.medium),
                    child: SliderRowEventDashboard(
                      onViewAll: () =>
                          eventFilterProvider.setActiveCategory(["Trainings"]),
                      header: "Trainings",
                      events: trainings,
                    ),
                  )
                : Container(),
            retreats.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppPaddings.large, top: AppPaddings.medium),
                    child: SliderRowEventDashboard(
                      onViewAll: () =>
                          eventFilterProvider.setActiveCategory(["Retreats"]),
                      header: "Retreat",
                      events: retreats,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  refetchEvents(
    EventFilterProvider eventFilterProvider,
  ) async {
    QueryResult? result = await GraphQLClientSingleton().query(QueryOptions(
        document: Queries.events,
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all));

    if (result.data?["events"] != null) {
      try {
        eventFilterProvider.setInitialData(result.data!["events"]);
      } catch (e) {
        print("error while refetching events: ${e.toString()}}");
        setState(() {
          queryResult = "error";
        });
      }

      // });
    } else {
      print("error while refetching events: $result");
      setState(() {
        queryResult = "error";
      });
    }
  }
}
