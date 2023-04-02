import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/screens/single_event/single_event_page.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventFilterOnCard extends StatelessWidget {
  const EventFilterOnCard({Key? key, required this.event}) : super(key: key);

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SingleEventPage(
            event: event,
          ),
        ),
      ),
      child: SizedBox(
        height: CLASS_CARD_HEIGHT,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Image
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
                )),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.name ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: HEADER_1_TEXT_STYLE),
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
                                    "${DateFormat.MMMMd().format(DateTime.parse(event.startDate!))} - ${DateFormat.MMMMd().format(DateTime.parse(event.endDate!))}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: STANDART_TEXT_STYLE),
                              )
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 10),
                    event.location != null
                        ? Row(
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
                                    event.locationCountry != null &&
                                            event.locationCountry != "" &&
                                            event.locationCity != null &&
                                            event.locationCity != ""
                                        ? ("${event.locationCountry!}, ${event.locationCity!}")
                                        : event.locationCountry.toString() +
                                            event.locationCity.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                    style: STANDART_TEXT_STYLE),
                              ),
                            ],
                          )
                        : Container(),
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
