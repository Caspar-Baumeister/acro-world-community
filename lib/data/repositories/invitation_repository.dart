import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InvitationRepository {
  final GraphQLClientSingleton apiService;

  InvitationRepository({required this.apiService});

  // get all invitations where current user is the invited user
  // return a map of invitations and total count for pagination
  Future<Map<String, dynamic>> getInvitations(
      int limit, int offset, String userId) async {
    print('🔍 INVITES DEBUG - Repository getInvitations called:');
    print('  limit: $limit');
    print('  offset: $offset');
    print('  userId: $userId');

    QueryOptions queryOptions = QueryOptions(
        document: Queries.getInvitedInvitesPageableQuery,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"limit": limit, "offset": offset, "user_id": userId});

    print('🔍 INVITES DEBUG - Repository Query Options:');
    print('  document: getInvitedInvitesPageableQuery');
    print('  variables: ${queryOptions.variables}');
    print('  fetchPolicy: ${queryOptions.fetchPolicy}');

    final result = await apiService.query(queryOptions);

    print('🔍 INVITES DEBUG - Repository Query Result:');
    print('  hasException: ${result.hasException}');
    if (result.hasException) {
      print('  exception: ${result.exception}');
    }
    print('  data: ${result.data}');

    if (result.hasException) {
      throw Exception(
          'Failed to get invitations. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null &&
        result.data!["invites"] != null &&
        result.data!["invites_aggregate"] != null) {
      print('🔍 INVITES DEBUG - Repository parsing data:');
      print('  invites count: ${result.data!["invites"].length}');
      print('  invites_aggregate: ${result.data!["invites_aggregate"]}');

      final invitations = List<InvitationModel>.from(
          result.data!["invites"].map((i) => InvitationModel.fromJson(i)));

      final count = result.data!["invites_aggregate"]["aggregate"]["count"];

      print('🔍 INVITES DEBUG - Repository parsed result:');
      print('  invitations.length: ${invitations.length}');
      print('  total count: $count');
      for (int i = 0; i < invitations.length && i < 3; i++) {
        print(
            '  invitation[$i]: id=${invitations[i].id}, email=${invitations[i].email}, entity=${invitations[i].entity}');
      }

      return {"invitations": invitations, "count": count};
    } else {
      print('🔍 INVITES DEBUG - Repository Error: No data or missing fields');
      print('  data is null: ${result.data == null}');
      print('  invites is null: ${result.data?["invites"] == null}');
      print(
          '  invites_aggregate is null: ${result.data?["invites_aggregate"] == null}');
      throw Exception('Failed to get invitations');
    }
  }
}
