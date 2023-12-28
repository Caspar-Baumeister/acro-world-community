import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/screens/home_screens/events/widgets/slider_card.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';

class SliderRowEventDashboard extends StatelessWidget {
  const SliderRowEventDashboard(
      {super.key,
      required this.onViewAll,
      required this.header,
      required this.events});

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
                  style: H20W6,
                ),
                Text(
                  "(view all)",
                  style: H14W4.copyWith(color: LINK_COLOR),
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
