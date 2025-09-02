import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/data/repositories/invitation_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
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

  InvitesNotifier({required InvitationRepository invitationRepository})
      : _invitationRepository = invitationRepository,
        super(const InvitesState());

  /// Test constructor for unit tests
  InvitesNotifier.test()
      : _invitationRepository =
            InvitationRepository(apiService: GraphQLClientSingleton()),
        super(const InvitesState());

  /// Invite a user by email
  Future<bool> inviteByEmail(String email) async {
    if (await checkIfInviteIsPossible(email) == false) {
      return false;
    }

    try {
      final result = await _invitationRepository.inviteByEmail(email);
      if (result) {
        showSuccessToast("Invitation sent to $email");
        // Fetch invitations again to show the new one
        await getInvitations(isRefresh: true);
        return true;
      } else {
        showErrorToast("Failed to send invitation to $email");
        return false;
      }
    } catch (e, s) {
      showErrorToast(e.toString());
      CustomErrorHandler.captureException(e, stackTrace: s);
      return false;
    }
  }

  /// Get invitations
  Future<void> getInvitations({bool isRefresh = true}) async {
    state = state.copyWith(loading: true, error: null);

    if (isRefresh) {
      state = state.copyWith(offset: 0, invites: []);
    }

    try {
      final result = await _invitationRepository.getInvitations(
        _limit,
        isRefresh ? 0 : state.offset,
      );

      if (isRefresh) {
        state = state.copyWith(
          invites: result["invitations"],
          totalInvites: result["count"],
          offset: _limit,
          loading: false,
        );
      } else {
        state = state.copyWith(
          invites: [...state.invites, ...result["invitations"]],
          totalInvites: result["count"],
          offset: state.offset + _limit,
          loading: false,
        );
      }
    } catch (e) {
      CustomErrorHandler.logError('Error getting invitations: $e');
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  /// Fetch more invitations (pagination)
  Future<void> fetchMore() async {
    if (state.canFetchMore && !state.loading) {
      await getInvitations(isRefresh: false);
    }
  }

  /// Check if invite is possible
  Future<bool> checkIfInviteIsPossible(String email) async {
    try {
      final result = await _invitationRepository.checkInvitePossibility(email);
      return !(result["isInvitedByYou"] ?? false) &&
          !(result["isAlreadyRegistered"] ?? false);
    } catch (e) {
      CustomErrorHandler.logError('Error checking if invite is possible: $e');
      return false;
    }
  }

  /// Clear all data
  void clear() {
    state = const InvitesState();
  }
}

/// Provider for invites
final invitesProvider = StateNotifierProvider<InvitesNotifier, InvitesState>(
  (ref) => InvitesNotifier(
    invitationRepository:
        InvitationRepository(apiService: GraphQLClientSingleton()),
  ),
);
