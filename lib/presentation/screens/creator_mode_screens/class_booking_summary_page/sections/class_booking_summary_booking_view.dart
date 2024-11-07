import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/dashboard_single_booking_card.dart';
import 'package:acroworld/utils/constants.dart';
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
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Padding(
          padding: const EdgeInsets.only(
              left: AppPaddings.medium,
              right: AppPaddings.medium,
              top: AppPaddings.medium),
          child: DashboardSingleBookingCard(
              booking: booking, isClassBookingSummary: true),
        );
      },
    );
  }
}
