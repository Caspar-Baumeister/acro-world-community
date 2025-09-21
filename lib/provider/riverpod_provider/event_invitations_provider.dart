import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for event invitations (taking part in functionality)
class EventInvitationsState {
  final List<ClassModel> invitations;
  final bool loading;
  final bool canFetchMore;
  final bool isLoadingMore;
  final String? error;
  final String searchQuery;
  final String selectedFilter; // 'all', 'approved', 'pending', 'rejected'
  final String? userId;

  const EventInvitationsState({
    this.invitations = const [],
    this.loading = false,
    this.canFetchMore = false,
    this.isLoadingMore = false,
    this.error,
    this.searchQuery = '',
    this.selectedFilter = 'all',
    this.userId,
  });

  EventInvitationsState copyWith({
    List<ClassModel>? invitations,
    bool? loading,
    bool? canFetchMore,
    bool? isLoadingMore,
    String? error,
    String? searchQuery,
    String? selectedFilter,
    String? userId,
  }) {
    return EventInvitationsState(
      invitations: invitations ?? this.invitations,
      loading: loading ?? this.loading,
      canFetchMore: canFetchMore ?? this.canFetchMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      userId: userId ?? this.userId,
    );
  }
}

/// Event invitations provider notifier
class EventInvitationsNotifier extends StateNotifier<EventInvitationsState> {
  EventInvitationsNotifier()
      : _classesRepository =
            ClassesRepository(apiService: GraphQLClientSingleton()),
        super(const EventInvitationsState());

  final ClassesRepository _classesRepository;

