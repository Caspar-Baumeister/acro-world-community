import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for teacher events management
class TeacherEventsState {
  final bool loading;
  final List<ClassModel> events;
  final bool canFetchMore;

  const TeacherEventsState({
    this.loading = true,
    this.events = const [],
    this.canFetchMore = true,
  });

  TeacherEventsState copyWith({
    bool? loading,
    List<ClassModel>? events,
    bool? canFetchMore,
  }) {
    return TeacherEventsState(
      loading: loading ?? this.loading,
      events: events ?? this.events,
      canFetchMore: canFetchMore ?? this.canFetchMore,
    );
  }
}

/// Notifier for teacher events state management
class TeacherEventsNotifier extends StateNotifier<TeacherEventsState> {
  static const int _limit = 10;
  int _offset = 0;

  TeacherEventsNotifier() : super(const TeacherEventsState());

  /// Fetch more events
  Future<void> fetchMore(String userId) async {
    _offset += _limit;
    await fetchEvents(userId, isRefresh: false);
  }

  /// Fetch created events
  Future<void> fetchEvents(String userId, {bool isRefresh = true}) async {
    state = state.copyWith(loading: true);

    if (isRefresh) {
      _offset = 0;
      state = state.copyWith(events: []);
    }

    try {
      final repository =
          ClassesRepository(apiService: GraphQLClientSingleton());
      final repositoryReturn = await repository.getClassesLazyAsTeacher(
        _limit,
        _offset,
        {
          "_or": [
            {
              "created_by_id": {"_eq": userId}
            },
            {
              "class_owners": {
                "teacher": {
                  "user_id": {"_eq": userId}
                }
              }
            },
          ],
        },
      );

      final events = List<ClassModel>.from(repositoryReturn["classes"]);
      final updatedEvents = isRefresh ? events : [...state.events, ...events];

      state = state.copyWith(
        events: updatedEvents,
        canFetchMore: events.length == _limit,
        loading: false,
      );
    } catch (e) {
      CustomErrorHandler.logError('Error fetching events: $e');
      state = state.copyWith(loading: false);
    }
  }

  /// Clean up the provider
  void cleanUp() {
    state = const TeacherEventsState();
    _offset = 0;
  }
}

/// Provider for teacher events state
final teacherEventsProvider =
    StateNotifierProvider<TeacherEventsNotifier, TeacherEventsState>((ref) {
  return TeacherEventsNotifier();
});
