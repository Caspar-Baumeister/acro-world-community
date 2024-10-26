import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:flutter/material.dart';

class BookingCardMainContentSection extends StatelessWidget {
  const BookingCardMainContentSection({
    super.key,
    required this.booking,
  });

  final ClassEventBooking booking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppPaddings.small, vertical: AppPaddings.tiny),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(booking.user.name ?? "Unknown User",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppPaddings.tiny),
          Text(
            "${booking.classEvent.classModel?.name ?? "Unknown Class"} \n- ${getDatedMMYY(booking.classEvent.startDateDT)}",
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            "Booked at:",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Text(
            getDatedMMHHmm(booking.createdAt),
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: CustomColors.accentColor),
          )
        ],
      ),
    );
  }
}
