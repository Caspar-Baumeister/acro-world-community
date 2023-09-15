class Fragments {
  static const eventInstanceWithEventTemplate = """
    event_template {
      description
      name
      created_at
      id
      location
      location_name
      updated_at
    }
    description
    name
    created_at
    early_bird_end_date
    early_bird_start_date
    end_date
    event_template_id
    id
    is_cancelled
    start_date
    updated_at

""";

  static const classEventFragment = """
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
    participants {
      user {
        id
        name
        acro_role_id
      }
    }
    class {
      booking_email
      max_booking_slots
      class_booking_options {
        booking_option {
          commission
          discount
          id
          price
          subtitle
          title
        }
      }
      city
      class_pass_url
      description
      id
      image_url
      location
      location_name
      name
      pricing
      requirements
      usc_url
      website_url
      class_teachers {
        teacher {
          id
          name
          type
          confirmation_status
          is_organization
          images {
            id
            image {
              id
              url
            }
            is_profile_picture
          }
        }
      }
      class_levels {
        level {
          name
          id
        }
      }
    }
""";

  static const eventFragment = """created_at
    created_by_id
    description
    end_date
    end_date_tz
    event_source
    event_type
    id
    is_highlighted
    links
    location
    location_city
    location_country
    location_name
    main_image_url
    name
    origin_creator_name
    pricing
    start_date
    start_date_tz
    updated_at
    url
    pretix_name
    origin_location_name
    user_participants {
      event_id
      id
      user_id
    }
    teachers {
      teacher {
        id
        name
        confirmation_status
        is_organization
        images {
          id
          image {
            id
            url
          }
          is_profile_picture
        }
      }
    }""";

  static const teacherFragment = """
  created_at
  description
  type
  id
  location_name
  community_id
  name
  user_id
  is_organization
  
  user_likes_aggregate {
    aggregate {
      count
    }
  }
  teacher_levels {
    level {
      name
      id
    }
  }
  images {
    image {
      url
    }
    is_profile_picture
  }
  """;

  static const userFragment = """
  id
  name
  image_url
  bio
  acro_role 
    {
      name
      id
    }
  """;

  static const String communityFragment = """
  id
  name
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
