import 'package:acroworld/graphql/fragments.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Mutations {
  static final insertCommunityMessage = gql("""
    mutation InsertCommunityMessage(\$content: String, \$communityId: uuid) {
      insert_community_messages(objects: {content: \$content, community_id: \$communityId}) {
        affected_rows
      }
    }
  """);

  static final particapteToJam = gql("""
    mutation InsertJamParticipants(\$jamId: uuid) {
      insert_jam_participants(objects: {jam_id: \$jamId}) {
        affected_rows
        returning {
          jam {
            ${Fragments.jamFragment}
          }
        }
      }
    }
  """);

  static final removeJamParticipation = gql("""
    mutation RemoveJamParticipation(\$jamId: uuid) {
      delete_jam_participants(where: {jam_id: {_eq: \$jamId}}) {
        affected_rows
        returning {
          jam {
            ${Fragments.jamFragment}
          }
        }
      }
    }
  """);

  static final insertJam = gql("""
    mutation InsertJam(\$communityId: uuid, \$date: timestamptz, \$latitude: numeric, \$longitude: numeric, \$name: String, \$info: String) {
      insert_jams_one(object: {community_id: \$communityId, date: \$date, latitude: \$latitude, longitude: \$longitude, name: \$name, info: \$info}) {
         ${Fragments.jamFragment}
      }
    }
  """);

  static final updateJam = gql("""
    mutation UpdateJam(\$jamId: uuid!, \$date: timestamptz, \$latitude: numeric, \$longitude: numeric, \$name: String, \$info: String) {
      update_jams_by_pk(pk_columns: {id: \$jamId}, _set: {name: \$name, longitude: \$longitude, latitude: \$latitude, info:  \$info, date: \$date}) {
        ${Fragments.jamFragment}
      }
    }
  """);

  static final deleteJam = gql("""
    mutation DeleteJam(\$jamId: uuid) {
      delete_jams(where: {id: {_eq: \$jamId}}) {
        affected_rows
      }
    }
  """);

  static final insertCommunity = gql("""
    mutation InsertCommunity(\$latitude: numeric, \$longitude: numeric, \$name: String) {
      insert_communities_one(object: {latitude: \$latitude, longitude: \$longitude, name: \$name}) {
        id
      }
    }
  """);

  static final updateFcmToken = gql("""
    mutation UpdateFcmToken(\$fcmToken: String!) {
      update_users(_set: {fcm_token: \$fcmToken}, where: {}) {
        affected_rows
      }
    }
  """);

  static final updateLastVisetedAt = gql("""
  mutation updateLastVisetedAt(\$community_id: uuid, \$user_id: uuid) {
  update_user_communities(where: {community_id: {_eq: \$community_id}, user_id: {_eq: \$user_id}}, _set: {last_visited_at: "now()"}) {
    affected_rows
  }
}
""");

  static final likeTeacher = gql("""
  mutation likeTeacher(\$teacher_id: uuid) {
  insert_teacher_likes(objects: {teacher_id: \$teacher_id}) {
    affected_rows
  }
}
""");

  static final unlikeTeacher = gql("""
  mutation unlikeTeacher(\$teacher_id: uuid, \$user_id: uuid) {
  delete_teacher_likes(where: {teacher_id: {_eq: \$teacher_id}, user_id: {_eq: \$user_id}}) {
    affected_rows
  }
}

""");
}
