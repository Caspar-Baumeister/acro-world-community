import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for teacher events management
class TeacherEventsState {
  final bool loading;
  final List<ClassModel> myCreatedEvents;
  final List<ClassModel> myParticipatingEvents;
  final bool isLoadingMyEvents;
  final bool isLoadingParticipatingEvents;
  final bool isInitialized;
  final bool canFetchMoreMyEvents;
  final bool canFetchMoreParticipatingEvents;

  const TeacherEventsState({
    this.loading = true,
    this.myCreatedEvents = const [],
    this.myParticipatingEvents = const [],
    this.isLoadingMyEvents = false,
    this.isLoadingParticipatingEvents = false,
    this.isInitialized = false,
    this.canFetchMoreMyEvents = true,
    this.canFetchMoreParticipatingEvents = true,
  });

  TeacherEventsState copyWith({
    bool? loading,
    List<ClassModel>? myCreatedEvents,
    List<ClassModel>? myParticipatingEvents,
    bool? isLoadingMyEvents,
    bool? isLoadingParticipatingEvents,
    bool? isInitialized,
    bool? canFetchMoreMyEvents,
    bool? canFetchMoreParticipatingEvents,
  }) {
    return TeacherEventsState(
      loading: loading ?? this.loading,
      myCreatedEvents: myCreatedEvents ?? this.myCreatedEvents,
      myParticipatingEvents: myParticipatingEvents ?? this.myParticipatingEvents,
      isLoadingMyEvents: isLoadingMyEvents ?? this.isLoadingMyEvents,
      isLoadingParticipatingEvents: isLoadingParticipatingEvents ?? this.isLoadingParticipatingEvents,
      isInitialized: isInitialized ?? this.isInitialized,
      canFetchMoreMyEvents: canFetchMoreMyEvents ?? this.canFetchMoreMyEvents,
      canFetchMoreParticipatingEvents: canFetchMoreParticipatingEvents ?? this.canFetchMoreParticipatingEvents,
    );
  }
}

/// Notifier for teacher events state management
class TeacherEventsNotifier extends StateNotifier<TeacherEventsState> {
  static const int _limit = 10;
  int _offsetMyEvent = 0;
  int _offsetParticipatingEvent = 0;

  TeacherEventsNotifier() : super(const TeacherEventsState()) {
    _initialize();
  }

  /// Initialize the provider
  void _initialize() {
    state = state.copyWith(loading: true);
  }

  /// Fetch more events
  Future<void> fetchMore(String userId, {bool myEvents = true}) async {
    if (myEvents) {
      state = state.copyWith(isLoadingMyEvents: true);
      _offsetMyEvent += _limit;
    } else {
      state = state.copyWith(isLoadingParticipatingEvents: true);
      _offsetParticipatingEvent += _limit;
    }

    await fetchMyEvents(userId, isRefresh: false, myEvents: myEvents);

    if (myEvents) {
      state = state.copyWith(isLoadingMyEvents: false);
    } else {
      state = state.copyWith(isLoadingParticipatingEvents: false);
    }
  }

