import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class BookingCardRevenueSection extends StatelessWidget {
  const BookingCardRevenueSection({
    super.key,
    required this.booking,
  });

  final ClassEventBooking booking;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingSmall),
        child: Text(
          booking.bookingPriceString,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
