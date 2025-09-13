import 'package:acroworld/presentation/components/datetime/date_time_service.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pure UI event card component with no data logic or providers
class ResponsiveEventCard extends StatelessWidget {
  final String title;
  final String? location;
  final String? imageUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isHighlighted;
  final VoidCallback? onTap;
  final double? width;
  final bool isGridMode;
  final String? urlSlug;
  final String? eventId;

  const ResponsiveEventCard({
    super.key,
    required this.title,
    this.location,
    this.imageUrl,
    this.startDate,
    this.endDate,
    this.isHighlighted = false,
    this.onTap,
    this.width,
    this.isGridMode = false,
    this.urlSlug,
    this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate responsive width
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = width ??
        (isGridMode
            ? (screenWidth - 48) / 2.0
            : 160.0); // Reduced from 200 to 180 for smaller cards

    return GestureDetector(
      onTap: onTap ?? _handleCardTap(context),
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(
          right: isGridMode ? 0 : 12,
          bottom: isGridMode ? 12 : 0,
        ),
        decoration: BoxDecoration(
          color: isHighlighted
              ? colorScheme.primaryContainer.withOpacity(0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            SizedBox(
              height: cardWidth,
              child: _buildImageSection(context, colorScheme),
            ),
            // Content section
            Expanded(
              child: _buildContentSection(context, theme, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Stack(
        children: [
          // Main image
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImagePlaceholder(colorScheme);
                    },
                  )
                : _buildImagePlaceholder(colorScheme),
          ),
          // Highlight badge
          if (isHighlighted)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Highlight",
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.event,
        size: 32,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildContentSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final dateString = _formatDate();
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive font size based on screen width
    final baseFontSize = isGridMode ? 12.0 : 14.0;
    final responsiveFontSize = screenWidth < 360
        ? baseFontSize - 1.0 // Smaller screens
        : screenWidth > 400
            ? baseFontSize + 1.0 // Larger screens
            : baseFontSize;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title - Let it flow naturally
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              height: 1.2,
              fontSize: responsiveFontSize,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Location and Date - Let them flow naturally
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Locationc
              location != null && location!.isNotEmpty
                  ? Text(
                      location!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.1,
                        fontSize: responsiveFontSize - 1.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : const SizedBox(height: 15),

              const SizedBox(
                  height: 2), // Increased spacing between location and date
              // Date
              if (dateString.isNotEmpty)
                Text(
                  dateString,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: responsiveFontSize - 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate() {
    if (startDate == null) return '';

    try {
      return DateTimeService.getDateString(
        startDate!.toIso8601String(),
        endDate?.toIso8601String(),
      );
    } catch (e) {
      // Fallback to simple date formatting
      final start = startDate!;
      final end = endDate;

      if (end != null && start.day != end.day) {
        // Multi-day event
        return '${start.day}. ${_getMonthName(start.month)} - ${end.day}. ${_getMonthName(end.month)}';
      } else {
        // Single day event
        return '${start.day}. ${_getMonthName(start.month)} • ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
      }
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  VoidCallback? _handleCardTap(BuildContext context) {
    if (urlSlug != null && eventId != null) {
      return () {
        context.pushNamed(
          singleEventWrapperRoute,
          pathParameters: {"urlSlug": urlSlug!},
          queryParameters: {"event": eventId!},
        );
      };
    }
    return null;
  }
}
