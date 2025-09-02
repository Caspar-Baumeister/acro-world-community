import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/dashboard_single_booking_card.dart';
import 'package:acroworld/state/provider/creator_bookings_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // TODO: Migrate to Riverpod

class DashboardBookingView extends StatelessWidget {
  const DashboardBookingView({super.key, required this.bookings});

  final List<ClassEventBooking> bookings;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: bookings.length + 1,
        itemBuilder: (context, index) {
          if (index == bookings.length) {
            // TODO: Migrate CreatorBookingsProvider to Riverpod
            // if (!Provider.of<CreatorBookingsProvider>(context).canFetchMore) {
            if (false) { // Temporarily disabled
              return Container();
            }
            return Padding(
              padding: const EdgeInsets.only(
                  left: AppDimensions.spacingMedium,
                  right: AppDimensions.spacingMedium,
                  top: AppDimensions.spacingMedium,
                  bottom: AppDimensions.spacingMedium),
              child: Center(
                child: StandartButton(
                    text: "Load more",
                    onPressed: () {
                      // fetch more bookings
                      // TODO: Migrate CreatorBookingsProvider to Riverpod
                      // Provider.of<CreatorBookingsProvider>(context,
                              listen: false)
                          .fetchMore();
                    }),
              ),
            );
          }
          ClassEventBooking booking = bookings[index];
          // add load more button
          return Padding(
            padding: const EdgeInsets.only(
                left: AppDimensions.spacingMedium,
                right: AppDimensions.spacingMedium,
                top: AppDimensions.spacingMedium),
            child: DashboardSingleBookingCard(booking: booking),
          );
        });
  }
}
