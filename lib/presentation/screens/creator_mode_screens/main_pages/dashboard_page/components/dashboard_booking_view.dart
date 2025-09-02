import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/dashboard_single_booking_card.dart';
import 'package:acroworld/provider/riverpod_provider/creator_bookings_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardBookingView extends ConsumerWidget {
  const DashboardBookingView({super.key, required this.bookings});

  final List<ClassEventBooking> bookings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
        itemCount: bookings.length + 1,
        itemBuilder: (context, index) {
          if (index == bookings.length) {
            final creatorBookingsState = ref.watch(creatorBookingsProvider);
            if (!creatorBookingsState.canFetchMore) {
              return Container();
            }
            return Padding(
              padding: const EdgeInsets.only(
                  left: AppDimensions.spacingMedium,
                  right: AppDimensions.spacingMedium,
                  top: AppDimensions.spacingMedium,
                  bottom: AppDimensions.spacingMedium),
              child: Center(
                child: ModernButton(
                    text: "Load more",
                    onPressed: () {
                      // fetch more bookings
                      ref.read(creatorBookingsProvider.notifier).fetchMore();
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
