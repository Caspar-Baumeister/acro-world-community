class Subscriptions {
  static const String communityMessages = """
    subscription CommunityMessagesSubscription(\$community_id: uuid) {
      community_messages(where: {community_id: {_eq: \$community_id}}) {
        content
        from_user {
          image_url
          name
          id
        }
      }
    }
    """;
}
