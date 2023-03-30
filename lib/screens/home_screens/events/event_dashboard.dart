import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
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

    List<EventModel> highlights = testEvents
        .map((item) => EventModel.fromJson(item))
        .where((element) => element.isHighlight == true)
        .toList();

    List<EventModel> festivalsAndCons = testEvents
        .map((item) => EventModel.fromJson(item))
        .where((element) => element.eventType == "Festivals und Cons")
        .toList();

    List<EventModel> trainings = testEvents
        .map((item) => EventModel.fromJson(item))
        .where((element) => element.eventType == "Training")
        .toList();
    List<EventModel> retreats = testEvents
        .map((item) => EventModel.fromJson(item))
        .where((element) => element.eventType == "Retreats")
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
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SliderRowEventDashboard(
                    onViewAll: () => eventFilterProvider
                        .setActiveCategory(["Festivals und Cons"]),
                    header: "Highlights",
                    events: highlights,
                  ),
                )
              : Container(),
          festivalsAndCons.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SliderRowEventDashboard(
                    onViewAll: () => eventFilterProvider
                        .setActiveCategory(["Festivals und Cons"]),
                    header: "Festivals und Cons",
                    events: festivalsAndCons,
                  ),
                )
              : Container(),
          trainings.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SliderRowEventDashboard(
                    onViewAll: () =>
                        eventFilterProvider.setActiveCategory(["Training"]),
                    header: "Teacher Trainings",
                    events: trainings,
                  ),
                )
              : Container(),
          retreats.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
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
