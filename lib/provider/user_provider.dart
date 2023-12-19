import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/fragments.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserProvider extends ChangeNotifier {
  User? _activeUser;
  GraphQLClient client;

  UserProvider({required this.client});

  User? get activeUser {
    return _activeUser;
  }

  // delete active user
  void deleteActiveUser() {
    _activeUser = null;
    notifyListeners();
  }

  Future<void> updateUserByJson(
      String userId, Map<String, dynamic> updates) async {
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

    final result = await client.mutate(options);

    if (result.hasException) {
      throw result.exception!;
    }
    // creates a User object from the result
    try {
      _activeUser = User.fromJson(result.data!["update_users_by_pk"]);
    } catch (e) {
      CustomErrorHandler.captureException(e.toString());
      rethrow;
    }
    notifyListeners();
    return;
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
  Future updateUserFromChanges(Map<String, dynamic>? changes) async {
    if (changes == null || changes.isEmpty) {
      return null;
    }
    await updateUserByJson(_activeUser!.id!, changes);
  }

  Future<bool> setUserFromToken() async {
    if (await AuthProvider().getToken() == null) {
      print("no token");
      _activeUser = null;
      notifyListeners();
      return false;
    }
    // create the options
    QueryOptions options = QueryOptions(
      document: Queries.getMe,
    );
    // get the result
    final result = await client.query(options);

    // if there is an exception, throw it
    if (result.hasException) {
      CustomErrorHandler.captureException(result.exception.toString());
      return false;
    }
    // creates a User object from the result
    try {
      _activeUser = User.fromJson(result.data!["me"][0]);
      print("set active user id: ${_activeUser?.id}");
      notifyListeners();
      return true;
    } catch (e) {
      CustomErrorHandler.captureException(e.toString());
      return false;
    }
  }
}
