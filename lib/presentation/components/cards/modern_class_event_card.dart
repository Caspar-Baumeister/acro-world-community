import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/images/custom_cached_network_image.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Modern class event card with square image design
class ModernClassEventCard extends StatelessWidget {
  final ClassModel classModel;
  final double? width;
  final VoidCallback? onTap;
  final bool isGridMode;

  const ModernClassEventCard({
    super.key,
    required this.classModel,
    this.width,
    this.onTap,
    this.isGridMode = false,
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
            : 160.0);

    return GestureDetector(
      onTap: onTap ?? _handleCardTap(context),
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(
          right: isGridMode ? 0 : 12,
          bottom: isGridMode ? 12 : 0,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
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
            child: classModel.imageUrl != null
                ? CustomCachedNetworkImage(
                    imageUrl: classModel.imageUrl!,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : _buildImagePlaceholder(colorScheme),
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
          // Title
          Text(
            classModel.name ?? "Untitled Event",
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
          // Location and Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Location
              _buildLocationText(theme, colorScheme, responsiveFontSize),
              const SizedBox(height: 2),
              // Date - Show next occurrence or "No upcoming events"
              _buildDateText(theme, colorScheme, responsiveFontSize),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationText(ThemeData theme, ColorScheme colorScheme, double fontSize) {
    final location = _parseLocation();
    
    if (location != null && location.isNotEmpty) {
      return Text(
        location,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          height: 1.1,
          fontSize: fontSize - 1.0,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      return const SizedBox(height: 15);
    }
  }

  Widget _buildDateText(ThemeData theme, ColorScheme colorScheme, double fontSize) {
    // For ClassModel, we don't have specific event dates, so we show a generic message
    // or we could show "View Details" or similar
    return Text(
      "View Details",
      style: theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w500,
        fontSize: fontSize - 1.0,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String? _parseLocation() {
    if (classModel.locationName != null && classModel.city != null) {
      return "${classModel.city}, ${classModel.locationName}";
    } else if (classModel.locationName != null) {
      return classModel.locationName;
    } else if (classModel.city != null) {
      return classModel.city;
    } else if (classModel.country != null) {
      return classModel.country;
    }
    return null;
  }

  VoidCallback? _handleCardTap(BuildContext context) {
    if (classModel.urlSlug != null) {
      return () {
        context.pushNamed(
          singleEventWrapperRoute,
          pathParameters: {"urlSlug": classModel.urlSlug!},
        );
      };
    }
    return null;
  }
}
