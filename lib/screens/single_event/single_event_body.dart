import 'package:acroworld/components/map.dart';
import 'package:acroworld/components/open_google_maps.dart';
import 'package:acroworld/components/show_more_text.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/screens/home_screens/activities/components/class_teacher_chips.dart';
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
    return SingleChildScrollView(
        child: Column(
      children: [
        event.mainImageUrl != null
            ? CrawledWarningWidget(
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
              event.startDate != null && event.endDate != null
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
                            child: Text(
                                "${DateFormat.MMMMd().format(DateTime.parse(event.startDate!))} - ${DateFormat.MMMMd().format(DateTime.parse(event.endDate!))}",
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
              const SizedBox(height: 4),
              event.links != null && event.links!.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Links",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...event.links!.map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: LinkButton(text: e, link: e),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        event.pricing != null && event.pricing != ""
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Prices",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      event.pricing!,
                      textAlign: TextAlign.start,
                    )
                  ],
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
                                  "Venue",
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
                    (event.locationCountry != null &&
                                event.locationCountry != "") ||
                            (event.locationCity != null &&
                                event.locationCity != "") ||
                            (event.originLocationName != null &&
                                event.originLocationName != "")
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
                                  child: Text(
                                      (event.locationCountry != null &&
                                                  event.locationCountry !=
                                                      "") ||
                                              (event.locationCity != null &&
                                                  event.locationCity != "")
                                          ? "${event.locationCountry != null ? event.locationCountry! : ""} ${event.locationCountry != null && event.locationCity != null ? ", " : ""} ${event.locationCity != null ? event.locationCity! : ""}"
                                          : event.originLocationName.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.clip,
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
        event.teachers != null && event.teachers!.isNotEmpty
            ? Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Teacher:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    ClassTeacherChips(teacher: event.teachers!),
                  ],
                ),
              )
            : Container(),
      ],
    ));
  }

  // Future<Address> getCordinats(String? query) async {
  //   List<Address> addresses =
  //       await Geocoder.local.findAddressesFromQuery(query);
  //   return addresses.first;
  // }
}
