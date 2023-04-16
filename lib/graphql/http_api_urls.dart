import 'dart:convert';
import 'package:acroworld/environment.dart';
import 'package:http/http.dart' as http;

class Database {
  final uri = Uri.https(AppEnvironment.backendHost, "hasura/v1/graphql");
  String? token;

  Database({this.token});

  insertUserCommunitiesOne(String communityId, String uid) async {
    return authorizedApi(
        """mutation MyMutation {insert_user_communities(objects: {community_id: "$communityId", user_id: "$uid"}) {affected_rows}}""");
  }

  deleteUserCommunitiesOne(String communityId) async {
    return authorizedApi("""mutation MyMutation {
      delete_user_communities(where: {community_id: {_eq: "$communityId"}}) {
        affected_rows
      }
    }""");
  }

  isUserInCommunity(String communityId) async {
    return authorizedApi("""query MyQuery {
      me {
        communities(where: {community_id: {_eq: "$communityId"}}) {
          community_id
        }
      }
    }""");
  }

  Future getCommunityJams(String cId) {
    return authorizedApi(""" query MyQuery {
      jams(where: {community_id: {_eq: "$cId"}}) {
        created_at
        created_by_id
        date
        id
        info
        latitude
        longitude
        name
        community_id
      }
    }""");
  }

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
                "mutation MyMutation {login(input: {email: \"$email\", password: \"$password\"}){token}}"
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
