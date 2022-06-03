class Mutations {
  static const String insertCommunityMessage = """
    mutation InsertCommunityMessage(\$content: String, \$communityId: uuid) {
      insert_community_messages(objects: {content: \$content, community_id: \$communityId}) {
        affected_rows
      }
    }
    """;
}
