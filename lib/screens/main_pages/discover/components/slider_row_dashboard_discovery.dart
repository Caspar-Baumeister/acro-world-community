import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/screens/main_pages/discover/components/discovery_slider_card.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class SliderRowDashboardDiscovery extends StatelessWidget {
  const SliderRowDashboardDiscovery(
      {super.key,
      required this.onViewAll,
      required this.header,
      required this.events,
      this.subHeader});

  final Function onViewAll;
  final String header;
  final String? subHeader;
  final List<ClassEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPaddings.medium),
          child: GestureDetector(
            onTap: () => onViewAll(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(header,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: AppPaddings.tiny),
                    subHeader != null
                        ? Text(subHeader!,
                            style: Theme.of(context).textTheme.bodyMedium)
                        : Container(),
                  ],
                ),
                Text(
                  "view all",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: CustomColors.linkTextColor),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: AppPaddings.small),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: AppPaddings.small,
              ),
              ...events.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(
                            vertical: AppPaddings.tiny,
                            horizontal: AppPaddings.small)
                        .copyWith(bottom: 0),
                    child: DiscoverySliderCard(classEvent: item),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
