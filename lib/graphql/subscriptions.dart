class Subscriptions {
  static const String fetchUsers = """
    subscription {
      community_messages {
        content
      }
    }
    """;
}
