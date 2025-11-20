class Fragments {
  static const questionFragment = """
        id
        question
        title
        position
        is_required 
        allow_multiple_answers
        question_type
        multiple_choice_options {
          id
          question_id
          option_text
          position
        }
        """;

  //answer fragment
  static const answerFragment = """
        id
        answer
        question_id
        user_id
        event_occurence
        country_dial_code
        multiple_choice_answers {
          is_correct
          id
          multiple_choice_option_id
          user_id
          answer_id
        }
        """;

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
        created_by {
          id
          name
          email
        }
      }
    }
    booking_option {
      $bookingOptionFragment
      category {
        id
        name
        contingent
      }
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
    category_id
    """;

  static const classFragmentAllInfo = """
      url_slug
      booking_email
      max_booking_slots
      city
      description
      id
      image_url
      location
      location_name
      name
      location_country
      location_city
      website_url
      invites {
        id
        entity
        email
        invited_user_id
        confirmation_status
        created_at
        invited_user {
          ${Fragments.userFragment}
        }
        class {
          ${Fragments.classFragmentLazy}
        }
      }
      class_teachers {
        id
        teacher {
          $teacherFragmentAllInfo
        }
        is_owner
      }
      class_owners {
        teacher {
          $teacherFragmentAllInfo
        }
        is_payment_receiver
      }
      class_levels {
        level {
          name
          id
        }
      }
      event_type
      created_by_id
      questions {
        ${Fragments.questionFragment}
      }
      booking_categories {
        id
        name
        description
        contingent
        booking_options {
          ${Fragments.bookingOptionFragment}
        }
      }
      class_flags {
        id
        is_active
        user_id
      }
      is_cash_allowed
      

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
        id
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
      is_cash_allowed
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
    is_highlighted
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
  
  user {
    id
    email
    name
  }
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
