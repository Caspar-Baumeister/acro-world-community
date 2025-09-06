import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_events_provider.dart';
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

  const EventInvitationsState({
    this.invitations = const [],
    this.loading = false,
    this.canFetchMore = false,
    this.isLoadingMore = false,
    this.error,
    this.searchQuery = '',
    this.selectedFilter = 'all',
  });

  EventInvitationsState copyWith({
    List<ClassModel>? invitations,
    bool? loading,
    bool? canFetchMore,
    bool? isLoadingMore,
    String? error,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return EventInvitationsState(
      invitations: invitations ?? this.invitations,
      loading: loading ?? this.loading,
      canFetchMore: canFetchMore ?? this.canFetchMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

/// Event invitations provider notifier
class EventInvitationsNotifier extends StateNotifier<EventInvitationsState> {
  EventInvitationsNotifier(this._teacherEventsNotifier) : super(const EventInvitationsState());

  final TeacherEventsNotifier _teacherEventsNotifier;

  /// Fetch event invitations with search and filter
  Future<void> fetchInvitations({
    String? searchQuery,
    String? filter,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      state = state.copyWith(loading: true, error: null);
    } else {
      state = state.copyWith(isLoadingMore: true, error: null);
    }

    try {
      // Use the existing teacher events provider to get participating events
      final teacherEventsState = _teacherEventsNotifier.state;
      
      // Filter the participating events based on search and filter
      final filteredInvitations = _filterInvitations(
        teacherEventsState.myParticipatingEvents,
        searchQuery ?? state.searchQuery,
        filter ?? state.selectedFilter,
      );
      
      state = state.copyWith(
        invitations: isRefresh ? filteredInvitations : [...state.invitations, ...filteredInvitations],
        loading: false,
        isLoadingMore: false,
        canFetchMore: teacherEventsState.canFetchMoreParticipatingEvents,
        searchQuery: searchQuery ?? state.searchQuery,
        selectedFilter: filter ?? state.selectedFilter,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
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
  ) {
    return invitations.where((invitation) {
      // Search filter
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final matchesSearch = invitation.name?.toLowerCase().contains(query) == true ||
            invitation.locationName?.toLowerCase().contains(query) == true ||
            invitation.city?.toLowerCase().contains(query) == true ||
            invitation.country?.toLowerCase().contains(query) == true;
        if (!matchesSearch) return false;
      }
      
      // Status filter - for now, we'll use mock status since the real status
      // would need to come from the invitation system
      switch (selectedFilter) {
        case 'approved':
          return _getInvitationStatus(invitation) == 'approved';
        case 'pending':
          return _getInvitationStatus(invitation) == 'pending';
        case 'rejected':
          return _getInvitationStatus(invitation) == 'rejected';
        case 'all':
        default:
          return true;
      }
    }).toList();
  }

  /// Get invitation status - this is mock for now
  /// In a real implementation, this would come from the invitation system
  String _getInvitationStatus(ClassModel invitation) {
    // Mock status based on some criteria
    // In reality, this would come from the invitation data
    final hash = invitation.id?.hashCode ?? 0;
    final statuses = ['approved', 'pending', 'rejected'];
    return statuses[hash.abs() % statuses.length];
  }
}

/// Event invitations provider
final eventInvitationsProvider = StateNotifierProvider<EventInvitationsNotifier, EventInvitationsState>((ref) {
  final teacherEventsNotifier = ref.watch(teacherEventsProvider.notifier);
  return EventInvitationsNotifier(teacherEventsNotifier);
});
