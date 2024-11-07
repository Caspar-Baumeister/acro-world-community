import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/dashboard_single_booking_card.dart';
import 'package:acroworld/state/provider/creator_bookings_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardBookingView extends StatelessWidget {
  const DashboardBookingView({super.key, required this.bookings});

  final List<ClassEventBooking> bookings;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: bookings.length + 1,
        itemBuilder: (context, index) {
          if (index == bookings.length) {
            if (!Provider.of<CreatorBookingsProvider>(context).canFetchMore) {
              return Container();
            }
            return Padding(
              padding: const EdgeInsets.only(
                  left: AppPaddings.medium,
                  right: AppPaddings.medium,
                  top: AppPaddings.medium,
                  bottom: AppPaddings.medium),
              child: Center(
                child: StandardButton(
                    text: "Load more",
                    onPressed: () {
                      // fetch more bookings
                      Provider.of<CreatorBookingsProvider>(context,
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
                left: AppPaddings.medium,
                right: AppPaddings.medium,
                top: AppPaddings.medium),
            child: DashboardSingleBookingCard(booking: booking),
          );
        });
  }
}
