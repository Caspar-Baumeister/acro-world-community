import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserService {
  final client = GraphQLClientSingleton().client;

  UserService();

  Future<bool> sendEmailVerification() async {
    const String mutation = """
    mutation {
      send_verification_email {
        success
      }
    }
  """;

    final QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
      ),
    );

    if (result.hasException) {
      CustomErrorHandler.captureException(result.exception);
      return false;
    }

    return result.data!['send_verification_email']['success'];
  }
}
