class Fragments {
  static const userFragment = """
  id
  name
  image_url
  bio
  """;

  static const String communityFragment = """
  id
  name
  confirmed
  latitude
  longitude
  """;

  static const String jamFragment = """
    created_at
    created_by {
      $userFragment
    }
    date
    id
    info
    latitude
    longitude
    name
    community_id
    created_by_id
    participants {
      user {
        $userFragment
      }
    }
    community {
      $communityFragment
    }
""";
}
