import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/booking_status_tile.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/classes/class_event_tile_image.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UserBookingsCard extends StatelessWidget {
  const UserBookingsCard({super.key, required this.userBooking});

  final UserBookingModel userBooking;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () =>
              userBooking.classId != null || userBooking.urlSlug != null
                  ? context.goNamed(
                      singleEventWrapperRoute,
                      pathParameters: {
                        "urlSlug": userBooking.urlSlug ?? "",
                      },
                      queryParameters: {
                        "event": userBooking.classEventId ?? "",
                      },
                    )
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
                            style: Theme.of(context).textTheme.titleLarge),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            userBooking.bookingTitle ?? "Unknown Booking",
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              // the startdate of the event in the format of Mo. 2.3.23 at 12:00 - 13:00

                              Text(
                                  DateFormat("E. dd.MM.yy")
                                      .format(userBooking.startDate),
                                  style:
                                      Theme.of(context).textTheme.titleMedium!),

                              const Spacer(),
                              Text(
                                  "${DateFormat("HH:mm").format(userBooking.startDate)} - ${DateFormat('HH:mm').format(userBooking.endDate)}",
                                  style:
                                      Theme.of(context).textTheme.titleMedium!),
                            ],
                          ),
                        ),
                        // in the right corner the status of the booking
                        const Spacer(),
                        Row(
                          children: [
                            // location icon and location name

                            BookingStatusTile(
                              bookingStatus: userBooking.status ?? "Unknown",
                              bookingStatusText:
                                  userBooking.status ?? "Unknown Status",
                            ),
                            const Spacer(),
                            Text(
                              userBooking.locationName ?? "More",
                              style: Theme.of(context).textTheme.bodyMedium!,
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: CustomColors.primaryColor,
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
      ],
    );
  }
}
