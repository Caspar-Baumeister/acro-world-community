import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/data/repositories/invitation_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/provider/riverpod_provider/pending_invites_badge_provider.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for invites
class InvitesState {
  final List<InvitationModel> invites;
  final int totalInvites;
  final int offset;
  final bool loading;
  final String? error;

  const InvitesState({
    this.invites = const [],
    this.totalInvites = 0,
    this.offset = 0,
    this.loading = true,
    this.error,
  });

  InvitesState copyWith({
    List<InvitationModel>? invites,
    int? totalInvites,
    int? offset,
    bool? loading,
    String? error,
  }) {
    return InvitesState(
      invites: invites ?? this.invites,
      totalInvites: totalInvites ?? this.totalInvites,
      offset: offset ?? this.offset,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  bool get canFetchMore => invites.length < totalInvites;
}

/// Notifier for invites
class InvitesNotifier extends StateNotifier<InvitesState> {
  static const int _limit = 10;
  final InvitationRepository _invitationRepository;
  Ref? _ref;

  InvitesNotifier({required InvitationRepository invitationRepository})
      : _invitationRepository = invitationRepository,
        super(const InvitesState());

  void setRef(Ref ref) {
    _ref = ref;
  }

  /// Test constructor for unit tests
  InvitesNotifier.test()
      : _invitationRepository =
            InvitationRepository(apiService: GraphQLClientSingleton()),
        super(const InvitesState());

  /// Get invitations
  Future<void> getInvitations(
      {bool isRefresh = true, required String userId}) async {
    print('🔍 INVITES DEBUG - Provider getInvitations called:');
    print('  isRefresh: $isRefresh');
    print('  userId: $userId');
    print('  _limit: $_limit');
    print('  current offset: ${state.offset}');
    print('  current invites count: ${state.invites.length}');
    print('  current total invites: ${state.totalInvites}');

    state = state.copyWith(loading: true, error: null);

    if (isRefresh) {
      print(
          '🔍 INVITES DEBUG - Provider refreshing: resetting offset to 0 and clearing invites');
      state = state.copyWith(offset: 0, invites: []);
    }

    try {
      final repositoryLimit = _limit;
      final repositoryOffset = isRefresh ? 0 : state.offset;

      print('🔍 INVITES DEBUG - Provider calling repository with:');
      print('  repository limit: $repositoryLimit');
      print('  repository offset: $repositoryOffset');

      final result = await _invitationRepository.getInvitations(
        repositoryLimit,
        repositoryOffset,
        userId,
      );

      print('🔍 INVITES DEBUG - Provider received from repository:');
      print('  result keys: ${result.keys}');
      print('  invitations count: ${result["invitations"]?.length ?? 0}');
      print('  total count: ${result["count"]}');

      if (isRefresh) {
        print('🔍 INVITES DEBUG - Provider updating state for refresh:');
        print('  new invites count: ${result["invitations"].length}');
        print('  new total invites: ${result["count"]}');
        print('  new offset: $_limit');

        state = state.copyWith(
          invites: result["invitations"],
          totalInvites: result["count"],
          offset: _limit,
          loading: false,
        );
      } else {
        final newInvites = [...state.invites, ...result["invitations"]];
        final newOffset = state.offset + _limit;

        print('🔍 INVITES DEBUG - Provider updating state for pagination:');
        print('  previous invites count: ${state.invites.length}');
        print('  new invitations count: ${result["invitations"].length}');
        print('  combined invites count: ${newInvites.length}');
        print('  new total invites: ${result["count"]}');
        print('  previous offset: ${state.offset}');
        print('  new offset: $newOffset');

        state = state.copyWith(
          invites: newInvites.cast<InvitationModel>(),
          totalInvites: result["count"],
          offset: newOffset,
          loading: false,
        );
      }

      print('🔍 INVITES DEBUG - Provider final state:');
      print('  final invites count: ${state.invites.length}');
      print('  final total invites: ${state.totalInvites}');
      print('  final offset: ${state.offset}');
      print('  canFetchMore: ${state.canFetchMore}');
      print('  loading: ${state.loading}');

      // Refresh badge count after updating invites
      _refreshBadgeCount(userId);
    } catch (e) {
      print('🔍 INVITES DEBUG - Provider Error: $e');
      CustomErrorHandler.logError('Error getting invitations: $e');
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  /// Fetch more invitations (pagination)
  Future<void> fetchMore({required String userId}) async {
    print('🔍 INVITES DEBUG - Provider fetchMore called:');
    print('  userId: $userId');
    print('  canFetchMore: ${state.canFetchMore}');
    print('  loading: ${state.loading}');
    print('  current offset: ${state.offset}');
    print('  current invites count: ${state.invites.length}');
    print('  total invites: ${state.totalInvites}');

    if (state.canFetchMore && !state.loading) {
      print(
          '🔍 INVITES DEBUG - Provider fetchMore: calling getInvitations with isRefresh=false');
      await getInvitations(isRefresh: false, userId: userId);
    } else {
      print(
          '🔍 INVITES DEBUG - Provider fetchMore: skipping - canFetchMore=${state.canFetchMore}, loading=${state.loading}');
    }
  }

  /// Clear all data
  void clear() {
    state = const InvitesState();
  }

  /// Refresh the badge count
  void _refreshBadgeCount(String userId) {
    if (_ref != null) {
      _ref!
          .read(pendingInvitesBadgeProvider.notifier)
          .fetchPendingCount(userId);
    }
  }
}

/// Provider for invites
final invitesProvider = StateNotifierProvider<InvitesNotifier, InvitesState>(
  (ref) {
    final notifier = InvitesNotifier(
      invitationRepository:
          InvitationRepository(apiService: GraphQLClientSingleton()),
    );
    notifier.setRef(ref);
    return notifier;
  },
);
