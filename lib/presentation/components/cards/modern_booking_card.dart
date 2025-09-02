import 'package:flutter/material.dart';

/// Modern booking card component with consistent styling
class ModernBookingCard extends StatelessWidget {
  final String name;
  final String eventTitle;
  final String eventDate;
  final String bookedAt;
  final String price;
  final String? imageUrl;
  final BookingStatus status;
  final VoidCallback? onTap;

  const ModernBookingCard({
    super.key,
    required this.name,
    required this.eventTitle,
    required this.eventDate,
    required this.bookedAt,
    required this.price,
    this.imageUrl,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Image and status section
                _buildImageSection(colorScheme),
                const SizedBox(width: 16),
                // Content section
                Expanded(
                  child: _buildContentSection(theme, colorScheme),
                ),
                // Price section
                _buildPriceSection(theme, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(ColorScheme colorScheme) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
            color: imageUrl == null ? colorScheme.surfaceContainerHighest : null,
          ),
          child: imageUrl == null
              ? Icon(
                  Icons.event,
                  size: 32,
                  color: colorScheme.onSurfaceVariant,
                )
              : null,
        ),
        // Status badge
        Positioned(
          bottom: 4,
          left: 4,
          child: _buildStatusBadge(colorScheme),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(ColorScheme colorScheme) {
    Color backgroundColor;
    Color textColor;
    
    switch (status) {
      case BookingStatus.waitingForPayment:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      case BookingStatus.confirmed:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case BookingStatus.cancelled:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        break;
      case BookingStatus.pending:
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContentSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Event title
        Text(
          eventTitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Event date
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              eventDate,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        // Booked at
        Row(
          children: [
            Icon(
              Icons.bookmark,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              bookedAt,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          price,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}

/// Booking status enum
enum BookingStatus {
  waitingForPayment,
  confirmed,
  cancelled,
  pending;

  String get displayName {
    switch (this) {
      case BookingStatus.waitingForPayment:
        return 'Waiting for Payment';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.pending:
        return 'Pending';
    }
  }
}
