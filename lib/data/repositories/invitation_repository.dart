import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InvitationRepository {
  final GraphQLClientSingleton apiService;

  InvitationRepository({required this.apiService});

  // get all invitations
  // return a map of invitations and the aggregated count
  Future<Map<String, dynamic>> getInvitations(int limit, int offset) async {
    QueryOptions queryOptions = QueryOptions(
        document: Queries.getCreatedInvitesPageableQuery,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"limit": limit, "offset": offset});

    final result = await apiService.query(queryOptions);

    if (result.hasException) {
      throw Exception(
          'Failed to get invitations. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null &&
        result.data!["created_invites"] != null &&
        result.data!["created_invites_aggregate"] != null) {
      return {
        // List of Invitation Model
        "invitations": List<InvitationModel>.from(result
            .data!["created_invites"]
            .map((i) => InvitationModel.fromJson(i))),
        "count": result.data!["created_invites_aggregate"]["aggregate"]["count"]
      };
    } else {
      throw Exception('Failed to get invitations');
    }
  }
}
