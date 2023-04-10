import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';

class UserProvider extends ChangeNotifier {
  User? _activeUser;
  String? _token;

  // getter
  User? get activeUser => _activeUser;
  String? get token => _token;

  set token(String? token) => _token = token;

  getId() {
    Map<String, dynamic> parseJwt = Jwt.parseJwt(_token!);
    return parseJwt["user_id"];
  }

  Future<bool> validToken() async {
    if (_token == null) {
      return false;
    }
    if (!isTokenExpired()) {
      return true;
    }
    return await refreshToken();
  }

  Future<bool> setUserFromToken() async {
    if (token == "" || token == null) {
      _activeUser = null;
      return false;
    }

    // TODO fill in rest of data
    final response = await Database(token: _token).authorizedApi("""query {
            me { 
              bio 
              id 
              image_url 
              last_proposed_community_at 
              name
              user_roles {
                role {
                  id
                  name
                }
              }
            }
          }""");

    if (response["data"]?["me"]?[0] == null) {
      return false;
    }
    Map<String, dynamic> user = response["data"]["me"][0];
    if (user["id"] == null || user["name"] == null) {
      return false;
    }
    _activeUser = User.fromJson(user);

    notifyListeners();
    return true;
  }

  bool isTokenExpired() {
    if (token == null) {
      return true;
    }
    return Jwt.isExpired(token!);
  }

  Future<bool> refreshToken() async {
    String? email = CredentialPreferences.getEmail();
    String? password = CredentialPreferences.getPassword();

    print("inside refreshToken with $email");
    print("inside refreshToken with $password");
    if (email == null || password == null) {
      return false;
    }

    print("token");
    print(token);

    // get the token trough the credentials
    // (invalid credentials) return false
    if (isTokenExpired()) {
      final response = await Database().loginApi(email, password);

      String? newToken = response?["data"]?["login"]?["token"];

      if (newToken == null) {
        print("response");
        print(response);
        return false;
      }
      _token = newToken;
      await setUserFromToken();
    }

    // safe the user to provider
    return true;
  }
}
