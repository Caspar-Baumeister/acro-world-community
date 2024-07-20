import 'package:acroworld/components/datetime/date_time_service.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/routing/routes/page_routes/single_event_page_route.dart';
import 'package:acroworld/screens/main_pages/events/components/event_card_image_section.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class DiscoverySliderCard extends StatelessWidget {
  const DiscoverySliderCard({required this.classEvent, super.key});
  final ClassEvent classEvent;

  @override
  Widget build(BuildContext context) {
    bool isHighlighted = classEvent.isHighlighted == true;
    String? imageUrl = classEvent.classModel?.imageUrl;
    String? location = LocationParser.parseLocation(
        classEvent.classModel?.country, classEvent.classModel?.city);
    return GestureDetector(
      onTap: () => classEvent.classModel != null
          ? Navigator.of(context).push(SingleEventPageRoute(
              classModel: classEvent.classModel!, classEvent: classEvent))
          : null,
      child: SizedBox(
        width: AppDimensions.eventDashboardSliderWidth,
        child: Column(
          children: [
            EventCardImageSection(
                imageUrl: imageUrl, isHighlighted: isHighlighted),
            AspectRatio(
              aspectRatio: AspectRatios.ar_6_5,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppPaddings.tiny),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classEvent.classModel?.name ?? "",
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
                              classEvent.startDate, classEvent.endDate),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: CustomColors.accentColor)
                              .copyWith(letterSpacing: -0.5)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationParser {
  // a function that takes the country and city and returns a string
  static String? parseLocation(String? country, String? city) {
    if (country != null && city != null) {
      return "$country, $city";
    } else if (country != null) {
      return country;
    } else if (city != null) {
      return city;
    } else {
      return null;
    }
  }
}
