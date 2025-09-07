import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/components/cards/modern_booking_card.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class ClassBookingSummaryBookingView extends StatelessWidget {
  const ClassBookingSummaryBookingView({
    super.key,
    required this.bookings,
  });

  final List<ClassEventBooking> bookings;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingMedium),
          child: ModernBookingCard(
            booking: booking,
            isClassBookingSummary: true,
            showBookingOption: true,
          ),
        );
      },
    );
  }
}
