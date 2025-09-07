import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/components/booking_category_chart.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/components/acro_level_chart.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class BookingSummaryCharts extends StatelessWidget {
  const BookingSummaryCharts({super.key, required this.bookings});

  final List<ClassEventBooking> bookings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingSmall),
      child: Row(
        children: [
          // Base flyer chart (booking categories)
          Expanded(
            child: BookingCategoryChart(bookings: bookings),
          ),
          const SizedBox(width: 16),
          // Acro level chart
          Expanded(
            child: AcroLevelChart(bookings: bookings),
          ),
        ],
      ),
    );
  }
}
