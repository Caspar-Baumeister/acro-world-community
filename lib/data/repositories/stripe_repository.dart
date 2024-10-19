import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StripeRepository {
  final GraphQLClientSingleton apiService;

  StripeRepository({required this.apiService});

  Future<String?> getStripeLoginLink() async {
    QueryOptions queryOptions = QueryOptions(
      document: Queries.getStripeLoginLink,
      fetchPolicy: FetchPolicy.networkOnly,
    );
    try {
      final graphQLClient = GraphQLClientSingleton().client;
      QueryResult<Object?> result = await graphQLClient.query(queryOptions);

      // Check for a valid response
      if (result.hasException) {
        throw Exception(
            'Failed to get stripe login link. Status code: ${result.exception?.raw.toString()}');
      }

      return result.data!['stripe_login_link'];
    } catch (e) {
      throw Exception('Failed to get stripe login link: $e');
    }
  }

  //createStripeUser
  Future<String?> createStripeUser() async {
    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.createStripeUser,
      fetchPolicy: FetchPolicy.networkOnly,
    );
    try {
      final graphQLClient = GraphQLClientSingleton().client;
      QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);
      print("result: $result");

      // Check for a valid response
      if (result.hasException) {
        throw Exception(
            'Failed to create stripe user. Status code: ${result.exception?.raw.toString()}');
      }

      return result.data!['create_stripe_user']['url'];
    } catch (e) {
      throw Exception('Failed to create stripe user: $e');
    }
  }
}
