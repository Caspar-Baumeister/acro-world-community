import 'dart:convert';

import 'package:acroworld/environment.dart';
import 'package:acroworld/exceptions/error_handler.dart';
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
                "mutation MyMutation {loginWithRefreshToken_v2(input: {refreshToken: \"$refreshToken\"}){token refreshToken}}"
          }));
      return jsonDecode(response.body.toString());
    } catch (e, s) {
      // ignore: avoid_print
      CustomErrorHandler.captureException(e.toString(), stackTrace: s);
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
                "mutation MyMutation {login_v2(input: {email: \"$email\", password: \"$password\"}){token refreshToken}}"
          }));

      return jsonDecode(response.body.toString());
    } catch (e, s) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: s);
      return {
        "error": true,
        "message": e.toString(),
        "errors": [e.toString()]
      };
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
    } catch (e, s) {
      // ignore: avoid_print
      CustomErrorHandler.captureException(e.toString(), stackTrace: s);
    }
    return null;
  }

  Future registerApi(String email, String password, String name,
      {bool? isNewsletterEnabled, String? imageUrl}) async {
    try {
      // Build the input object dynamically
      final inputParts = <String>[
        'email: "$email"',
        'password: "$password"',
        'name: "$name"',
        'isNewsletterEnabled: ${isNewsletterEnabled == true ? "true" : "false"}',
      ];

      // Add imageUrl if provided
      if (imageUrl != null && imageUrl.isNotEmpty) {
        inputParts.add('imageUrl: "$imageUrl"');
      }

      final inputString = inputParts.join(', ');

      final response = await http.post(uri,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({
            'query':
                """mutation MyMutation {register_v2(input: {$inputString}){token refreshToken}}"""
          }));
      return jsonDecode(response.body.toString());
    } catch (e, s) {
      // ignore: avoid_print
      CustomErrorHandler.captureException(e.toString(), stackTrace: s);
    }
    return null;
  }
}
