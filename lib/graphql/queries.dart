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

  static final getPlaces = gql("""
  query GetPlaces(\$query: String!) {
    places(searchQuery: \$query) {
      id
      description
      matched_substrings {
        length
        offset
      }
    }
  }
  """);

  static final getPlace = gql("""
  query GetPlaces(\$id: String!) {
    place(id: \$id) {
      description
      id
      latitude
      longitude
    }
  }
  """);

  static final getUserCommunities = gql("""
  query GetMyCommunities(\$query: String!) {
    me {
      communities (where: {community: {name: {_ilike: \$query}}}) {
        community {
          ${Fragments.communityFragment}
        }
      }
    }
  }
  """);
}
