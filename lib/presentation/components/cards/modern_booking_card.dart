import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/modals/dashboard_booking_information_modal.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

class ModernBookingCard extends StatelessWidget {
  final ClassEventBooking booking;
  final bool isClassBookingSummary;
  final bool? showBookingOption;

  const ModernBookingCard({
    super.key,
    required this.booking,
    this.isClassBookingSummary = false,
    this.showBookingOption,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return GestureDetector(
      onTap: () => _showBookingDetails(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event image with status badge
              _buildImageSection(context, colorScheme),
              const SizedBox(width: 12),
              // Main content
              Expanded(
                child: _buildContentSection(context, theme, colorScheme),
              ),
              // Price section
              _buildPriceSection(context, theme, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, ColorScheme colorScheme) {
    return Stack(
      children: [
        // Event image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 80,
            height: 80,
            color: colorScheme.surfaceContainerHighest,
            child: booking.classEvent.classModel?.imageUrl != null
                ? Image.network(
                    booking.classEvent.classModel!.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(colorScheme),
                  )
                : _buildImagePlaceholder(colorScheme),
          ),
        ),
        // Status badge
        Positioned(
          top: 4,
          right: 4,
          child: _buildStatusBadge(context, colorScheme),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.event,
        color: colorScheme.onSurfaceVariant,
        size: 32,
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, ColorScheme colorScheme) {
    final status = booking.status;
    final isConfirmed = status == "Confirmed";
    final isWaiting = status == "WaitingForPayment";
    
    Color badgeColor;
    String badgeText;
    
    if (isConfirmed) {
      badgeColor = Colors.green;
      badgeText = "Confirmed";
    } else if (isWaiting) {
      badgeColor = Colors.orange;
      badgeText = "Waiting";
    } else {
      badgeColor = Colors.red;
      badgeText = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        badgeText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Person name
        Text(
          booking.user.name ?? "Unknown User",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Event name and date
        Text(
          "${booking.classEvent.classModel?.name ?? "Unknown Event"} - ${getDatedMMYY(booking.classEvent.startDateDT)}",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        // Booking date
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              "Booked: ${getDatedMMHHmm(booking.createdAt)}",
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          booking.bookingPriceString,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ],
    );
  }

  void _showBookingDetails(BuildContext context) {
    buildMortal(
      context,
      DashboardBookingInformationModal(
        booking: booking,
        isClassBookingSummary: isClassBookingSummary,
      ),
    );
  }
}