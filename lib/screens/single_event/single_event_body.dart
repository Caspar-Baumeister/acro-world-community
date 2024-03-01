import 'package:acroworld/components/buttons/link_button.dart';
import 'package:acroworld/components/custom_divider.dart';
import 'package:acroworld/components/open_google_maps.dart';
import 'package:acroworld/components/open_map.dart';
import 'package:acroworld/components/show_more_text.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes/class_teacher_chips.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleEventBody extends StatelessWidget {
  const SingleEventBody({
    super.key,
    required this.event,
  });

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    double? latitude = event.location?.coordinates?[1].toDouble();
    double? longitude = event.location?.coordinates?[0].toDouble();

    String? countryLocationString;
    if ((event.locationCountry != null && event.locationCountry != "") ||
        (event.locationCity != null && event.locationCity != "")) {
      countryLocationString = "";

      if (event.locationCountry != null && event.locationCountry != "") {
        countryLocationString += event.locationCountry.toString();
      }
      if ((event.locationCountry != null && event.locationCountry != "") &&
          (event.locationCity != null && event.locationCity != "")) {
        countryLocationString += ", ";
      }
      if (event.locationCity != null && event.locationCity != "") {
        countryLocationString += event.locationCity.toString();
      }
    }

    String? dateString;
    if (event.startDate != null && event.endDate != null) {
      final start = DateTime.parse(event.startDate!);
      final end = DateTime.parse(event.endDate!);
      if (start.day == end.day &&
          start.month == end.month &&
          start.year == end.year) {
        dateString =
            DateFormat.MMMMd().format(DateTime.parse(event.startDate!));
      } else {
        dateString =
            "${DateFormat.MMMMd().format(DateTime.parse(event.startDate!))} - ${DateFormat.MMMMd().format(DateTime.parse(event.endDate!))}";
      }
    }
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.name ?? "",
                  maxLines: 3,
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 20),
              dateString != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Center(
                              child: Icon(
                                Icons.access_time_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(dateString,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall),
                            )
                          ],
                        ),
                        const CustomDivider()
                      ],
                    )
                  : Container(),
              event.description != null && event.description != ""
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DescriptionTextWidget(
                          text: event.description!,
                          isHeader: true,
                        ),
                        const CustomDivider()
                      ],
                    )
                  : Container(),
              event.pricing != null && event.pricing != ""
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pricing",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        DescriptionTextWidget(
                          text: event.pricing!,
                          isHeader: false,
                        ),
                        const CustomDivider()
                      ],
                    )
                  : Container(),
              event.url != null && event.url != ""
                  ? Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppPaddings.small),
                            child: LinkButtonComponent(
                                text: "Official website",
                                onPressed: () async =>
                                    await customLaunch(event.url!)),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        event.teachers != null && event.teachers!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Teacher",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppPaddings.small),
                      ClassTeacherChips(classTeacherList: event.teachers!),
                    ],
                  ),
                ),
              )
            : Container(),
        (longitude != null && latitude != null) ||
                (event.locationCountry != null &&
                    event.locationCountry != "") ||
                (event.locationCity != null && event.locationCity != "") ||
                (event.originLocationName != null &&
                    event.originLocationName != "")
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    longitude != null && latitude != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Location",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                OpenGoogleMaps(
                                  latitude: latitude * 1.0,
                                  longitude: longitude * 1.0,
                                )
                              ],
                            ),
                          )
                        : Container(),
                    countryLocationString != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Center(
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Text(countryLocationString,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    longitude != null && latitude != null
                        ? Container(
                            padding: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            constraints: const BoxConstraints(maxHeight: 150),
                            child: OpenMap(
                              latitude: latitude,
                              longitude: longitude,
                              initialZoom: 9,
                            ),
                          )
                        : Container(),
                  ],
                ),
              )
            : Container(),
        const SizedBox(height: 10)
      ],
    ));
  }
}