  /// Fetch my events
  Future<void> fetchMyEvents(String userId, {bool isRefresh = true, bool myEvents = true}) async {
    // Set loading state immediately for better UX
    state = state.copyWith(isInitialized: true, loading: true);
    
    CustomErrorHandler.logDebug('Starting to fetch ${myEvents ? 'created' : 'participating'} events for user: $userId');

    if (isRefresh) {
      if (myEvents) {
        _offsetMyEvent = 0;
        state = state.copyWith(
          canFetchMoreMyEvents: true,
          myCreatedEvents: [],
        );
      } else {
        _offsetParticipatingEvent = 0;
        state = state.copyWith(
          canFetchMoreParticipatingEvents: true,
          myParticipatingEvents: [],
        );
      }
    }

    try {
      final stopwatch = Stopwatch()..start();
      final repository = ClassesRepository(apiService: GraphQLClientSingleton());
      
      // Use optimized method for better performance
      final repositoryReturn = await repository.getClassesLazyAsTeacher(
        _limit,
        myEvents ? _offsetMyEvent : _offsetParticipatingEvent,
        {
          "_or": [
            if (myEvents)
              {
                "created_by_id": {"_eq": userId}
              },
            if (myEvents)
              {
                "class_owners": {
                  "teacher": {
                    "user_id": {"_eq": userId}
                  }
                }
              },
            if (!myEvents)
              {
                "class_teachers": {
                  "teacher": {
                    "user_id": {"_eq": userId}
                  }
                }
              },
          ],
          if (!myEvents)
            "_not": {
              "created_by_id": {"_eq": userId}
            },
        },
      );

      stopwatch.stop();
      CustomErrorHandler.logDebug('GraphQL query took ${stopwatch.elapsedMilliseconds}ms');
      
      final parseStopwatch = Stopwatch()..start();
      final events = List<ClassModel>.from(repositoryReturn["classes"]);
      parseStopwatch.stop();
      CustomErrorHandler.logDebug('Data parsing took ${parseStopwatch.elapsedMilliseconds}ms');

      if (myEvents) {
        final updatedEvents = isRefresh ? events : [...state.myCreatedEvents, ...events];
        state = state.copyWith(
          myCreatedEvents: updatedEvents,
          canFetchMoreMyEvents: events.length == _limit,
          loading: false,
        );
      } else {
        final updatedEvents = isRefresh ? events : [...state.myParticipatingEvents, ...events];
        state = state.copyWith(
          myParticipatingEvents: updatedEvents,
          canFetchMoreParticipatingEvents: events.length == _limit,
          loading: false,
        );
      }

      CustomErrorHandler.logDebug('Fetched ${events.length} ${myEvents ? 'created' : 'participating'} events');
    } catch (e) {
      CustomErrorHandler.logError('Error fetching my events with optimized query: $e');
      
      // Fallback to original query if optimized one fails
      try {
        CustomErrorHandler.logDebug('Falling back to original query...');
        final repository = ClassesRepository(apiService: GraphQLClientSingleton());
        
        final repositoryReturn = await repository.getClassesLazyAsTeacher(
          _limit,
          myEvents ? _offsetMyEvent : _offsetParticipatingEvent,
          {
            "_or": [
              if (myEvents)
                {
                  "created_by_id": {"_eq": userId}
                },
              if (myEvents)
                {
                  "class_owners": {
                    "teacher": {
                      "user_id": {"_eq": userId}
                    }
                  }
                },
              if (!myEvents)
                {
                  "class_teachers": {
                    "teacher": {
                      "user_id": {"_eq": userId}
                    }
                  }
                },
            ],
            if (!myEvents)
              "_not": {
                "created_by_id": {"_eq": userId}
              },
          },
        );

        final events = List<ClassModel>.from(repositoryReturn["classes"]);

        if (myEvents) {
          final updatedEvents = isRefresh ? events : [...state.myCreatedEvents, ...events];
          state = state.copyWith(
            myCreatedEvents: updatedEvents,
            canFetchMoreMyEvents: events.length == _limit,
            loading: false,
          );
        } else {
          final updatedEvents = isRefresh ? events : [...state.myParticipatingEvents, ...events];
          state = state.copyWith(
            myParticipatingEvents: updatedEvents,
            canFetchMoreParticipatingEvents: events.length == _limit,
            loading: false,
          );
        }

        CustomErrorHandler.logDebug('Fallback query successful, fetched ${events.length} events');
      } catch (fallbackError) {
        CustomErrorHandler.logError('Fallback query also failed: $fallbackError');
        state = state.copyWith(loading: false);
      }
    }
  }

  /// Clean up the provider
  void cleanUp() {
    state = const TeacherEventsState();
    _offsetMyEvent = 0;
    _offsetParticipatingEvent = 0;
  }

  /// Test constructor for unit tests
  TeacherEventsNotifier.test() : super(const TeacherEventsState());
}

/// Provider for teacher events state
final teacherEventsProvider = StateNotifierProvider<TeacherEventsNotifier, TeacherEventsState>((ref) {
  return TeacherEventsNotifier();
});
