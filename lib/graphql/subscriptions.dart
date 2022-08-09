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
}
