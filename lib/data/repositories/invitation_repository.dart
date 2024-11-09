import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InvitationRepository {
  final GraphQLClientSingleton apiService;

  InvitationRepository({required this.apiService});

  Future<bool> inviteByEmail(String email) async {
    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.inviteByEmail,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "email": email,
      },
    );

    final result = await apiService.mutate(mutationOptions);

    if (result.hasException) {
      throw Exception(
          'Failed to invite user by email. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null && result.data!["invite"]?["success"] != null) {
      return result.data!["invite"]["success"];
    } else {
      throw Exception(
          'Failed to invite user by email, no data, with result $result');
    }
  }

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

  // check if invite is possible
  // return isInvitedByYou and isAlreadyRegistered
  Future<Map<String, bool>> checkInvitePossibility(String email) async {
    QueryOptions queryOptions = QueryOptions(
        document: Queries.checkInvitePossible,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"email": email});

    final result = await apiService.query(queryOptions);

    if (result.hasException) {
      throw Exception(
          'Failed to check invite possibility. Status code: ${result.exception?.raw.toString()}');
    }
    print("Result: $result");

    if (result.data == null) {
      throw Exception('Failed to check invite possibility');
    } else {
      print(
          "isInvitedByYou: ${result.data!["created_invites"].isNotEmpty ?? false}");
      print(
          "isAlreadyRegistered: ${result.data!["users"].isNotEmpty ?? false}");

      return {
        "isInvitedByYou": result.data!["created_invites"].isNotEmpty ?? false,
        "isAlreadyRegistered": result.data!["users"].isNotEmpty ?? false
      };
    }
  }
}
