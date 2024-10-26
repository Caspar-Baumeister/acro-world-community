import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class BookingStatusTile extends StatelessWidget {
  const BookingStatusTile({
    super.key,
    required this.booking,
  });

  final ClassEventBooking booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppPaddings.small, vertical: AppPaddings.tiny),
      margin: const EdgeInsets.all(AppPaddings.tiny),
      decoration: BoxDecoration(
        color: booking.status == "Cancelled"
            ? CustomColors.errorTextColor
            : booking.status == "Confirmed"
                ? CustomColors.successTextColor
                : booking.status == "Pending"
                    ? DARK_GREY
                    : booking.status == "Completed"
                        ? CustomColors.successTextColor
                        : DARK_GREY,
        // rounded corners
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          booking.status,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
