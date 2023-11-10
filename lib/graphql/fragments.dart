class Fragments {
  static const classFragment = """
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
          $teacherFragment
        }
        is_owner
      }
      class_levels {
        level {
          name
          id
        }
      }

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
          $teacherFragment
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
