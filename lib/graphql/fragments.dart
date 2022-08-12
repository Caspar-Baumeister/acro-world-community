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
  id
  created_at
  date
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
  created_by {
    $userFragment
  }
""";
}
