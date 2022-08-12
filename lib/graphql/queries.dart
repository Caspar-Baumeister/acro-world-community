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
        last_visited_at community_id
        community {
          ${Fragments.communityFragment}
          community_messages(limit: 1, order_by: {created_at: desc}) {
          content
          created_at
          from_user {
            name
          }
        }
        }
      }
    }
  }
  """);

  static final getUserCommunityMessageCount = gql("""
  query GetMyCommunityPreview(\$community_id: uuid!, \$last_visited_at: timestamptz!) {
  user_communities(where: {community_id: {_eq: \$community_id}}) {
    community {
        community_messages_aggregate(where: {created_at: {_gte: \$last_visited_at}}) {
          aggregate {
            count
          }
        }
      }
    }
  }
  """);

  static final getMe = gql("""
  query GetMe {
    me {
      id
      image_url
      fcm_token
      bio
      created_at
      name
    }
  }
  """);
}
