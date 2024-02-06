import 'package:acroworld/screens/home_screens/activities/components/class_event_tile_image.dart';
import 'package:acroworld/screens/home_screens/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/screens/single_class_page/single_class_query_wrapper.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserBookingsCard extends StatelessWidget {
  const UserBookingsCard({super.key, required this.userBooking});

  final UserBookingModel userBooking;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    print("status");
    print(userBooking.status);
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => userBooking.classId != null
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleEventQueryWrapper(
                            classEventId: userBooking.classEventId,
                            classId: userBooking.classId!,
                          )))
              : null,
          child: SizedBox(
            height: BOOKING_CARD_HEIGHT + 38,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card Image
                ClassEventTileImage(
                  width: screenWidth * 0.3,
                  isCancelled: false,
                  imgUrl: userBooking.eventImage,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8).copyWith(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userBooking.eventName ?? "Unknown Event",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: CARD_TITLE_TEXT),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            userBooking.bookingTitle ?? "Unknown Booking",
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

                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: userBooking.status == "Cancelled"
                                    ? WARNING_COLOR
                                    : userBooking.status == "Confirmed"
                                        ? SUCCESS_COLOR
                                        : userBooking.status == "Pending"
                                            ? DARK_GREY
                                            : userBooking.status == "Completed"
                                                ? SUCCESS_COLOR
                                                : DARK_GREY,
                                // rounded corners
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${userBooking.status}",
                                style: CARD_DESCRIPTION_TEXT.copyWith(
                                    color: Colors.white),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              userBooking.locationName ?? "More",
                              style: CARD_DESCRIPTION_TEXT,
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: PRIMARY_COLOR,
                              size: 15,
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
