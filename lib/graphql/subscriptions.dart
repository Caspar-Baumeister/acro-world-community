import 'package:acroworld/graphql/fragments.dart';

class Subscriptions {
  static const String communityMessages = """
    subscription CommunityMessagesSubscription(\$community_id: uuid) {
      community_messages(where: {community_id: {_eq: \$community_id}}, order_by: {created_at: desc}) {
        id
        content
        created_at
        from_user {
          image_url
          name
          id
        }
      }
    }
    """;

  static const String getUserCommunityMessageCount = """
  subscription GetMyCommunityPreview(\$community_id: uuid!, \$last_visited_at: timestamptz!) {
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
  """;

  static const subscribeUserCommunities = """
  subscription subscribeUserCommunities(\$query: String!) {
  me {
    communities(where: {community: {name: {_ilike: \$query}}, _and: {community: {confirmation_status: {_eq: Confirmed}}}}, limit: 50, order_by: {community: {community_messages_aggregate: {max: {created_at: desc_nulls_last}}}}) {
      last_visited_at
      community_id
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
  """;
}
