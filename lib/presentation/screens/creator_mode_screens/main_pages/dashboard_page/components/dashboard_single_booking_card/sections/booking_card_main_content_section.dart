import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/theme/app_theme.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:flutter/material.dart';

class BookingCardMainContentSection extends StatelessWidget {
  const BookingCardMainContentSection({
    super.key,
    required this.booking,
    this.showBookingOption,
  });

  final ClassEventBooking booking;
  final bool? showBookingOption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingSmall,
          vertical: AppDimensions.spacingExtraSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(booking.user.name ?? "Unknown User",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: AppDimensions.spacingExtraSmall),
          if (showBookingOption != null && showBookingOption!)
            Text(
              "${booking.bookingOption?.title}",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          if (showBookingOption == null || !showBookingOption!)
            Text(
              "${booking.classEvent.classModel?.name ?? "Unknown Class"} \n- ${getDatedMMYY(booking.classEvent.startDateDT)}",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: AppDimensions.spacingSmall),
          Text(
            "Booked at:",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Text(
            getDatedMMHHmm(booking.createdAt),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary),
          )
        ],
      ),
    );
  }
}
