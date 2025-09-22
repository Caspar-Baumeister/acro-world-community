import 'package:acroworld/presentation/components/overlays/status_overlay.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailsModal extends StatefulWidget {
  final UserBookingModel booking;

  const TicketDetailsModal({
    super.key,
    required this.booking,
  });

  @override
  State<TicketDetailsModal> createState() => _TicketDetailsModalState();
}

class _TicketDetailsModalState extends State<TicketDetailsModal> {
  bool _showQRCode = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingMedium),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _showQRCode ? "QR Code" : "Ticket Details",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Content area
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.spacingLarge),
                child: _showQRCode
                    ? _buildQRCodeContent(context)
                    : _buildDetailsContent(context),
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingMedium),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Share functionality coming soon"),
                          ),
                        );
                      },
                      icon: const Icon(Icons.share),
                      label: const Text("Share"),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMedium),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showQRCode = !_showQRCode;
                        });
                      },
                      icon: Icon(_showQRCode ? Icons.info : Icons.qr_code),
                      label: Text(_showQRCode ? "Details" : "View QR"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event image and status
        _buildImageSection(context),

        const SizedBox(height: AppDimensions.spacingMedium),

        // Event details
        _buildEventDetails(context),

        const SizedBox(height: AppDimensions.spacingMedium),

        // Booking details
        _buildBookingDetails(context),

        const SizedBox(height: AppDimensions.spacingMedium),

        // Status information
        _buildStatusInfo(context),
      ],
    );
  }

  Widget _buildQRCodeContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Event image
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Container(
            height: 150,
            width: double.infinity,
            color: colorScheme.surfaceContainerHighest,
            child: widget.booking.eventImage != null &&
                    widget.booking.eventImage!.isNotEmpty
                ? Image.network(
                    widget.booking.eventImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      color: colorScheme.onSurfaceVariant,
                      size: 64,
                    ),
                  )
                : Icon(
                    Icons.event,
                    color: colorScheme.onSurfaceVariant,
                    size: 64,
                  ),
          ),
        ),

        const SizedBox(height: AppDimensions.spacingLarge),

        // QR Code
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
          ),
          child: QrImageView(
            data: widget.booking.classEventId ?? "unknown-booking-id",
            version: QrVersions.auto,
            size: 200.0,
            backgroundColor: Colors.white,
          ),
        ),

        const SizedBox(height: AppDimensions.spacingMedium),

        // QR Code info
        Text(
          "Booking ID",
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingSmall),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Text(
            widget.booking.classEventId ?? "Unknown",
            style: textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              color: colorScheme.onSurface,
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spacingMedium),

        Text(
          "Show this QR code at the event entrance for easy check-in.",
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLarge),
          ),
          child: Container(
            height: 200,
            width: double.infinity,
            color: colorScheme.surfaceContainerHighest,
            child: widget.booking.eventImage != null &&
                    widget.booking.eventImage!.isNotEmpty
                ? Image.network(
                    widget.booking.eventImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      color: colorScheme.onSurfaceVariant,
                      size: 64,
                    ),
                  )
                : Icon(
                    Icons.event,
                    color: colorScheme.onSurfaceVariant,
                    size: 64,
                  ),
          ),
        ),

        // Status overlay (consistent size/placement)
        Positioned(
          top: AppDimensions.spacingMedium,
          right: AppDimensions.spacingMedium,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 92),
            child: StatusOverlay(
              status: widget.booking.status ?? "Unknown",
              isCompact: false,
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
          value: widget.booking.eventName ?? "Unknown Event",
        ),
        if (widget.booking.bookingTitle != null &&
            widget.booking.bookingTitle!.isNotEmpty)
          _buildDetailRow(
            context,
            icon: Icons.confirmation_number,
            label: "Booking Option",
            value: widget.booking.bookingTitle!,
          ),
        _buildDetailRow(
          context,
          icon: Icons.access_time,
          label: "Date & Time",
          value: _formatDateRange(
              widget.booking.startDate, widget.booking.endDate),
        ),
        if (widget.booking.locationName != null &&
            widget.booking.locationName!.isNotEmpty)
          _buildDetailRow(
            context,
            icon: Icons.location_on,
            label: "Location",
            value: widget.booking.locationName!,
          ),
      ],
    );
  }

  Widget _buildBookingDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Booking Details",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        _buildDetailRow(
          context,
          icon: Icons.confirmation_number,
          label: "Booking ID",
          value: widget.booking.classEventId ?? "Unknown",
          isMonospace: true,
        ),
        _buildDetailRow(
          context,
          icon: Icons.calendar_today,
          label: "Booked On",
          value:
              _formatDate(widget.booking.createdAt ?? widget.booking.startDate),
        ),
        _buildDetailRow(
          context,
          icon: Icons.info,
          label: "Status",
          value: widget.booking.status ?? "Unknown",
        ),
      ],
    );
  }

  Widget _buildStatusInfo(BuildContext context) {
    final isPastBooking = widget.booking.endDate.isBefore(DateTime.now());

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
      padding:
          const EdgeInsets.symmetric(vertical: AppDimensions.spacingExtraSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppDimensions.spacingSmall),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: valueWidget ??
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
