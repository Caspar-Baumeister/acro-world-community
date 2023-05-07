import 'package:acroworld/components/map.dart';
import 'package:acroworld/components/open_google_maps.dart';
import 'package:acroworld/components/show_more_text.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes/class_teacher_chips.dart';
import 'package:acroworld/screens/home_screens/events/widgets/crawled_warning_widget.dart';
import 'package:acroworld/screens/single_class_page/widgets/link_button.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class SingleEventBody extends StatelessWidget {
  const SingleEventBody({
    Key? key,
    required this.event,
  }) : super(key: key);

  final EventModel event;

  @override
  Widget build(BuildContext context) {
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
    } else if (event.originLocationName != null &&
        event.originLocationName != "") {
      countryLocationString = event.originLocationName.toString();
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
      children: [
        event.mainImageUrl != null
            ? CrawledWarningWidget(
                showWarning: event.eventSource == "Crawled",
                child: SizedBox(
                  height: 200.0,
                  width: double.infinity,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 52.0,
                      placeholder: (context, url) => Container(
                        color: Colors.black12,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.black12,
                        child: const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                      imageUrl: event.mainImageUrl!,
                    ),
                  ),
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              dateString != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Center(
                            child: Icon(
                              Icons.access_time_outlined,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(dateString,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: HEADER_2_TEXT_STYLE),
                          )
                        ],
                      ),
                    )
                  : Container(),
              event.description != null && event.description != ""
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: DescriptionTextWidget(
                        text: event.description!,
                        isHeader: true,
                      ),
                    )
                  : Container(),
              const SizedBox(height: 10),
              event.pricing != null && event.pricing != ""
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Pricing",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          DescriptionTextWidget(
                            text: event.pricing!,
                            isHeader: false,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              const SizedBox(height: 4),
              event.url != null && event.url != ""
                  ? Column(
                      children: [
                        Center(
                          child: LinkButton(
                              text: "Further information and booking",
                              link: event.url!),
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Teacher:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        ClassTeacherChips(classTeacherList: event.teachers!),
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
        (event.location?.coordinates?[0] != null &&
                    event.location?.coordinates?[1] != null) ||
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
                    event.location?.coordinates?[0] != null &&
                            event.location?.coordinates?[1] != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Location",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                OpenGoogleMaps(
                                  latitude:
                                      event.location!.coordinates![1] * 1.0,
                                  longitude:
                                      event.location!.coordinates![0] * 1.0,
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
                                      style: STANDART_TEXT_STYLE),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    event.location?.coordinates?[0] != null &&
                            event.location?.coordinates?[1] != null
                        ? Container(
                            padding: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            constraints: const BoxConstraints(maxHeight: 150),
                            child: MapWidget(
                              zoom: event.eventSource == "Crawled" ? 5 : 15.0,
                              center: LatLng(
                                  event.location!.coordinates![1] * 1.0,
                                  event.location!.coordinates![0] * 1.0),
                              markerLocation: event.eventSource == "Crawled"
                                  ? null
                                  : LatLng(
                                      event.location!.coordinates![1] * 1.0,
                                      event.location!.coordinates![0] * 1.0),
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 10),
                    const Divider(),
                  ],
                ),
              )
            : Container(),
        const SizedBox(height: 40)
      ],
    ));
  }
}
