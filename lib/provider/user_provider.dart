import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/querys.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';

class UserProvider extends ChangeNotifier {
  User? _activeUser;
  String? _token;
  Map<String, dynamic>? _parsedJwt;

  // getter
  User? get activeUser => _activeUser;
  String? get token => _token;
  Map<String, dynamic>? get parsedJwt => _parsedJwt;

  set token(String? token) => _token = token;

  getId() {
    Map<String, dynamic> parseJwt = Jwt.parseJwt(token!);
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

  setUserFromToken() async {
    if (token == "" || token == null) {
      _activeUser = null;
      return;
    }

    // TODO fill in rest of data
    final response = await Database(token: _token).authorizedApi(Querys.me);
    Map user = response["data"]["me"][0];
    _activeUser =
        User(id: user["id"], name: user["name"], imageUrl: user["image_url"]);
  }

  bool isTokenExpired() {
    if (token == null) {
      return true;
    }
    return Jwt.isExpired(token!);
  }

  Future<bool> refreshToken() async {
    String? _email = CredentialPreferences.getEmail();
    String? _password = CredentialPreferences.getPassword();

    if (_email == null || _password == null) {
      return false;
    }

    // get the token trough the credentials
    // (invalid credentials) return false
    if (isTokenExpired()) {
      String? _newToken = await Database().loginApi(_email, _password);
      if (_newToken == null) {
        return false;
      }
      _token = _newToken;
      setUserFromToken();
    }

    // safe the user to provider
    return true;
  }
}
