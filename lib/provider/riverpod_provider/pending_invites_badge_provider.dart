import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing the pending invites badge count
/// This is a simple, focused provider that only handles the badge count
class PendingInvitesBadgeNotifier extends StateNotifier<int?> {
  PendingInvitesBadgeNotifier(this._classesRepository) : super(null);

  final ClassesRepository _classesRepository;

  /// Fetch the pending invites count for the current teacher
  Future<void> fetchPendingCount(String userId) async {
    try {
      final count = await _classesRepository.getPendingInvitesCount(userId);

      // Only show badge if count > 0, otherwise set to null
      state = count != null && count > 0 ? count : null;
    } catch (e) {
      CustomErrorHandler.logDebug(
          '🔍 BADGE DEBUG - Error fetching pending count: $e');
      state = null;
    }
  }
}

final pendingInvitesBadgeProvider =
    StateNotifierProvider<PendingInvitesBadgeNotifier, int?>((ref) {
  return PendingInvitesBadgeNotifier(
      ClassesRepository(apiService: GraphQLClientSingleton()));
});
