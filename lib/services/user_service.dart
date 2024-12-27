import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/user_model.dart';
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

  // verify code
  Future<bool?> verifyCode(String code) async {
    print("verifyCode: $code");
    const String mutation = """
    mutation verifyCode(\$code: String!) {
      verify_email(code: \$code)
    }
  """;

    final QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {
          'code': code,
        },
      ),
    );

    print("verifyCode: ${result.data}");

    if (result.hasException) {
      throw Exception(
          'Failed to verify email. Status code: ${result.exception?.raw.toString()}');
    }

    return result.data!['verify_email'];
  }

  // get user by id
  Future<User> getUserById(String userId) async {
    try {
      final QueryResult result = await client.query(
        QueryOptions(
          document: Queries.getUserById,
          variables: {
            'userId': userId,
          },
        ),
      );

      print("getUserById: ${result.data!['users_by_pk']}");

      if (result.hasException) {
        CustomErrorHandler.captureException(result.exception);
        throw Exception(
            'Failed to get user by id. Status code: ${result.exception?.raw.toString()}');
      }

      return User.fromJson(result.data!['users_by_pk']);
    } catch (e) {
      throw Exception('Failed to get user by id. Status code: ${e.toString()}');
    }
  }
}
