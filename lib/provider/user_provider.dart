import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserProvider extends ChangeNotifier {
  User? _activeUser;

  UserProvider();

  User? get activeUser {
    return _activeUser;
  }

  Future<bool> setUserFromToken() async {
    if (await TokenSingletonService().getToken() == null) {
      print("no token");
      _activeUser = null;
      notifyListeners();
      return false;
    }
    print("set user from token");

    // create the options
    QueryOptions options = QueryOptions(
        document: Queries.getMe, fetchPolicy: FetchPolicy.networkOnly);

    final graphQLClient = GraphQLClientSingleton().client;

    // get the result
    final result = await graphQLClient.query(options);

    // if there is an exception, throw it
    if (result.hasException) {
      CustomErrorHandler.captureException(result.exception.toString(),
          stackTrace: result.exception!.originalStackTrace);
      TokenSingletonService().logout();
      return false;
    } else if (result.data!["me"] == null || result.data!["me"].isEmpty) {
      print("no me found");
      _activeUser = null;
      TokenSingletonService().logout();
      notifyListeners();
      return false;
    }
    // creates a User object from the result
    try {
      _activeUser = User.fromJson(result.data!["me"][0]);

      print("active user: ${_activeUser!.name}");
      print("user id: ${_activeUser!.id}");
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      TokenSingletonService().logout();
      CustomErrorHandler.captureException(e.toString(), stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> checkEmailVerification() async {
    return await setUserFromToken()
        .then((_) => _activeUser?.isEmailVerified ?? false);
  }
}
