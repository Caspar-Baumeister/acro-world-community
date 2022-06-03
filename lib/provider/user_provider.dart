// ignore_for_file: avoid_print

import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/services/database.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _activeUser;
  String? _token;
  Map<String, dynamic>? _parsedJwt;

  // getter
  UserModel? get activeUser => _activeUser;
  String? get token => _token;
  Map<String, dynamic>? get parsedJwt => _parsedJwt;

  Future<bool> validToken() async {
    if (_token == null) {
      return false;
    }
    if (!tokenIsExpired()) {
      return true;
    }
    return await refreshToken();
  }

  setUserFromToken(String token) {
    _token = token;
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    _parsedJwt = payload;

    String userId = payload["https://hasura.io/jwt/claims"]["x-hasura-user-id"];
    final response = Database(token: _token).getUserData(userId);

    print(response);
  }

  bool tokenIsExpired() {
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
    String? _newToken = await Database().loginApi(_email, _password);
    if (_newToken == null) {
      return false;
    }

    this.setUserFromToken(_newToken);

    // safe the user to provider
    _token = _newToken;
    return true;
  }
}
