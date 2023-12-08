import 'package:acroworld/screens/home_screens/activities/components/class_event_tile_image.dart';
import 'package:acroworld/screens/home_screens/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/screens/single_class_page/single_class_query_wrapper.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserBookingsCard extends StatelessWidget {
  const UserBookingsCard({Key? key, required this.userBooking})
      : super(key: key);

  final UserBookingModel userBooking;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleEventQueryWrapper(
                        classEventId: userBooking.classEventId,
                        classId: userBooking.classId,
                      ))),
          child: SizedBox(
            height: BOOKING_CARD_HEIGHT,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card Image
                ClassEventTileImage(
                  width: screenWidth * 0.25,
                  isCancelled: false,
                  imgUrl: userBooking.eventImage,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userBooking.eventName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: CARD_TITLE_TEXT),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            userBooking.bookingTitle,
                            style: CARD_DESCRIPTION_TEXT,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              // the startdate of the event in the format of Mo. 2.3.23 at 12:00 - 13:00

                              Text(
                                  DateFormat("E. dd.MM.yy")
                                      .format(userBooking.startDate),
                                  style: CARD_DESCRIPTION_TEXT),

                              const Spacer(),
                              Text(
                                  "${DateFormat("HH:mm").format(userBooking.startDate)} - ${DateFormat('HH:mm').format(userBooking.endDate)}",
                                  style: CARD_DESCRIPTION_TEXT),
                            ],
                          ),
                        ),
                        // in the right corner the status of the booking
                        const Spacer(),
                        Row(
                          children: [
                            // location icon and location name
                            const Icon(
                              Icons.location_on,
                              color: PRIMARY_COLOR,
                              size: 15,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              userBooking.locationName ??
                                  "Click to see location",
                              style: CARD_DESCRIPTION_TEXT,
                            ),

                            const Spacer(),
                            Text(
                              "Status: ${userBooking.status}",
                              style: CARD_DESCRIPTION_TEXT,
                            ),
                            // the price of the booking
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Divider(
          endIndent: screenWidth * 0.05,
          indent: screenWidth * 0.05,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
