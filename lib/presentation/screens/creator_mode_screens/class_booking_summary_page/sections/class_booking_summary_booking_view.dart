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
    return Column(
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
          child: Row(
            children: [
              Text(
                "Bookings",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                "${bookings.length} total",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Bookings list
        ...bookings.map((booking) => Padding(
          padding: const EdgeInsets.only(
            left: AppDimensions.spacingMedium,
            right: AppDimensions.spacingMedium,
            bottom: AppDimensions.spacingMedium,
          ),
          child: ModernBookingCard(
            booking: booking,
            isClassBookingSummary: true,
            showBookingOption: true,
          ),
        )).toList(),
      ],
    );
  }
}
