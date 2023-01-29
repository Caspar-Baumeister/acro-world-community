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
    class_levels {
      level {
        name
      }
    }
    class_events {
      class_id
      created_at
      end_date
      id
      is_cancelled
      start_date
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
