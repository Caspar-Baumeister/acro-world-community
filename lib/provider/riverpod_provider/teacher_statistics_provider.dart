import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/teacher_statistics.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// State class for teacher statistics with partial loading support
class TeacherStatisticsState {
  final TeacherStatistics statistics;
  final bool isLoading;
  final bool isRefreshing;
  final Map<String, bool> loadingStates;
  final Map<String, String> errors;
  final DateTime lastUpdated;

  TeacherStatisticsState({
    TeacherStatistics? statistics,
    this.isLoading = false,
    this.isRefreshing = false,
    this.loadingStates = const {},
    this.errors = const {},
    DateTime? lastUpdated,
  })  : statistics = statistics ?? TeacherStatistics.empty(),
        lastUpdated = lastUpdated ?? DateTime.fromMillisecondsSinceEpoch(0);

  /// Whether any data has been loaded
  bool get hasData =>
      statistics != TeacherStatistics.empty() &&
      lastUpdated.millisecondsSinceEpoch > 0;

  /// Whether all statistics are loaded successfully
  bool get isFullyLoaded =>
      hasData && errors.isEmpty && !isLoading && !isRefreshing;

  /// Whether there are any errors
  bool get hasErrors => errors.isNotEmpty;

  /// Get error message for a specific statistic
  String? getErrorForStat(String statName) => errors[statName];

  /// Whether a specific statistic is loading
  bool isLoadingStat(String statName) => loadingStates[statName] ?? false;

