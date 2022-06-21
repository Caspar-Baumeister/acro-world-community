class Mutations {
  static const String insertCommunityMessage = """
    mutation InsertCommunityMessage(\$content: String, \$communityId: uuid) {
      insert_community_messages(objects: {content: \$content, community_id: \$communityId}) {
        affected_rows
      }
    }
    """;

  static const String particapteToJam = """
    mutation InsertJamParticipants(\$jamId: uuid) {
      insert_jam_participants(objects: {jam_id: \$jamId}) {
        affected_rows
      }
    }
    """;

  static const String removeJamParticipation = """
    mutation RemoveJamParticipation(\$jamId: uuid) {
      delete_jam_participants(where: {jam_id: {_eq: \$jamId}}) {
        affected_rows
      }
    }
    """;
}
