import 'dart:convert';

import 'package:acroworld/environment.dart';
import 'package:http/http.dart' as http;

class Database {
  final uri = Uri.https(AppEnvironment.backendHost, "hasura/v1/graphql");
  String? token;

  Database({this.token});

  Future authorizedApi(String query) async {
    try {
      final response = await http.post(uri,
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $token'
          },
          body: json.encode({'query': query}));
      return jsonDecode(response.body.toString());
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future loginApi(String email, String password) async {
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
    }
    return null;
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

  Future registerApi(String email, String password, String name) async {
    try {
      final response = await http.post(uri,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({
            'query':
                "mutation MyMutation {register(input: {email: \"$email\", password: \"$password\", name: \"$name\"}){token}}"
          }));
      return jsonDecode(response.body.toString());
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return null;
  }
}
