import 'package:acroworld/presentation/components/cards/responsive_event_card.dart';
import 'package:acroworld/presentation/components/loading/shimmer_skeleton.dart';
import 'package:flutter/material.dart';

/// Pure UI component for displaying events in different layouts
class ResponsiveEventList extends StatelessWidget {
  final List<EventCardData> events;
  final bool isGridMode;
  final VoidCallback? onEventTap;
  final double? cardWidth;
  final bool isLoading;

  const ResponsiveEventList({
    super.key,
    required this.events,
    this.isGridMode = false,
    this.onEventTap,
    this.cardWidth,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ResponsiveEventListSkeleton(
        isGridMode: isGridMode,
        itemCount: isGridMode ? 6 : 3,
      );
    }

    if (events.isEmpty) {
      return _buildEmptyState(context);
    }

    if (isGridMode) {
      return _buildGridLayout(context);
    } else {
      return _buildHorizontalLayout(context);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          "No events available",
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalLayout(BuildContext context) {
    return SizedBox(
      height: 250, // Increased from 220 to match card height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final eventData = events[index];
          return ResponsiveEventCard(
            title: eventData.title,
            location: eventData.location,
            imageUrl: eventData.imageUrl,
            startDate: eventData.startDate,
            endDate: eventData.endDate,
            isHighlighted: eventData.isHighlighted,
            onTap: onEventTap,
            width: cardWidth,
            isGridMode: false,
            urlSlug: eventData.urlSlug,
            eventId: eventData.eventId,
          );
        },
      ),
    );
  }

  Widget _buildGridLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(), // Allow scrolling
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final eventData = events[index];
          return ResponsiveEventCard(
            title: eventData.title,
            location: eventData.location,
            imageUrl: eventData.imageUrl,
            startDate: eventData.startDate,
            endDate: eventData.endDate,
            isHighlighted: eventData.isHighlighted,
            onTap: onEventTap,
            isGridMode: true,
            urlSlug: eventData.urlSlug,
            eventId: eventData.eventId,
          );
        },
      ),
    );
  }
}

/// Data class for event card information (no business logic)
class EventCardData {
  final String title;
  final String? location;
  final String? imageUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isHighlighted;
  final String? urlSlug;
  final String? eventId;

  const EventCardData({
    required this.title,
    this.location,
    this.imageUrl,
    this.startDate,
    this.endDate,
    this.isHighlighted = false,
    this.urlSlug,
    this.eventId,
  });

  factory EventCardData.fromClassEvent(dynamic classEvent) {
    final location = _parseLocation(
      classEvent.classModel?.country,
      classEvent.classModel?.city,
    );
    
    return EventCardData(
      title: classEvent.classModel?.name ?? "Unknown Event",
      location: location,
      imageUrl: classEvent.classModel?.imageUrl,
      startDate: classEvent.startDate != null 
          ? DateTime.tryParse(classEvent.startDate!) 
          : null,
      endDate: classEvent.endDate != null 
          ? DateTime.tryParse(classEvent.endDate!) 
          : null,
      isHighlighted: classEvent.isHighlighted == true,
      urlSlug: classEvent.classModel?.urlSlug,
      eventId: classEvent.id,
    );
  }

  static String? _parseLocation(String? country, String? city) {
    // Clean up the strings by removing extra whitespace
    final cleanCountry = country?.trim();
    final cleanCity = city?.trim();
    
    if (cleanCountry != null && cleanCountry.isNotEmpty && 
        cleanCity != null && cleanCity.isNotEmpty) {
      return "$cleanCity, $cleanCountry";
    } else if (cleanCountry != null && cleanCountry.isNotEmpty) {
      return cleanCountry;
    } else if (cleanCity != null && cleanCity.isNotEmpty) {
      return cleanCity;
    } else {
      return null;
    }
  }
}
