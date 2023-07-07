import 'package:acroworld/graphql/fragments.dart';
import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/events/get_my_teacher_query_wrapper.dart';
import 'package:acroworld/screens/home_screens/events/widgets/carousel_slider_widget.dart';
import 'package:acroworld/screens/home_screens/events/widgets/slider_row_event_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDashboardBody extends StatefulWidget {
  const EventDashboardBody({Key? key}) : super(key: key);

  @override
  State<EventDashboardBody> createState() => _EventDashboardBodyState();
}

class _EventDashboardBodyState extends State<EventDashboardBody> {
  String? queryResult;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);

    List<EventModel> highlights = eventFilterProvider.activeEvents
        .where((element) => element.isHighlighted == true)
        .toList();

    List<EventModel> bookable = eventFilterProvider.activeEvents
        .where((element) => element.pretixName != null)
        .toList();

    List<EventModel> festivalsAndCons = eventFilterProvider.activeEvents
        .where((element) => element.eventType == "FestivalsAndCons")
        .toList();

    List<EventModel> trainings = eventFilterProvider.activeEvents
        .where((element) => element.eventType == "Trainings")
        .toList();

    List<EventModel> retreats = eventFilterProvider.activeEvents
        .where((element) => element.eventType == "Retreats")
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
      onRefresh: () => refetchEvents(eventFilterProvider, userProvider.token),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10).copyWith(bottom: 4),
                child: CarouselSliderWidget(
                  sliders: eventFilterProvider.eventPoster,
                  isDots: false,
                )),
            highlights.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SliderRowEventDashboard(
                      onViewAll: () => eventFilterProvider.changeHighlighted(),
                      header: "Highlights",
                      events: highlights,
                    ),
                  )
                : Container(),
            bookable.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SliderRowEventDashboard(
                      onViewAll: () {
                        eventFilterProvider.resetFilter();
                        for (EventModel date in upcoming) {
                          eventFilterProvider.tryAddingActiveEventDates(
                              DateTime.parse(date.startDate!));
                        }
                      },
                      header: "Discount via AcroWorld",
                      events: bookable,
                    ),
                  )
                : Container(),
            const GetMyTeacherQueryWrapper(),
            upcoming.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 20),
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
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SliderRowEventDashboard(
                      onViewAll: () => eventFilterProvider
                          .setActiveCategory(["FestivalsAndCons"]),
                      header: "Festivals and Cons",
                      events: festivalsAndCons,
                    ),
                  )
                : Container(),
            trainings.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 20),
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
                    padding: const EdgeInsets.only(bottom: 20),
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

  refetchEvents(EventFilterProvider eventFilterProvider, String? token) async {
    if (token == null) {
      return;
    }
    final result = await Database(token: token).authorizedApi("""query Events {
  events (where: {confirmation_status: {_eq: Confirmed}}){
     ${Fragments.eventFragment}
  }
}""");

    if (result?["data"]?["events"] != null) {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      eventFilterProvider.setInitialData(result!["data"]!["events"]);
      // });
    } else {
      setState(() {
        queryResult = "error";
      });
    }
  }
}
