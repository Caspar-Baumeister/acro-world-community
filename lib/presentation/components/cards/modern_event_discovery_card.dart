import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/datetime/date_time_service.dart';
import 'package:acroworld/presentation/components/images/custom_cached_network_image.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Modern event discovery card with landscape aspect ratio and theme-based styling
class ModernEventDiscoveryCard extends StatelessWidget {
  final ClassEvent classEvent;
  final double? width;
  final VoidCallback? onTap;

  const ModernEventDiscoveryCard({
    super.key,
    required this.classEvent,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final bool isHighlighted = classEvent.isHighlighted == true;
    final String? imageUrl = classEvent.classModel?.imageUrl;
    final String? location = _parseLocation(
      classEvent.classModel?.country, 
      classEvent.classModel?.city,
    );
    final String eventName = classEvent.classModel?.name ?? "";
    final String dateString = DateTimeService.getDateString(
      classEvent.startDate, 
      classEvent.endDate,
    );

    return GestureDetector(
      onTap: onTap ?? () => _navigateToEvent(context),
      child: Container(
        width: width ?? 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isHighlighted
                ? BorderSide(color: colorScheme.primary, width: 2)
                : BorderSide.none,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section with landscape aspect ratio
              Expanded(
                flex: 3,
                child: _buildImageSection(context, imageUrl, isHighlighted),
              ),
              // Content section
              Expanded(
                flex: 2,
                child: _buildContentSection(
                  context,
                  eventName,
                  location,
                  dateString,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, String? imageUrl, bool isHighlighted) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: Stack(
        children: [
          // Main image with landscape aspect ratio
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: imageUrl != null
                ? CustomCachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.event,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
          ),
          // Highlight badge
          if (isHighlighted)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Highlight",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContentSection(
    BuildContext context,
    String eventName,
    String? location,
    String dateString,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event name
          Expanded(
            child: Text(
              eventName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          // Location
          if (location != null)
            Text(
              location,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 4),
          // Date
          Text(
            dateString,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _navigateToEvent(BuildContext context) {
    if (classEvent.classModel?.urlSlug != null && classEvent.id != null) {
      context.pushNamed(
        singleEventWrapperRoute,
        pathParameters: {
          "urlSlug": classEvent.classModel!.urlSlug!,
        },
        queryParameters: {
          "event": classEvent.id!,
        },
      );
    }
  }

  String? _parseLocation(String? country, String? city) {
    if (country != null && city != null) {
      return "$city, $country";
    } else if (country != null) {
      return country;
    } else if (city != null) {
      return city;
    } else {
      return null;
    }
  }
}
