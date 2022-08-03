import 'dart:convert';
import 'package:http/http.dart' as http;

class Database {
  final uri = Uri.https("bro-devs.com", "hasura/v1/graphql");
  String? token;

  Database({this.token});

  Future participateToJam(String uid, String jid) {
    return authorizedApi("""
      mutation MyMutation {
  insert_jam_participants(objects: {jam_id: "$jid", user_id: "$uid"}) {
    id
  }
}""");
  }

  Future createCommunity(String name) {
    return authorizedApi("""
      mutation {
        insert_communities(objects: {name: "$name"}) {
          affected_rows
          returning {
            name
            id
          }
        }
      }""");
  }

  getJamsUserIsInCommunity(String uid) {
    return authorizedApi("""  
      query MyQuery{
        jams(where: {participants: {id: {_eq: "$uid"}}}, order_by: {date: asc}) {
          date
          info
          latitude
          longitude
          name
          id
        }
      }""");
  }

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

  getJamsParticipated(String uid) {
    return authorizedApi("""
      query MyQuery {
  me {
    participates(order_by: {jam: {date: asc}}) {
      jam {
        name
        longitude
        latitude
        info
        id
        date
        created_by_id
        created_at
        community_id
      }
    }
  }
}""");
  }

  getJamsFromMyComs() {
    return authorizedApi("""
      query MyQuery {
        me {
          communities {
            community {
              jams {
                community_id
                created_at
                created_by_id
                date
                id
                info
                latitude
                longitude
                name
              }
            }
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

  getAllOtherCommunities(String uid, String query) {
    return authorizedApi("""
      query MyQuery {
  communities(where: {_not: {users: {user_id: {_eq: "$uid"}}}, name: {_ilike: "%$query%"}}, limit: 15) {
    id
    name
    confirmed
    latitude
    longitude
  }
}""");
  }

  getUserCommunities(String uid) {
    return authorizedApi("""
      query MyQuery {
        communities(where: {users: {user_id: {_eq: "$uid"}}}) {
          name
          id
        }
      }""");
  }

  insertJam(
    String communityId,
    String name,
    String date,
    String info,
    double latitude,
    double longitude,
  ) {
    return authorizedApi("""
      mutation MyMutation {
        insert_jams_one(object: {info: "$info", date: "$date", latitude: "$latitude", longitude: "$longitude", name: "$name", community_id: "$communityId"}) {
          id
        }
      }""");
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
      return jsonDecode(response.body.toString())["data"]?["login"]?["token"];
    } catch (e) {
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
      print(e.toString());
    }
    return null;
  }
}
