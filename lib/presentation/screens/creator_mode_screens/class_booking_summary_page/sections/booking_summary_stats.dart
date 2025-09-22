import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class BookingSummaryStats extends StatelessWidget {
  const BookingSummaryStats({super.key, required this.bookings});

  final List<ClassEventBooking> bookings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate stats
    final totalBookings = bookings.length;
    final totalRevenue = bookings.fold<double>(
        0, (sum, booking) => sum + (booking.bookingOption?.price ?? 0));
    final confirmedBookings =
        bookings.where((b) => b.status == "Confirmed").length;
    final waitingBookings =
        bookings.where((b) => b.status == "WaitingForPayment").length;

    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              context,
              "Total Bookings",
              totalBookings.toString(),
              Icons.people,
              colorScheme.primary,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: colorScheme.outline.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              "Total Revenue",
              "${(totalRevenue / 100).toStringAsFixed(2)}€",
              Icons.euro,
              Colors.green,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: colorScheme.outline.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              "Confirmed",
              confirmedBookings.toString(),
              Icons.check_circle,
              Colors.green,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: colorScheme.outline.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              "Waiting",
              waitingBookings.toString(),
              Icons.schedule,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
