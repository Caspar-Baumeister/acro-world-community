import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/teacher_statistics.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

// Provider for fetching teacher statistics
final teacherStatisticsProvider =
    FutureProvider.family<TeacherStatistics, String>((ref, teacherId) async {
  final client = GraphQLClientSingleton().client;

  // Fetch all statistics in parallel
  final results = await Future.wait([
    client.query(QueryOptions(
      document: Queries.getCommentsStatsForTeacher,
      variables: {'teacher_id': teacherId},
    )),
    client.query(QueryOptions(
      document: Queries.getTeacherEventsStats,
      variables: {'teacher_id': teacherId},
    )),
    client.query(QueryOptions(
      document: Queries.getTeacherParticipatedEventsStats,
      variables: {'teacher_id': teacherId},
    )),
    client.query(QueryOptions(
      document: Queries.getTeacherBookingsStats,
      variables: {'teacher_id': teacherId},
    )),
  ]);

  // Check for exceptions
  for (final result in results) {
    if (result.hasException) {
      throw Exception('Failed to fetch statistics: ${result.exception}');
    }
  }

  // Parse results
  final commentsResult = results[0];
  final eventsResult = results[1];
  final participatedResult = results[2];
  final bookingsResult = results[3];

  final commentsAggregate =
      commentsResult.data?['comments_aggregate']?['aggregate'];
  final totalReviews = commentsAggregate?['count'] ?? 0;
  final averageRating =
      (commentsAggregate?['avg']?['rating'] as num?)?.toDouble() ?? 0.0;

  final totalEvents =
      eventsResult.data?['classes_aggregate']?['aggregate']?['count'] ?? 0;
  final eventsParticipated = participatedResult.data?['class_events_aggregate']
          ?['aggregate']?['count'] ??
      0;
  final timesBooked = bookingsResult.data?['class_event_bookings_aggregate']
          ?['aggregate']?['count'] ??
      0;

  return TeacherStatistics(
    totalEvents: totalEvents,
    eventsParticipated: eventsParticipated,
    timesBooked: timesBooked,
    averageRating: averageRating,
    totalReviews: totalReviews,
  );
});

// Notifier for managing teacher statistics
class TeacherStatisticsNotifier
    extends StateNotifier<AsyncValue<TeacherStatistics>> {
  TeacherStatisticsNotifier(this._client) : super(const AsyncValue.loading());

  final GraphQLClient _client;

  Future<void> loadStatistics(String teacherId) async {
    state = const AsyncValue.loading();

    try {
      // Fetch all statistics in parallel
      final results = await Future.wait([
        _client.query(QueryOptions(
          document: Queries.getCommentsStatsForTeacher,
          variables: {'teacher_id': teacherId},
        )),
        _client.query(QueryOptions(
          document: Queries.getTeacherEventsStats,
          variables: {'teacher_id': teacherId},
        )),
        _client.query(QueryOptions(
          document: Queries.getTeacherParticipatedEventsStats,
          variables: {'teacher_id': teacherId},
        )),
        _client.query(QueryOptions(
          document: Queries.getTeacherBookingsStats,
          variables: {'teacher_id': teacherId},
        )),
      ]);

      // Check for exceptions
      for (final result in results) {
        if (result.hasException) {
          state = AsyncValue.error(result.exception!, StackTrace.current);
          return;
        }
      }

      // Parse results
      final commentsResult = results[0];
      final eventsResult = results[1];
      final participatedResult = results[2];
      final bookingsResult = results[3];

      final commentsAggregate =
          commentsResult.data?['comments_aggregate']?['aggregate'];
      final totalReviews = commentsAggregate?['count'] ?? 0;
      final averageRating =
          (commentsAggregate?['avg']?['rating'] as num?)?.toDouble() ?? 0.0;

      final totalEvents =
          eventsResult.data?['classes_aggregate']?['aggregate']?['count'] ?? 0;
      final eventsParticipated = participatedResult
              .data?['class_events_aggregate']?['aggregate']?['count'] ??
          0;
      final timesBooked = bookingsResult.data?['class_event_bookings_aggregate']
              ?['aggregate']?['count'] ??
          0;

      final statistics = TeacherStatistics(
        totalEvents: totalEvents,
        eventsParticipated: eventsParticipated,
        timesBooked: timesBooked,
        averageRating: averageRating,
        totalReviews: totalReviews,
      );

      state = AsyncValue.data(statistics);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Provider for the teacher statistics notifier
final teacherStatisticsNotifierProvider = StateNotifierProvider<
    TeacherStatisticsNotifier, AsyncValue<TeacherStatistics>>((ref) {
  final client = GraphQLClientSingleton().client;
  return TeacherStatisticsNotifier(client);
});
