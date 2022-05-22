import 'dart:convert';
import 'package:http/http.dart' as http;

class Database {
  final uri = Uri.https("bro-devs.com", "hasura/v1/graphql");
  String? token;
  String? userId;

  Database({this.token});

  Future getCommunityJams(String cId) {
    return authorizedApi(""" query MyQuery {
  jams(where: {community_id: {_eq: "$cId"}}) {
    created_at
    created_by_id
    date
    id
    latitude
    longitude
    name
  }
}""");
  }

  insertUserCommunitiesOne(String communityId) async {
    return authorizedApi(
        "mutation MyMutation {insert_user_communities_one(object: {community_id: $userId, user_id: $communityId}){community_id}}");
  }

  insertCommunityMessagesOne(
    String communityId,
    String content,
  ) async {
    return authorizedApi(
        "mutation MyMutation {insert_community_messages_one(object: {communty_id: \"$communityId\", content: \"$content\"}) {from_user_id}}");
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
      print(e.toString());
    }
  }

  Future<String?> loginApi(String email, String password) async {
    try {
      final response = await http.post(uri,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({
            'query':
                "mutation MyMutation {login(input: {email: \"$email\", password: \"$password\"}){token}}"
          }));
      return jsonDecode(response.body.toString())["data"]["login"]["token"];
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future registerApi(String email, String password, String username) async {
    try {
      final response = await http.post(uri,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({
            'query':
                "mutation MyMutation {register(input: {email: \"$email\", password: \"$password\", userName: \"$password\"}){token}}"
          }));
      return jsonDecode(response.body.toString());
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
