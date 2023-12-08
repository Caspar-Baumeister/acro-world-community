import 'package:acroworld/graphql/fragments.dart';
import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decode/jwt_decode.dart';

class UserProvider extends ChangeNotifier {
  User? activeUser;
  String? token;
  String? refreshToken;
  final GraphQLClient client;

  UserProvider({required this.client});

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

    print("result: ${result.data}");

    if (result.hasException) {
      throw result.exception!;
    }
    // creates a User object from the result
    try {
      activeUser = User.fromJson(result.data!["update_users_by_pk"]);
    } catch (e) {
      print(e);

      rethrow;
    }

    notifyListeners();
    return;

    // Handle the response as needed
  }

  getId() {
    Map<String, dynamic> parseJwt = Jwt.parseJwt(token!);
    return parseJwt["user_id"];
  }

  // create a hasChanged function, that checks if userdata has changed based on name, email, gender id and level id
  Map<String, dynamic>? getChanges(
    String name,
    String? genderId,
    String? levelId,
  ) {
    // if the active user is null, return false
    if (activeUser == null) {
      return null;
    }

    Map<String, dynamic> changes = {};

    // else checks if the name, email, genderId and levelId are the same as the active user
    // return true if they are not the same

    if (activeUser!.gender?.id != genderId) {
      changes["acro_role_id"] = genderId;
    }
    if (activeUser!.level?.id != levelId) {
      changes["level_id"] = levelId;
    }
    if (activeUser!.name != name) {
      changes["name"] = name;
    }
    print("changes: $changes");
    return changes;
  }

  // a function that updates the user based on the input
  Future updateUserFromChanges(Map<String, dynamic>? changes) async {
    if (changes == null || changes.isEmpty) {
      return null;
    }

    await updateUserByJson(activeUser!.id!, changes);
  }

  Future<bool> validToken() async {
    if (token == null) {
      return false;
    }
    if (!isTokenExpired()) {
      return true;
    }
    return await refreshTokenFunction();
  }

  Future<bool> setUserFromToken() async {
    if (token == "" || token == null) {
      activeUser = null;
      return false;
    }
    try {
      final response = await Database(token: token).authorizedApi("""query {
            me { 
             ${Fragments.userFragment}
            }
          }""");

      if (response?["data"]?["me"]?[0] == null) {
        return false;
      }

      Map<String, dynamic> user = response["data"]["me"][0];

      if (user["id"] == null || user["name"] == null) {
        return false;
      }
      activeUser = User.fromJson(user);

      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool isTokenExpired() {
    if (token == null) {
      return true;
    }
    return Jwt.isExpired(token!);
  }

  Future<bool> refreshTokenFunction() async {
    String? email = CredentialPreferences.getEmail();
    String? password = CredentialPreferences.getPassword();

    if (email == null || password == null) {
      return false;
    }

    // get the token trough the credentials
    // (invalid credentials) return false
    if (isTokenExpired()) {
      final response = await Database().loginApi(email, password);

      String? newToken = response?["data"]?["login"]?["token"];
      String? newRefreshToken = response?["data"]?["login"]?["refreshToken"];

      if (newToken == null) {
        return false;
      }
      token = newToken;
      refreshToken = newRefreshToken;
      await setUserFromToken();
    }

    // safe the user to provider
    return true;
  }
}
