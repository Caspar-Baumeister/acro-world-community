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

  static const String classFragment = """
    city
    description
    id
    location_name
    name
    location
    pricing
    requirements
    usc_url
    class_pass_url
    website_url
    image_url
    location
    class_events {
      end_date
      start_date
      is_cancelled
      participants_aggregate {
        aggregate {
          count
        }
      }
    }
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
