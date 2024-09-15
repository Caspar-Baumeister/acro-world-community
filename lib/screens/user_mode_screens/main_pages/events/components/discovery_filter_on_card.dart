import 'package:acroworld/components/datetime/date_time_service.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/routing/routes/page_routes/single_event_page_route.dart';
import 'package:acroworld/screens/user_mode_screens/main_pages/events/components/discovery_slider_card.dart';
import 'package:acroworld/screens/user_mode_screens/main_pages/events/components/event_card_image_section.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class DiscoveryFilterOnCard extends StatelessWidget {
  const DiscoveryFilterOnCard({super.key, required this.event});

  final ClassEvent event;

  @override
  Widget build(BuildContext context) {
    String? location = LocationParser.parseLocation(
        event.classModel?.country, event.classModel?.city);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).push(
        SingleEventPageRoute(classModel: event.classModel!, classEvent: event),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppBorders.smallRadius,
        ),
        height: AppDimensions.eventVerticalScrollCardHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Image
            Padding(
              padding: const EdgeInsets.only(
                  left: AppPaddings.small,
                  bottom: AppPaddings.small,
                  top: AppPaddings.small),
              child: EventCardImageSection(
                  imageUrl: event.classModel?.imageUrl,
                  isHighlighted: event.isHighlighted == true),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(AppPaddings.small),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.classModel?.name ?? "",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                letterSpacing: -0.5,
                              ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    location != null
                        ? Padding(
                            padding:
                                const EdgeInsets.only(top: AppPaddings.tiny),
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    letterSpacing: -0.5,
                                    height: 1.1,
                                  ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: AppPaddings.small),
                      child: Text(
                          DateTimeService.getDateString(
                              event.startDate, event.endDate),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: CustomColors.accentColor)
                              .copyWith(letterSpacing: -0.5)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