  /// Create a copy with updated values
  TeacherStatisticsState copyWith({
    TeacherStatistics? statistics,
    bool? isLoading,
    bool? isRefreshing,
    Map<String, bool>? loadingStates,
    Map<String, String>? errors,
    DateTime? lastUpdated,
  }) {
    return TeacherStatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      loadingStates: loadingStates ?? this.loadingStates,
      errors: errors ?? this.errors,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Individual statistic result
class StatisticResult {
  final String name;
  final dynamic value;
  final String? error;

  const StatisticResult({
    required this.name,
    required this.value,
    this.error,
  });
}

/// Repository interface for teacher statistics
abstract class TeacherStatisticsRepository {
  Future<StatisticResult> getCommentsStats(String teacherId);
  Future<StatisticResult> getEventsStats(String teacherId);
  Future<StatisticResult> getParticipatedEventsStats(String teacherId);
  Future<StatisticResult> getBookingsStats(String teacherId);
  Future<TeacherStatistics> getAllStatistics(String teacherId);
}

/// Implementation of teacher statistics repository
class TeacherStatisticsRepositoryImpl implements TeacherStatisticsRepository {
  final GraphQLClient _client;

  const TeacherStatisticsRepositoryImpl(this._client);

  @override
  Future<StatisticResult> getCommentsStats(String teacherId) async {
    try {
      print(
          '🔍 [TeacherStats] Fetching comments stats for teacher: $teacherId');

      final result = await _client.query(QueryOptions(
        document: Queries.getCommentsStatsForTeacher,
        variables: {'teacher_id': teacherId},
        fetchPolicy: FetchPolicy.networkOnly,
      ));

      print('📊 [TeacherStats] Comments query result: ${result.data}');

      if (result.hasException) {
        print('❌ [TeacherStats] Comments query failed: ${result.exception}');
        return StatisticResult(
          name: 'comments',
          value: null,
          error: 'Failed to fetch comments stats: ${result.exception}',
        );
      }

      final commentsList = result.data?['comments'] as List<dynamic>? ?? [];
      print('📈 [TeacherStats] Comments list: ${commentsList.length} items');

      final totalReviews = commentsList.length;

      // Calculate average rating from comments that have ratings
      final ratingsWithValues = commentsList
          .where((comment) => comment['rating'] != null)
          .map((comment) => (comment['rating'] as num).toDouble())
          .toList();

      final averageRating = ratingsWithValues.isNotEmpty
          ? ratingsWithValues.reduce((a, b) => a + b) / ratingsWithValues.length
          : 0.0;

      print(
          '✅ [TeacherStats] Comments stats parsed - Reviews: $totalReviews, Rating: $averageRating');

      return StatisticResult(
        name: 'comments',
        value: {
          'totalReviews': totalReviews,
          'averageRating': averageRating,
        },
      );
    } catch (e) {
      print('💥 [TeacherStats] Comments stats network error: $e');
      return StatisticResult(
        name: 'comments',
        value: null,
        error: 'Network error: $e',
      );
    }
  }

  @override
  Future<StatisticResult> getEventsStats(String teacherId) async {
    try {
      print('🔍 [TeacherStats] Fetching events stats for teacher: $teacherId');

      final result = await _client.query(QueryOptions(
        document: Queries.getTeacherEventsStats,
        variables: {'teacher_id': teacherId},
        fetchPolicy: FetchPolicy.cacheFirst,
      ));

      print('📊 [TeacherStats] Events query result: ${result.data}');

      if (result.hasException) {
        print('❌ [TeacherStats] Events query failed: ${result.exception}');
        return StatisticResult(
          name: 'events',
          value: null,
          error: 'Failed to fetch events stats: ${result.exception}',
        );
      }

      final classesList = result.data?['classes'] as List<dynamic>? ?? [];
      final totalEvents = classesList.length;

      print(
          '✅ [TeacherStats] Events stats parsed - Total Events: $totalEvents');

      return StatisticResult(
        name: 'events',
        value: totalEvents,
      );
    } catch (e) {
      print('💥 [TeacherStats] Events stats network error: $e');
      return StatisticResult(
        name: 'events',
        value: null,
        error: 'Network error: $e',
      );
    }
  }

  @override
  Future<StatisticResult> getParticipatedEventsStats(String teacherId) async {
    try {
      print(
          '🔍 [TeacherStats] Fetching participated events stats for teacher: $teacherId');

      final result = await _client.query(QueryOptions(
        document: Queries.getTeacherParticipatedEventsStats,
        variables: {'teacher_id': teacherId},
        fetchPolicy: FetchPolicy.cacheFirst,
      ));

      print(
          '📊 [TeacherStats] Participated events query result: ${result.data}');

      if (result.hasException) {
        print(
            '❌ [TeacherStats] Participated events query failed: ${result.exception}');
        return StatisticResult(
          name: 'participated',
          value: null,
          error:
              'Failed to fetch participated events stats: ${result.exception}',
        );
      }

      final classesList = result.data?['classes'] as List<dynamic>? ?? [];
      final eventsParticipated = classesList.length;

      print(
          '✅ [TeacherStats] Participated events stats parsed - Events Participated: $eventsParticipated');

      return StatisticResult(
        name: 'participated',
        value: eventsParticipated,
      );
    } catch (e) {
      print('💥 [TeacherStats] Participated events stats network error: $e');
      return StatisticResult(
        name: 'participated',
        value: null,
        error: 'Network error: $e',
      );
    }
  }

  @override
  Future<StatisticResult> getBookingsStats(String teacherId) async {
    try {
      print(
          '🔍 [TeacherStats] Fetching bookings stats for teacher: $teacherId');

      final result = await _client.query(QueryOptions(
        document: Queries.getTeacherBookingsStats,
        variables: {'teacher_id': teacherId},
        fetchPolicy: FetchPolicy.cacheFirst,
      ));

      print('📊 [TeacherStats] Bookings query result: ${result.data}');

      if (result.hasException) {
        print('❌ [TeacherStats] Bookings query failed: ${result.exception}');
        return StatisticResult(
          name: 'bookings',
          value: null,
          error: 'Failed to fetch bookings stats: ${result.exception}',
        );
      }

      final timesBooked = result.data?['class_event_bookings_aggregate']
              ?['aggregate']?['count'] ??
          0;

      print(
          '✅ [TeacherStats] Bookings stats parsed - Times Booked: $timesBooked');

      return StatisticResult(
        name: 'bookings',
        value: timesBooked,
      );
    } catch (e) {
      print('💥 [TeacherStats] Bookings stats network error: $e');
      return StatisticResult(
        name: 'bookings',
        value: null,
        error: 'Network error: $e',
      );
    }
  }

  @override
  Future<TeacherStatistics> getAllStatistics(String teacherId) async {
    print('🚀 [TeacherStats] Fetching ALL statistics for teacher: $teacherId');

    // Fetch all statistics in parallel for better performance
    final results = await Future.wait([
      getCommentsStats(teacherId),
      getEventsStats(teacherId),
      getParticipatedEventsStats(teacherId),
      getBookingsStats(teacherId),
    ]);

    print('📋 [TeacherStats] All individual results: $results');

    // Parse results with error handling
    int totalEvents = 0;
    int eventsParticipated = 0;
    int timesBooked = 0;
    double averageRating = 0.0;
    int totalReviews = 0;

    for (final result in results) {
      switch (result.name) {
        case 'events':
          totalEvents = result.value as int? ?? 0;
          break;
        case 'participated':
          eventsParticipated = result.value as int? ?? 0;
          break;
        case 'bookings':
          timesBooked = result.value as int? ?? 0;
          break;
        case 'comments':
          final commentsData = result.value as Map<String, dynamic>?;
          totalReviews = commentsData?['totalReviews'] as int? ?? 0;
          averageRating =
              (commentsData?['averageRating'] as num?)?.toDouble() ?? 0.0;
          break;
      }
    }

    final finalStats = TeacherStatistics(
      totalEvents: totalEvents,
      eventsParticipated: eventsParticipated,
      timesBooked: timesBooked,
      averageRating: averageRating,
      totalReviews: totalReviews,
    );

    print('🎯 [TeacherStats] Final aggregated statistics: $finalStats');

    return finalStats;
  }
}

/// Provider for teacher statistics repository
final teacherStatisticsRepositoryProvider =
    Provider<TeacherStatisticsRepository>((ref) {
  final client = GraphQLClientSingleton().client;
  return TeacherStatisticsRepositoryImpl(client);
});

/// Enhanced teacher statistics notifier with better error handling and caching
class TeacherStatisticsNotifier extends StateNotifier<TeacherStatisticsState> {
  final TeacherStatisticsRepository _repository;
  final String _teacherId;

  TeacherStatisticsNotifier(this._repository, this._teacherId)
      : super(TeacherStatisticsState());

  /// Load all statistics
  Future<void> loadStatistics({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(isRefreshing: true);
    } else {
      state = state.copyWith(isLoading: true);
    }

    try {
      final statistics = await _repository.getAllStatistics(_teacherId);

      state = state.copyWith(
        statistics: statistics,
        isLoading: false,
        isRefreshing: false,
        lastUpdated: DateTime.now(),
        errors: {},
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errors: {'general': 'Failed to load statistics: $e'},
      );
    }
  }

  /// Load individual statistics with partial updates
  Future<void> loadIndividualStatistics() async {
    // Set loading states for all statistics
    state = state.copyWith(
      loadingStates: {
        'events': true,
        'comments': true,
        'participated': true,
        'bookings': true,
      },
    );

    // Load statistics individually
    final futures = [
      loadCommentsStats(),
      loadEventsStats(),
      loadParticipatedStats(),
      loadBookingsStats(),
    ];

    await Future.wait(futures);
  }

  Future<void> loadCommentsStats() async {
    try {
      final result = await _repository.getCommentsStats(_teacherId);

      if (result.error != null) {
        state = state.copyWith(
          loadingStates: {...state.loadingStates, 'comments': false},
          errors: {...state.errors, 'comments': result.error!},
        );
      } else {
        final commentsData = result.value as Map<String, dynamic>;
        final currentStats = state.statistics;

        state = state.copyWith(
          statistics: currentStats.copyWith(
            totalReviews: commentsData['totalReviews'] as int,
            averageRating: commentsData['averageRating'] as double,
          ),
          loadingStates: {...state.loadingStates, 'comments': false},
          errors: Map.from(state.errors)..remove('comments'),
        );
      }
    } catch (e) {
      state = state.copyWith(
        loadingStates: {...state.loadingStates, 'comments': false},
        errors: {...state.errors, 'comments': 'Failed to load: $e'},
      );
    }
  }

  Future<void> loadEventsStats() async {
    try {
      final result = await _repository.getEventsStats(_teacherId);

      if (result.error != null) {
        state = state.copyWith(
          loadingStates: {...state.loadingStates, 'events': false},
          errors: {...state.errors, 'events': result.error!},
        );
      } else {
        final currentStats = state.statistics;

        state = state.copyWith(
          statistics: currentStats.copyWith(
            totalEvents: result.value as int,
          ),
          loadingStates: {...state.loadingStates, 'events': false},
          errors: Map.from(state.errors)..remove('events'),
        );
      }
    } catch (e) {
      state = state.copyWith(
        loadingStates: {...state.loadingStates, 'events': false},
        errors: {...state.errors, 'events': 'Failed to load: $e'},
      );
    }
  }

  Future<void> loadParticipatedStats() async {
    try {
      final result = await _repository.getParticipatedEventsStats(_teacherId);

      if (result.error != null) {
        state = state.copyWith(
          loadingStates: {...state.loadingStates, 'participated': false},
          errors: {...state.errors, 'participated': result.error!},
        );
      } else {
        final currentStats = state.statistics;

        state = state.copyWith(
          statistics: currentStats.copyWith(
            eventsParticipated: result.value as int,
          ),
          loadingStates: {...state.loadingStates, 'participated': false},
          errors: Map.from(state.errors)..remove('participated'),
        );
      }
    } catch (e) {
      state = state.copyWith(
        loadingStates: {...state.loadingStates, 'participated': false},
        errors: {...state.errors, 'participated': 'Failed to load: $e'},
      );
    }
  }

  Future<void> loadBookingsStats() async {
    try {
      final result = await _repository.getBookingsStats(_teacherId);

      if (result.error != null) {
        state = state.copyWith(
          loadingStates: {...state.loadingStates, 'bookings': false},
          errors: {...state.errors, 'bookings': result.error!},
        );
      } else {
        final currentStats = state.statistics;

        state = state.copyWith(
          statistics: currentStats.copyWith(
            timesBooked: result.value as int,
          ),
          loadingStates: {...state.loadingStates, 'bookings': false},
          errors: Map.from(state.errors)..remove('bookings'),
        );
      }
    } catch (e) {
      state = state.copyWith(
        loadingStates: {...state.loadingStates, 'bookings': false},
        errors: {...state.errors, 'bookings': 'Failed to load: $e'},
      );
    }
  }

  /// Refresh statistics
  Future<void> refresh() async {
    await loadStatistics(isRefresh: true);
  }

  /// Clear cache and reload
  Future<void> clearCacheAndReload() async {
    state = TeacherStatisticsState();
    await loadStatistics();
  }

  /// Check if data is stale and needs refresh
  bool shouldRefresh({Duration maxAge = const Duration(minutes: 5)}) {
    if (!state.hasData) return true;
    return DateTime.now().difference(state.lastUpdated) > maxAge;
  }
}

/// Provider for teacher statistics notifier V2
final teacherStatisticsNotifierProvider = StateNotifierProvider.family<
    TeacherStatisticsNotifier,
    TeacherStatisticsState,
    String>((ref, teacherId) {
  final repository = ref.watch(teacherStatisticsRepositoryProvider);
  return TeacherStatisticsNotifier(repository, teacherId);
});

/// Convenience provider for easy consumption in UI
final teacherStatisticsProvider =
    Provider.family<TeacherStatisticsState, String>((ref, teacherId) {
  final state = ref.watch(teacherStatisticsNotifierProvider(teacherId));

  // Auto-load statistics if not loaded and not loading
  if (!state.hasData && !state.isLoading && !state.isRefreshing) {
    final notifier =
        ref.read(teacherStatisticsNotifierProvider(teacherId).notifier);
    Future.microtask(() => notifier.loadStatistics());
  }

  return state;
});

/// Provider for individual statistics with error handling
final teacherStatisticsWithErrorsProvider =
    Provider.family<TeacherStatisticsWithErrors, String>((ref, teacherId) {
  final state = ref.watch(teacherStatisticsProvider(teacherId));

  return TeacherStatisticsWithErrors(
    statistics: state.statistics,
    errors: state.errors,
    loadingStates: state.loadingStates,
    isLoading: state.isLoading || state.isRefreshing,
    hasData: state.hasData,
  );
});

/// Data class for teacher statistics with errors
class TeacherStatisticsWithErrors {
  final TeacherStatistics statistics;
  final Map<String, String> errors;
  final Map<String, bool> loadingStates;
  final bool isLoading;
  final bool hasData;

  const TeacherStatisticsWithErrors({
    required this.statistics,
    required this.errors,
    required this.loadingStates,
    required this.isLoading,
    required this.hasData,
  });
}
