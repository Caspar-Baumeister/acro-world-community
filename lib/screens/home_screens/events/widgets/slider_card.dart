import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/screens/single_event/single_event_query_wrapper.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SliderCard extends StatelessWidget {
  const SliderCard({required this.event, Key? key}) : super(key: key);
  final EventModel event;

  @override
  Widget build(BuildContext context) {
    String endTimeString = "";
    String? dateString;

    if (event.endDate != null && event.startDate != null) {
      DateTime endDateTime = DateTime.parse(event.endDate!);
      DateTime startDateTime = DateTime.parse(event.startDate!);
      endTimeString = endDateTime.day.toString();
      if (endDateTime.month != startDateTime.month) {
        endTimeString =
            "${endDateTime.day} ${DateFormat.MMM().format(endDateTime)}";
      }
      if (startDateTime.day == endDateTime.day &&
          startDateTime.month == endDateTime.month &&
          startDateTime.year == endDateTime.year) {
        dateString = startDateTime.day.toString();
      }
    }

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
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SingleEventQueryWrapper(
            eventId: event.id!,
          ),
        ),
      ),
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            height: EVENT_DASHBOARD_SLIDER_HEIGHT,
            width: EVENT_DASHBOARD_SLIDER_WIDTH,
            decoration: BoxDecoration(
              color:
                  event.isHighlighted == true ? HIGHLIGHT_COLOR : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x90E8E8E8),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  // clipBehavior: Clip.antiAlias,
                  height: EVENT_DASHBOARD_SLIDER_HEIGHT * 0.6,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: event.mainImageUrl ??
                        "https://images.unsplash.com/photo-1629122558657-d5dc4c30ca60?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1771&q=80",
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
                  ),
                ),
                Container(
                  height: EVENT_DASHBOARD_SLIDER_HEIGHT * 0.4,
                  padding:
                      const EdgeInsets.all(8.0).copyWith(top: 20, bottom: 4),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.name ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: H16W7),
                      Expanded(
                        child: countryLocationString != null
                            ? Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(countryLocationString,
                                          maxLines: 2,
                                          overflow: TextOverflow.clip,
                                          style: H14W4),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          event.eventType != null
              ? Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Text(
                          capitalizeWords(event.eventType!
                              .replaceAllMapped(
                                  exp, (Match m) => (' ${m.group(0)}'))
                              .toLowerCase()),
                          style: H16W7,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          event.startDate != null
              ? Positioned(
                  top: EVENT_DASHBOARD_SLIDER_HEIGHT * 0.4,
                  left: 20,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 211, 211, 211),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            DateFormat.MMM()
                                .format(DateTime.parse(event.startDate!)),
                            style: H20W6,
                          ),
                          Text(
                            dateString ??
                                "${DateTime.parse(event.startDate!).day} - $endTimeString",
                            style: H18W4,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
