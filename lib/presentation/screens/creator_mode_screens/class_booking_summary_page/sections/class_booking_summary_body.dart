// lib/provider/riverpod_provider/bookings_providers.dart

import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/data/repositories/bookings_repository.dart';
import 'package:acroworld/presentation/components/loading/modern_loading_widget.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/sections/booking_summary_levels_and_roles.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/sections/booking_summary_stats.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/sections/class_booking_summary_booking_view.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/gql_client_service.dart';
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

        return Column(
          children: [
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
}
