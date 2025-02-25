import 'package:acroworld/data/graphql/fragments.dart';
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

  // delete active user
  void deleteActiveUser() {
    _activeUser = null;
    notifyListeners();
  }

  Future<bool> updateUserByJson(
      String userId, Map<String, dynamic> updates) async {
    print("USERID: $userId");
    String mutation = '''
    mutation updateUser(\$user_id: uuid!, \$updates: users_set_input!) {
      update_users_by_pk(pk_columns: {id: \$user_id}, _set: \$updates) {
        ${Fragments.userFragment}
      }
    }
  ''';

    MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'user_id': userId,
        'updates': updates,
      },
    );

    final graphQLClient = GraphQLClientSingleton().client;

    final result = await graphQLClient.mutate(options);

    if (result.hasException) {
      CustomErrorHandler.captureException(result.exception.toString(),
          stackTrace: result.exception!.originalStackTrace);
      return false;
    }
    // creates a User object from the result
    try {
      _activeUser = User.fromJson(result.data!["update_users_by_pk"]);
    } catch (e, stackTrace) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: stackTrace);
      return false;
    }
    notifyListeners();
    return true;
  }

  // create a hasChanged function, that checks if userdata has changed based on name, email, gender id and level id
  Map<String, dynamic>? getChanges(
    String name,
    String? genderId,
    String? levelId,
  ) {
    // if the active user is null, return false
    if (_activeUser == null) {
      return null;
    }
    Map<String, dynamic> changes = {};
    // else checks if the name, email, genderId and levelId are the same as the active user
    // return true if they are not the same

    if (_activeUser!.gender?.id != genderId) {
      changes["acro_role_id"] = genderId;
    }
    if (_activeUser!.level?.id != levelId) {
      changes["level_id"] = levelId;
    }
    if (_activeUser!.name != name) {
      changes["name"] = name;
    }
    return changes;
  }

  // a function that updates the user based on the input
  Future<bool> updateUserFromChanges(Map<String, dynamic>? changes) async {
    if (changes == null || changes.isEmpty) {
      return false;
    }
    return await updateUserByJson(_activeUser!.id!, changes);
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
