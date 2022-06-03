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
}
