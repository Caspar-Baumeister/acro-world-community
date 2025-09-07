// lib/provider/riverpod_provider/bookings_providers.dart

import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/data/repositories/bookings_repository.dart';
import 'package:acroworld/presentation/components/loading/modern_loading_widget.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/sections/booking_summary_levels_and_roles.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/sections/booking_summary_stats.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/sections/class_booking_summary_booking_view.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Loads the list of bookings for a given classEventId, using the current user’s ID.
final classEventBookingsProvider = FutureProvider.family
    .autoDispose<List<ClassEventBooking>, String>((ref, classEventId) async {
  // First, get the current user (or throw if none)
  final user = await ref.watch(userRiverpodProvider.future);
  final userId = user?.id;
  if (userId == null) {
    throw Exception("No user found");
  }

  // Fetch via your repository
  return await BookingsRepository(
    apiService: GraphQLClientSingleton(),
  ).getCreatorsClassEventBookingsByClassEvent(userId, classEventId);
});

class ClassBookingSummaryBody extends ConsumerWidget {
  const ClassBookingSummaryBody({super.key, required this.classEventId});

  final String classEventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(classEventBookingsProvider(classEventId));

    return bookingsAsync.when(
      loading: () => const ModernLoadingWidget(),
      error: (err, st) {
        return Center(child: Text("Error: ${err.toString()}"));
      },
      data: (bookings) {
        if (bookings.isEmpty) {
          return const Center(
            child: Text("No bookings found for this class"),
          );
        }

        final first = bookings.first;
        final eventName = first.classEvent.classModel?.name;
        final eventDate = getDatedMMYY(first.classEvent.startDateDT);

        return Column(
          children: [
            // Event header
            _buildEventHeader(context, eventName, eventDate),
            const SizedBox(height: 20),
            // Stats section
            BookingSummaryStats(bookings: bookings),
            const SizedBox(height: 16),
            // Level and role summary
            BookingSummaryLevelsAndRoles(bookings: bookings),
            const SizedBox(height: 16),
            // Bookings list
            ClassBookingSummaryBookingView(bookings: bookings),
          ],
        );
      },
    );
  }

  Widget _buildEventHeader(BuildContext context, String? eventName, String eventDate) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Event icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.event,
              size: 32,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          // Event name
          if (eventName != null)
            Text(
              eventName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 8),
          // Event date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  eventDate,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
