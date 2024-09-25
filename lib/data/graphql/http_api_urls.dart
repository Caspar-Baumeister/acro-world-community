import 'dart:convert';

import 'package:acroworld/environment.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  final uri = Uri.https(AppEnvironment.backendHost, "hasura/v1/graphql");

  Future<Map<String, dynamic>> loginWithRefreshToken(
      String refreshToken) async {
    try {
      final response = await http.post(uri,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({
            'query':
                "mutation MyMutation {loginWithRefreshToken(input: {refreshToken: \"$refreshToken\"}){token refreshToken}}"
          }));
      return jsonDecode(response.body.toString());
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return {};
  }

  Future<Map> loginApi(String email, String password) async {
    try {
      final response = await http.post(uri,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({
            'query':
                "mutation MyMutation {login(input: {email: \"$email\", password: \"$password\"}){token refreshToken}}"
          }));

      return jsonDecode(response.body.toString());
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return {"error": true, "message": e.toString()};
    }
  }

  Future forgotPassword(String email) async {
    try {
      final response = await http.post(uri,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({
            'query':
                "mutation MyMutation {reset_password(input: {email: \"$email\"}) { success  } }"
          }));

      return jsonDecode(response.body.toString());
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return null;
  }

  Future registerApi(String email, String password, String name,
      {bool? isNewsletterEnabled}) async {
    try {
      final response = await http.post(uri,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({
            'query':
                """mutation MyMutation {register(input: {email: "$email", password: "$password", name: "$name", isNewsletterEnabled: ${isNewsletterEnabled == true ? "true" : "false"}}){token refreshToken}}"""
          }));
      return jsonDecode(response.body.toString());
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return null;
  }
}
