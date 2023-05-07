import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/screens/home_screens/events/get_my_teacher_query_wrapper.dart';
import 'package:acroworld/screens/home_screens/events/widgets/carousel_slider_widget.dart';
import 'package:acroworld/screens/home_screens/events/widgets/slider_card.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDashboardBody extends StatelessWidget {
  const EventDashboardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);

    List<EventModel> highlights = eventFilterProvider.activeEvents
        .where((element) => element.isHighlighted == true)
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

    return SingleChildScrollView(
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
    );
  }
}

class SliderRowEventDashboard extends StatelessWidget {
  const SliderRowEventDashboard(
      {Key? key,
      required this.onViewAll,
      required this.header,
      required this.events})
      : super(key: key);

  final Function onViewAll;
  final String header;
  final List<EventModel> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () => onViewAll(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  header,
                  style: BIG_TEXT_STYLE,
                ),
                Text(
                  "(view all)",
                  style: STANDART_TEXT_STYLE.copyWith(color: LINK_COLOR),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: events.map((item) => SliderCard(event: item)).toList(),
          ),
        ),
      ],
    );
  }
}

List testSlider = [
  "https://images.unsplash.com/photo-1629122558657-d5dc4c30ca60?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1771&q=80",
  "https://images.unsplash.com/photo-1629122558657-d5dc4c30ca60?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1771&q=80",
  "https://images.unsplash.com/photo-1629122558657-d5dc4c30ca60?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1771&q=80"
];
