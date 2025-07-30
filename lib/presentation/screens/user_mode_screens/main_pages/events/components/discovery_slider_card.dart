import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/datetime/date_time_service.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/event_card_image_section.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      onTap: () =>
          classEvent.classModel?.urlSlug != null && classEvent.id != null
              ? context.pushNamed(
                  singleEventWrapperRoute,
                  pathParameters: {
                    "urlSlug": classEvent.classModel!.urlSlug!,
                  },
                  queryParameters: {
                    "event": classEvent.id!,
                  },
                )
              : null,
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            EventCardImageSection(
                imageUrl: imageUrl, isHighlighted: isHighlighted),
            AspectRatio(
              aspectRatio: 7/5,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingExtraSmall),
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
                                const EdgeInsets.only(top: AppDimensions.spacingExtraSmall),
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
                      padding: const EdgeInsets.only(top: AppDimensions.spacingSmall),
                      child: Text(
                          DateTimeService.getDateString(
                              classEvent.startDate, classEvent.endDate),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Theme.of(context).colorScheme.primary)
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
      return "$city, $country";
    } else if (country != null) {
      return country;
    } else if (city != null) {
      return city;
    } else {
      return null;
    }
  }
}
