import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/booking_card_main_content_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/booking_card_revenue_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/dashboard_single_booking_card.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/modals/dashboard_booking_information_modal.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

class DashboardSingleBookingCard extends StatelessWidget {
  const DashboardSingleBookingCard({
    super.key,
    required this.booking,
    this.isClassBookingSummary = false,
    this.showBookingOption,
  });

  final ClassEventBooking booking;
  final bool isClassBookingSummary;
  final bool? showBookingOption;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // open modal with booking details
        buildMortal(
            context,
            DashboardBookingInformationModal(
                booking: booking,
                isClassBookingSummary: isClassBookingSummary));
      },
      child: SizedBox(
        height: BOOKING_CARD_HEIGHT,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // image with round corners
            BookingCardImageSection(booking: booking),
            Expanded(
              child: BookingCardMainContentSection(
                  booking: booking, showBookingOption: showBookingOption),
            ),
            BookingCardRevenueSection(booking: booking),
          ],
        ),
      ),
    );
  }
}