  /// Fetch event invitations with search and filter
  Future<void> fetchInvitations({
    String? searchQuery,
    String? filter,
    bool isRefresh = false,
    String? userId,
    String? teacherId,
  }) async {
    if (isRefresh) {
      state = state.copyWith(loading: true, error: null);
    } else {
      state = state.copyWith(isLoadingMore: true, error: null);
    }

    try {
      // Fetch from backend the classes where the user is invited
      final currentUserId = userId ?? state.userId;
      if (currentUserId == null) {
        throw Exception('User id missing for event invitations fetch');
      }
      if (teacherId == null) {
        throw Exception('Teacher ID missing for event invitations fetch');
      }

      // DEBUG: Log all inputs
      final statusFilter = (filter ?? state.selectedFilter) == 'all'
          ? null
          : (filter ?? state.selectedFilter);

      CustomErrorHandler.logDebug('🔍 EVENT INVITATIONS DEBUG - Inputs:');
      CustomErrorHandler.logDebug('  - Teacher ID: $teacherId');
      CustomErrorHandler.logDebug('  - User ID: $currentUserId');
      CustomErrorHandler.logDebug('  - Status Filter: $statusFilter');
      CustomErrorHandler.logDebug(
          '  - Search Query: ${searchQuery ?? state.searchQuery}');
      CustomErrorHandler.logDebug('  - Is Refresh: $isRefresh');

      // Fetch invitations using teacher_id and exclude own classes
      final invitedClassTeachers =
          await _classesRepository.getInvitedClassesByTeacherId(
        teacherId: teacherId,
        userId: currentUserId,
        statusFilter: statusFilter,
      );

      // Convert ClassTeachers to ClassModel for compatibility
      final invited = invitedClassTeachers
          .where((ct) => ct.classModel != null)
          .map((ct) => ct.classModel!)
          .toList();

      CustomErrorHandler.logDebug(
          '  - Invited Classes Count (before filtering): ${invited.length}');

      final filteredInvitations = _filterInvitations(
        invited,
        searchQuery ?? state.searchQuery,
        filter ?? state.selectedFilter,
        currentUserId,
      );

      CustomErrorHandler.logDebug(
          '  - Final Filtered Invitations Count: ${filteredInvitations.length}');

      state = state.copyWith(
        invitations: isRefresh
            ? filteredInvitations
            : [...state.invitations, ...filteredInvitations],
        loading: false,
        isLoadingMore: false,
        canFetchMore: false,
        searchQuery: searchQuery ?? state.searchQuery,
        selectedFilter: filter ?? state.selectedFilter,
        userId: currentUserId,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Accept or reject an invitation
  Future<bool> setInvitationAcceptance({
    required String classId,
    required String teacherId,
    required bool hasAccepted,
  }) async {
    try {
      final ok = await _classesRepository.setInvitationAcceptance(
        classId: classId,
        teacherId: teacherId,
        hasAccepted: hasAccepted,
      );
      if (ok) {
        // Refresh participating events so UI updates
        // We cannot trigger fetch here without user id; rely on outer flow
      }
      return ok;
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
      return false;
    }
  }

  /// Update search query
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Update filter
  void updateFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  /// Fetch more invitations (pagination)
  Future<void> fetchMore() async {
    if (state.isLoadingMore || !state.canFetchMore) return;

    await fetchInvitations(
      searchQuery: state.searchQuery,
      filter: state.selectedFilter,
    );
  }

  /// Filter invitations based on search query and status filter
  List<ClassModel> _filterInvitations(
    List<ClassModel> invitations,
    String searchQuery,
    String selectedFilter,
    String? userId,
  ) {
    // Keep only classes that include this user as teacher
    final mine = userId == null
        ? invitations
        : invitations
            .where((c) =>
                c.classTeachers?.any((t) => t.teacher?.userId == userId) ==
                true)
            .toList();

    // Debug distribution of hasAccepted for this user only
    int nullCount = 0, trueCount = 0, falseCount = 0;
    for (final c in mine) {
      final rel = c.classTeachers?.firstWhere(
              (t) => t.teacher?.userId == userId,
              orElse: () => ClassTeachers()) ??
          ClassTeachers();
      if (rel.hasAccepted == null) nullCount++;
      if (rel.hasAccepted == true) trueCount++;
      if (rel.hasAccepted == false) falseCount++;
    }
    CustomErrorHandler.logDebug(
        'Invites (mine) total=${mine.length}, pending=$nullCount, accepted=$trueCount, rejected=$falseCount');

    // DEBUG: Log detailed filtering process
    CustomErrorHandler.logDebug('🔍 FILTERING DEBUG - _filterInvitations():');
    CustomErrorHandler.logDebug(
        '  - Input invitations count: ${invitations.length}');
    CustomErrorHandler.logDebug('  - User ID for filtering: $userId');
    CustomErrorHandler.logDebug('  - Search Query: "$searchQuery"');
    CustomErrorHandler.logDebug('  - Selected Filter: "$selectedFilter"');
    CustomErrorHandler.logDebug(
        '  - Mine (after user filter) count: ${mine.length}');

    final filteredResults = mine.where((invitation) {
      // Search filter
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final matchesSearch = invitation.name?.toLowerCase().contains(query) ==
                true ||
            invitation.locationName?.toLowerCase().contains(query) == true ||
            invitation.city?.toLowerCase().contains(query) == true ||
            invitation.country?.toLowerCase().contains(query) == true;
        if (!matchesSearch) {
          CustomErrorHandler.logDebug(
              '    - Filtered out by search: ${invitation.name}');
          return false;
        }
      }

      // Status filter based on has_accepted across class_teachers
      bool? status;
      if (invitation.classTeachers != null) {
        final mineRel = invitation.classTeachers!.firstWhere(
            (t) => t.teacher?.userId == userId,
            orElse: () => ClassTeachers());
        status = mineRel.hasAccepted;
      }

      bool matchesFilter;
      switch (selectedFilter) {
        case 'approved':
          matchesFilter = status == true;
          break;
        case 'pending':
          matchesFilter = status == null;
          break;
        case 'rejected':
          matchesFilter = status == false;
          break;
        case 'all':
        default:
          matchesFilter = true;
          break;
      }

      if (!matchesFilter) {
        CustomErrorHandler.logDebug(
            '    - Filtered out by status filter: ${invitation.name} (status: $status, filter: $selectedFilter)');
      }

      return matchesFilter;
    }).toList();

    CustomErrorHandler.logDebug(
        '  - Final filtered results count: ${filteredResults.length}');
    return filteredResults;
  }
}

/// Event invitations provider
final eventInvitationsProvider =
    StateNotifierProvider<EventInvitationsNotifier, EventInvitationsState>(
        (ref) {
  return EventInvitationsNotifier();
});
