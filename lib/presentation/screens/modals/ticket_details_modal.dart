import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/buttons/link_button.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/overlays/status_overlay.dart';
import 'package:acroworld/presentation/components/send_feedback_button.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/share_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TicketDetailsModal extends ConsumerWidget {
  final UserBookingModel booking;

  const TicketDetailsModal({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userRiverpodProvider);
    final userId = userAsync.value?.id ?? 'unknown';

    // Create ClassEvent from UserBookingModel data
    final classEvent = ClassEvent(
      id: booking.classEventId,
      startDate: booking.startDate.toIso8601String(),
      endDate: booking.endDate.toIso8601String(),
    );

    // Create ClassModel from UserBookingModel data
    final classModel = ClassModel(
      id: booking.classId,
      name: booking.eventName,
      imageUrl: booking.eventImage,
      locationName: booking.locationName,
      urlSlug: booking.urlSlug,
      questions: [],
    );

    return BaseModal(
      noPadding: true,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Event image and status
              _buildImageSection(context),

              // Content area
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event details
                    _buildEventDetails(context),

                    const SizedBox(height: AppDimensions.spacingMedium),

                    // Status information
                    _buildStatusInfo(context),

                    const SizedBox(height: AppDimensions.spacingLarge),

                    // Action buttons
                    ModernButton(
                      text: "Share",
                      onPressed: () => shareEvent(classEvent, classModel),
                      isFilled: true,
                    ),

                    const SizedBox(height: AppDimensions.spacingSmall),

                    // Contact support
                    LinkButtonComponent(
                      text: "Problems? Contact support",
                      onPressed: () => showCupertinoModalPopup(
                        context: context,
                        builder: (context) => FeedbackPopUp(
                          subject:
                              'Problem with booking id:${booking.classEventId}, user:$userId',
                          title: "Booking problem",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          color: colorScheme.surfaceContainerHighest,
          child: booking.eventImage != null && booking.eventImage!.isNotEmpty
              ? Image.network(
                  booking.eventImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    color: colorScheme.onSurfaceVariant,
                    size: 48,
                  ),
                )
              : Icon(
                  Icons.event,
                  color: colorScheme.onSurfaceVariant,
                  size: 48,
                ),
        ),

        // Status overlay (consistent size/placement)
        Positioned(
          top: AppDimensions.spacingSmall,
          right: AppDimensions.spacingSmall,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 80),
            child: StatusOverlay(
              status: booking.status ?? "Unknown",
              isCompact: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Event Details",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        _buildDetailRow(
          context,
          icon: Icons.event,
          label: "Event",
          value: booking.eventName ?? "Unknown Event",
        ),
        if (booking.bookingTitle != null && booking.bookingTitle!.isNotEmpty)
          _buildDetailRow(
            context,
            icon: Icons.confirmation_number,
            label: "Booking Option",
            value: booking.bookingTitle!,
          ),
        _buildDetailRow(
          context,
          icon: Icons.access_time,
          label: "Date & Time",
          value: _formatDateRange(booking.startDate, booking.endDate),
        ),
        if (booking.locationName != null && booking.locationName!.isNotEmpty)
          _buildDetailRow(
            context,
            icon: Icons.location_on,
            label: "Location",
            value: booking.locationName!,
          ),
        _buildDetailRow(
          context,
          icon: Icons.calendar_today,
          label: "Booked On",
          value: _formatDate(booking.createdAt ?? booking.startDate),
        ),
      ],
    );
  }

  Widget _buildStatusInfo(BuildContext context) {
    final isPastBooking = booking.endDate.isBefore(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isPastBooking ? Icons.check_circle : Icons.schedule,
            color: isPastBooking
                ? Colors.green
                : Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppDimensions.spacingSmall),
          Expanded(
            child: Text(
              isPastBooking
                  ? "This event has already taken place"
                  : "This event is upcoming",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isPastBooking
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Widget? valueWidget,
    bool isMonospace = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppDimensions.spacingSmall),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Expanded(
            flex: 3,
            child: valueWidget ??
                Text(
                  value,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontFamily: isMonospace ? 'monospace' : null,
                      ),
                  textAlign: TextAlign.end,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDateRange(DateTime start, DateTime end) {
    if (start.day == end.day &&
        start.month == end.month &&
        start.year == end.year) {
      return '${DateFormat('EEEE, d MMM yyyy').format(start)} • ${DateFormat('h:mm a').format(start)} - ${DateFormat('h:mm a').format(end)}';
    } else {
      return '${DateFormat('d MMM').format(start)} - ${DateFormat('d MMM yyyy').format(end)}';
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }
}
