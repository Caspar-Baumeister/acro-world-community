import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/screens/single_event/single_event_query_wrapper.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventFilterOnCard extends StatelessWidget {
  const EventFilterOnCard({super.key, required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');

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
        "${DateFormat.MMMMd().format(DateTime.parse(event.startDate!))} - ${DateFormat.MMMMd().format(DateTime.parse(event.endDate!))}";
      }
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SingleEventQueryWrapper(
            eventId: event.id!,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: event.isHighlighted == true
              ? CustomColors.highlightedColor
              : Colors.white,
          border: Border.all(
            color: CustomColors.highlightedColor,
            width: 1,
          ),
        ),
        height: CLASS_CARD_HEIGHT,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Image
            Stack(
              children: [
                SizedBox(
                  width: screenWidth * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      width: screenWidth * 0.3,
                      height: CLASS_CARD_HEIGHT,
                      fit: BoxFit.cover,
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
                      imageUrl: event.mainImageUrl ??
                          "https://images.unsplash.com/photo-1629122558657-d5dc4c30ca60?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1771&q=80",
                    ),
                  ),
                ),
                event.eventType != null
                    ? Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0, vertical: 3),
                              child: Text(
                                capitalizeWords(event.eventType!
                                    .replaceAllMapped(
                                        exp, (Match m) => (' ${m.group(0)}'))
                                    .toLowerCase()),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Text(event.name ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    const SizedBox(height: 6),
                    event.startDate != null && event.endDate != null
                        ? Row(
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
                                    dateString ??
                                        "${DateFormat.MMMMd().format(DateTime.parse(event.startDate!))} - ${DateFormat.MMMMd().format(DateTime.parse(event.endDate!))}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              )
                            ],
                          )
                        : Container(),
                    // there is either a origin name or a city or a country named
                    countryLocationString != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 7.0),
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
                                      overflow: TextOverflow.clip,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    event.pretixName != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: CustomColors.successTextColor,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("book with AcroWorld",
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          )
                        : Container()
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
