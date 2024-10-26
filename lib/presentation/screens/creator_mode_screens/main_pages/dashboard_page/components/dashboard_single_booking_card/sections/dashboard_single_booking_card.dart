import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/components/images/custom_cached_network_image.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/booking_status_tile.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class BookingCardImageSection extends StatelessWidget {
  const BookingCardImageSection({
    super.key,
    required this.booking,
  });

  final ClassEventBooking booking;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: AppBorders.smallRadius,
          child: CustomCachedNetworkImage(
            imageUrl: booking.classEvent.classModel?.imageUrl,
            width: BOOKING_CARD_HEIGHT,
          ),
        ),
        Positioned(
          //botom center
          bottom: 0,
          left: 0,
          right: 0,
          child: BookingStatusTile(booking: booking),
        )
      ],
    );
  }
}
