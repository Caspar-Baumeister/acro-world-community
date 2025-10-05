import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Provider for managing the pending invites badge count
/// This is a simple, focused provider that only handles the badge count for user invites
class PendingInvitesBadgeNotifier extends StateNotifier<int?> {
  PendingInvitesBadgeNotifier() : super(null);

  final GraphQLClientSingleton _client = GraphQLClientSingleton();

  /// Fetch the pending invites count for the current user
  Future<void> fetchPendingCount(String userId) async {
    try {
      print(
          '🔍 BADGE DEBUG - Fetching pending invites count for userId: $userId');

      final result = await _client.client.query(
        QueryOptions(
          document: Queries.getPendingInvitesCountQuery,
          variables: {'user_id': userId},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        print('🔍 BADGE DEBUG - GraphQL error: ${result.exception}');
        state = null;
        return;
      }

      final count =
          result.data?['invites_aggregate']?['aggregate']?['count'] as int? ??
              0;
      print('🔍 BADGE DEBUG - Pending invites count: $count');

      // Only show badge if count > 0, otherwise set to null
      state = count > 0 ? count : null;
    } catch (e) {
      CustomErrorHandler.logDebug(
          '🔍 BADGE DEBUG - Error fetching pending count: $e');
      state = null;
    }
  }
}

final pendingInvitesBadgeProvider =
    StateNotifierProvider<PendingInvitesBadgeNotifier, int?>((ref) {
  return PendingInvitesBadgeNotifier();
});
