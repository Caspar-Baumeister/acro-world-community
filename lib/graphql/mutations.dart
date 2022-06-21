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
}
