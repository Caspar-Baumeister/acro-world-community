import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/screens/main_pages/events/widgets/slider_card.dart';
import 'package:acroworld/utils/colors.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () => onViewAll(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(header, style: Theme.of(context).textTheme.headlineMedium),
                Text(
                  "view all",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: CustomColors.linkTextColor),
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
