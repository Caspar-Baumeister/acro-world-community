import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// State for teachers pagination
class TeachersPaginationState {
  final bool loading;
  final List<TeacherModel> teachers;
  final String? error;
  final bool canFetchMore;
  final int offset;
  final String searchQuery;
  final bool isFollowed;

  const TeachersPaginationState({
    this.loading = true,
    this.teachers = const [],
    this.error,
    this.canFetchMore = true,
    this.offset = 0,
    this.searchQuery = "",
    this.isFollowed = false,
  });

  TeachersPaginationState copyWith({
    bool? loading,
    List<TeacherModel>? teachers,
    String? error,
    bool? canFetchMore,
    int? offset,
    String? searchQuery,
    bool? isFollowed,
  }) {
    return TeachersPaginationState(
      loading: loading ?? this.loading,
      teachers: teachers ?? this.teachers,
      error: error ?? this.error,
      canFetchMore: canFetchMore ?? this.canFetchMore,
      offset: offset ?? this.offset,
      searchQuery: searchQuery ?? this.searchQuery,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }
}

/// Notifier for teachers pagination state management
class TeachersPaginationNotifier
    extends StateNotifier<TeachersPaginationState> {
  TeachersPaginationNotifier() : super(const TeachersPaginationState());

  final GraphQLClientSingleton _client = GraphQLClientSingleton();
  final int _limit = 20;

  /// Reset state and fetch initial teachers
  Future<void> fetchTeachers({
    required String searchQuery,
    required bool isFollowed,
    required String? userId,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      _resetState();
    }

    state = state.copyWith(
      loading: true,
      error: null,
      searchQuery: searchQuery,
      isFollowed: isFollowed,
    );

    try {
      final variables = _buildQueryVariables(
        searchQuery: searchQuery,
        isFollowed: isFollowed,
        userId: userId,
        offset: 0,
      );

      final result = await _client.client.query(QueryOptions(
        document: _getQueryDocument(isFollowed, userId),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
      ));

      if (result.hasException) {
        state = state.copyWith(
          loading: false,
          error: result.exception.toString(),
        );
        return;
      }

      final teachers = _parseTeachersFromResult(result.data!, isFollowed);

      state = state.copyWith(
        teachers: teachers,
        loading: false,
        canFetchMore: teachers.length == _limit,
        offset: _limit,
      );

      CustomErrorHandler.logDebug(
        'Fetched ${teachers.length} teachers (initial load)',
      );
    } catch (e) {
      CustomErrorHandler.logError('Error fetching teachers: $e');
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  /// Fetch more teachers (pagination)
  Future<void> fetchMore({
    required String? userId,
  }) async {
    if (!state.canFetchMore || state.loading) return;

    state = state.copyWith(loading: true);

    try {
      final variables = _buildQueryVariables(
        searchQuery: state.searchQuery,
        isFollowed: state.isFollowed,
        userId: userId,
        offset: state.offset,
      );

      final result = await _client.client.query(QueryOptions(
        document: _getQueryDocument(state.isFollowed, userId),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
      ));

      if (result.hasException) {
        state = state.copyWith(
          loading: false,
          error: result.exception.toString(),
        );
        return;
      }

      final newTeachers =
          _parseTeachersFromResult(result.data!, state.isFollowed);
      final updatedTeachers = [...state.teachers, ...newTeachers];

      state = state.copyWith(
        teachers: updatedTeachers,
        loading: false,
        canFetchMore: newTeachers.length == _limit,
        offset: state.offset + _limit,
      );

      CustomErrorHandler.logDebug(
        'Fetched ${newTeachers.length} more teachers (total: ${updatedTeachers.length})',
      );
    } catch (e) {
      CustomErrorHandler.logError('Error fetching more teachers: $e');
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  /// Reset state for new search/filter
  void _resetState() {
    state = const TeachersPaginationState();
  }

  /// Build query variables based on search and filter options
  Map<String, dynamic> _buildQueryVariables({
    required String searchQuery,
    required bool isFollowed,
    required String? userId,
    required int offset,
  }) {
    if (isFollowed) {
      return {
        "user_id": userId,
        "search": "%$searchQuery%",
      };
    } else if (userId == null) {
      return {
        "search": "%$searchQuery%",
        "limit": _limit,
        "offset": offset,
      };
    } else {
      return {
        "user_id": userId,
        "search": "%$searchQuery%",
        "limit": _limit,
        "offset": offset,
      };
    }
  }

  /// Get the appropriate GraphQL query document
  _getQueryDocument(bool isFollowed, String? userId) {
    if (isFollowed) {
      return Queries.getFollowedTeacherForList;
    } else if (userId == null) {
      return Queries.getTeacherForListWithoutUserID;
    } else {
      return Queries.getTeacherForList;
    }
  }

  /// Parse teachers from GraphQL result
  List<TeacherModel> _parseTeachersFromResult(
    Map<String, dynamic> data,
    bool isFollowed,
  ) {
    List<TeacherModel> teachers = [];

    try {
      if (isFollowed) {
        final list = data["me"]?[0]?["followed_teacher"] as List<dynamic>?;
        if (list != null) {
          for (final item in list) {
            teachers.add(TeacherModel.fromJson(item["teacher"]));
          }
        }
      } else {
        final list = data["teachers"] as List<dynamic>?;
        if (list != null) {
          for (final item in list) {
            teachers.add(TeacherModel.fromJson(item));
          }
        }
      }
    } catch (e) {
      CustomErrorHandler.logError('Error parsing teachers: $e');
    }

    return teachers;
  }
}

/// Provider for teachers pagination
final teachersPaginationProvider =
    StateNotifierProvider<TeachersPaginationNotifier, TeachersPaginationState>(
        (ref) {
  return TeachersPaginationNotifier();
});
