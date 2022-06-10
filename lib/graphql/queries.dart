class Queries {
  static const String jamsByCommunityId = """
    query JamsByCommunityId(\$communityId: uuid) {
      jams(where: {community_id: {_eq: \$communityId}}) {
        created_at
        created_by {
          name
          image_url
          id
          bio
        }
        date
        id
        info
        latitude
        longitude
        name
        community_id
        participants {
          user {
            name
            id
            image_url
            bio
          }
        }
      }
    }
    """;
}
