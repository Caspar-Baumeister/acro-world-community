import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/screens/single_class_page/single_class_page.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassEventSliderCard extends StatelessWidget {
  const ClassEventSliderCard({required this.classEvent, super.key});
  final ClassEvent classEvent;

  @override
  Widget build(BuildContext context) {
    String endTimeString = "";
    String? dateString;

    if (classEvent.endDate != null && classEvent.startDate != null) {
      DateTime endDateTime = DateTime.parse(classEvent.endDate!);
      DateTime startDateTime = DateTime.parse(classEvent.startDate!);
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
    if (classEvent.classModel?.locationName != null &&
        classEvent.classModel?.locationName != "") {
      countryLocationString = classEvent.classModel!.locationName.toString();
    }
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SingleClassPage(
            classEvent: classEvent,
            clas: classEvent.classModel!,
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                SizedBox(
                  // clipBehavior: Clip.antiAlias,
                  height: EVENT_DASHBOARD_SLIDER_HEIGHT * 0.55,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: classEvent.classModel?.imageUrl ??
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
                  height: EVENT_DASHBOARD_SLIDER_HEIGHT * 0.45,
                  padding:
                      const EdgeInsets.all(8.0).copyWith(top: 20, bottom: 4),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(classEvent.classModel?.name ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge),
                      Expanded(
                        child: countryLocationString != null
                            ? Container(
                                padding: const EdgeInsets.only(top: 5),
                                alignment: Alignment.topLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 3.0),
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
                                      fit: FlexFit.tight,
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          classEvent.startDate != null
              ? Positioned(
                  top: EVENT_DASHBOARD_SLIDER_HEIGHT * 0.35,
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
                                .format(DateTime.parse(classEvent.startDate!)),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            dateString ??
                                "${DateTime.parse(classEvent.startDate!).day} - $endTimeString",
                            style: Theme.of(context).textTheme.headlineSmall,
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
