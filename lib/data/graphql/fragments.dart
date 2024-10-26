class Fragments {
  static const classEventBookingFragment = """
    id
    created_at
    amount
    status
    currency
    payment_intent_id
    user {
      id
      name
      acro_role {
        name
        id
      }
      email
      image_url
      level {
        name
        id
      }
    }
    class_event {
      id
      start_date
      class {
        url_slug
        id
        name
        image_url
      }
    }
    booking_option {
      $bookingOptionFragment
    }
""";

  static const bookingOptionFragment = """
    commission
    currency
    discount
    id
    price
    subtitle
    title
    updated_at
    """;

  static const classFragmentAllInfo = """
      url_slug
      booking_email
      max_booking_slots
      class_booking_options {
        booking_option {
          $bookingOptionFragment
        }
      }
      city
      description
      id
      image_url
      location
      location_name
      name
      website_url
      class_teachers {
        teacher {
          $teacherFragmentAllInfo
        }
        is_owner
      }
      class_levels {
        level {
          name
          id
        }
      }
      event_type

""";

  static const classFragmentLazy = """
      city
      id
      image_url
      location
      location_name
      url_slug
      name
      class_teachers {
        teacher {
          $teacherFragmentLazy
        }
        is_owner
      }
      class_levels {
        level {
          name
          id
        }
      }
      event_type
""";

  static const recurringPatternFragment = """

        is_recurring
        id
        start_date
        end_date

""";

  static const classEventFragment = """
    class_id
    created_at
    end_date
    id
    is_cancelled
    available_booking_slots
    max_booking_slots
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
          $teacherFragmentAllInfo
        }
    }""";

  static const teacherFragmentAllInfo = """
  created_at
  url_slug
  description
  type
  id
  location_name
  name
  user_id
  is_organization
  stripe_id
  is_stripe_enabled
  
  user_likes_aggregate {
    aggregate {
      count
    }
  }
  images {
    image {
      url
    }
    is_profile_picture
  }
  """;

  static const teacherFragmentLazy = """
  id
  name
  user_id
  images (where: {is_profile_picture: {_eq: true}}) {
    image {
      url
    }
    is_profile_picture
  }
  """;

  static const userFragment = """
              bio
              email 
              id 
              image_url 
              name
              user_roles {
                role {
                  id
                  name
                }
              }
              teacher_id
              teacher_profile {
                id
                name
                images{
                  is_profile_picture
                  image{
                    url
                  }
                }
              }
              level{
                id
                name
              }

              acro_role {
                id
                name
              }
            
  """;
}
