import 'package:acroworld/graphql/fragments.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Queries {
  static final jamsByCommunityId = gql("""
    query JamsByCommunityId(\$communityId: uuid) {
      jams(where: {community_id: {_eq: \$communityId}}) {
        ${Fragments.jamFragment}
      }
    }
    """);

  static final getAllJamsFromMyCommunities = gql("""
    query GetMyCommunities {
        me {
          communities {
            community {
              jams {
                ${Fragments.jamFragment}
              }
            }
          }
        }
      }
    """);
}
