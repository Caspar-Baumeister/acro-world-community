import 'dart:convert';
import 'package:http/http.dart' as http;

class Database {
  final uri = Uri.https("bro-devs.com", "hasura/v1/graphql");
  String? token;
  String? userId;

  Database({this.token});

  userJamsApi() async {
    return await http.post(uri,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: json.encode({
          'query': '''
            query MyQuery {
              jams {
                name
              }
          }'''
        }));
  }

  fakeToken() async {
    try {
      final response = await http.post(uri,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({
            'query': '''
                mutation MyMutation {
                  login(
                    input: {
                      email: "foo@bar.com", password: "penis123"
                    }
                  ) 
                  {
                    token
                    user {
                      id
                    }
                  }
                }'''
          }));
      Map responseDecode = jsonDecode(response.body.toString());
      token = responseDecode["data"]["login"]["token"];
      userId = responseDecode["data"]["login"]["user"]["id"];
    } catch (e) {
      print(e.toString());
    }
  }

  insertUserCommunitiesOne(String communityId) async {
    print(communityId);
    print(userId);
    try {
      final response = await http.post(uri,
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $token'
          },
          body: json.encode({
            'query':
                "mutation MyMutation {insert_user_communities_one(object: {community_id: $userId, user_id: $communityId}){community_id}}"
          }));
      return jsonDecode(response.body.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  insertCommunityMessagesOne(
    String communityId,
    String content,
  ) async {
    try {
      final response = await http.post(uri,
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $token'
          },
          body: json.encode({
            'query':
                "mutation MyMutation {insert_community_messages_one(object: {communty_id: \"$communityId\", content: \"$content\"}) {from_user_id}}"
          }));
      print(response.body);
      return jsonDecode(response.body.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  authorizedApi(String query) async {
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
      print(response.body);
      return jsonDecode(response.body.toString())["data"]["login"]["token"];
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
