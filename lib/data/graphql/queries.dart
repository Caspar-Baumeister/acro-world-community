import 'package:acroworld/data/graphql/fragments.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Queries {
  /// INVITES ///

  // check if email is already invited or registered
  static final checkInvitePossible = gql("""
    query CheckEmail(\$email: String!) {
      users(where: {email: {_eq: \$email}}) {
        id
      }
      created_invites(where: {email: {_eq: \$email}}) {
        id
      }
    }
  """);

  // getInvites
  static final getCreatedInvitesPageableQuery = gql("""
query GetCreatedInvitesPageable(\$limit: Int, \$offset: Int) {
  created_invites(
    limit: \$limit
    offset: \$offset
    order_by: { created_at: desc }
  ) {
    id
    email
    confirmation_status
    entity
    created_at
    invited_user {
      name
    }
    class {
      name
    }
    event {
      name
    }
  }
  created_invites_aggregate {
    aggregate {
      count
    }
  }
}
""");

  //getUpcomingClassEventsById
  static final getUpcomingClassEventsById = gql("""
query getUpcomingClassEventsById(\$classId: uuid!) {
  class_events(where: {class_id: {_eq: \$classId}, start_date: {_gte: now}}, order_by: {start_date: asc}) {
    ${Fragments.classEventFragment}
  }
}
""");

  //getUpcomingClassEventsById
  static final getClassEventsById = gql("""
query getUpcomingClassEventsById(\$classId: uuid!) {
  class_events(where: {class_id: {_eq: \$classId}}, order_by: {start_date: asc}) {
    ${Fragments.classEventFragment}
  }
}
""");

// get class event bookings for creator dashboard page
  static final getClassEventBookings = gql(
      """query getClassEventBookings(\$id: uuid!, \$limit: Int, \$offset: Int) {
  class_event_bookings(where: {class_event: {class: {created_by_id: {_eq: \$id}}}}, limit: \$limit, offset: \$offset, order_by: {created_at: desc}) {
    ${Fragments.classEventBookingFragment}
  }
}

""");

  //fetches all classeventbookings of a creator with a specific class event id
  static final getClassEventBookingsByClassEventId = gql(
      """query getClassEventBookingsByClassSlug(\$class_event_id: uuid!, \$created_by_id: uuid!) {
  class_event_bookings(where: {class_event: {class: {created_by_id: {_eq: \$created_by_id}}, id: {_eq: \$class_event_id}}}) {
    ${Fragments.classEventBookingFragment}
  }
}
  
  
  """);

//class_event_bookings_aggregate
  static final getClassEventBookingsAggregate =
      gql("""query getClassEventBookingsAggregate(\$id: uuid!) {
class_event_bookings_aggregate(where: {class_event: {class: {created_by_id: {_eq: \$id}}}}) {
    aggregate {
      count
    }
  }
}
""");

  static final getStripeLoginLink = gql("""
  query GetStripeLoginLink {
    stripe_login_link
  }
""");

  static final getTeachersPageableQuery = gql("""
  query GetTeachersPageable(\$limit: Int, \$offset: Int, \$where: teachers_bool_exp!) {
    teachers(limit: \$limit, offset: \$offset, where: \$where, order_by: { name: asc }) {
      id
      name
      user_id
      confirmation_status
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
    }
  }
""");

  static final getClasses = gql("""
query getClasses {
  classes {
    ${Fragments.classFragmentAllInfo}
    class_events(where: {end_date: {_gte: now}}) {
      ${Fragments.classEventFragment}
    }
  }
  classes_aggregate {
    aggregate{
      count
    }
  }
}
""");

  static final getClassesLazyAsTeacherUser = gql("""
query getClassesLazy(\$limit: Int!, \$offset: Int!, \$where: classes_bool_exp!) {
   classes(where: \$where, limit: \$limit, offset: \$offset, order_by: {created_at: desc}) {
    ${Fragments.classFragmentLazy}
    class_events(where: {end_date: {_gte: now}}, order_by: {start_date: asc}, limit: 1) {
      id
      start_date
    }
    class_events_aggregate(where: {end_date: {_gte: now}}) {
      aggregate {
        count
      }
    }
  }
  classes_aggregate (where: \$where) {
    aggregate {
      count
    }
  }
}
""");

  static final userBookings = gql("""
query userBookings {
  me {
    bookings(where: {status: {_eq: Confirmed}}, order_by: {class_event: {start_date: asc}}) {
      created_at
      updated_at
      booking_option{
        id
        title
      }
      status
      class_event {
        id
        start_date
        end_date
        class {
          url_slug
          name
          image_url
          id
          class_teachers {
            teacher {
              name
            }
          }
        }
      }
    }
  }
}""");

  static final userFavorites = gql("""
query Me {
  me {
    class_favorits {
      id
      created_at
      classes {
        ${Fragments.classFragmentAllInfo}
      }
      
    }
  }
}""");

  static final isClassEventBooked = gql("""
query isClassEventBooked(\$class_event_id: uuid) {
    class_event_bookings_aggregate(where: {class_event_id: {_eq: \$class_event_id}, status: {_eq: "Confirmed"}}) {
      aggregate {
        count
      }
    }
}

""");

// this is for the calendar widget with date filter for a specific week
  static final getClassEventsFromToLocationWithClass = gql("""
query getClassEventsFromToLocationWithClass(\$from: timestamptz!, \$to: timestamptz!, \$latitude: numeric, \$longitude: numeric, \$distance: float8){
  class_events_by_location_v1(args: {lat: \$latitude, lng: \$longitude}, order_by: {distance: asc}, where: {end_date: {_gte: \$from}, start_date: {_lte: \$to} , distance: {_lte: \$distance}}) {
    distance
    ${Fragments.classEventFragment}
    class {
      ${Fragments.classFragmentAllInfo}
    }
  }
}
""");

// this is for the map widget without any date filter
  static final getClassEventsByDistance = gql("""
query getClassEventsByDistance(\$latitude: numeric, \$longitude: numeric, \$distance: float8){
  class_events_by_location_v1(args: {lat: \$latitude, lng: \$longitude}, order_by: {distance: asc}, where: {start_date: {_gte: now}, distance: {_lte: \$distance}}) {
    distance
    ${Fragments.classEventFragment}
    class {
      ${Fragments.classFragmentAllInfo}
    }
  }
}
""");

// this is for the discovery page
// get all classes and for every class event
  static final getEventOccurences = gql("""
query getEventOccurences {
  class_events(where: {end_date: {_gte: "now"}, class: {id: {_is_null: false}}}) {
    ${Fragments.classEventFragment}
    is_highlighted
    recurring_pattern {
      ${Fragments.recurringPatternFragment}
    }
    class {
      ${Fragments.classFragmentAllInfo}
      location_country
      location_city
    }
  }
}
""");

  static final config = gql("""
query Config {
  config {
    min_version
  }
}
""");

  static final getClassBySlugWithOutFavorite = gql("""
query getClassByIdWithFavorite(\$url_slug: String!) {
  classes(where: {url_slug: {_eq: \$url_slug}}){
     ${Fragments.classFragmentAllInfo}
      recurring_patterns {
      day_of_week
      end_date
      end_time
      is_recurring
      id
      recurring_every_x_weeks
      start_date
      start_time
      class_id
    }
  }
}
 """);

  static final getClassBySlugWithFavorite = gql("""
query getClassByIdWithFavorite(\$url_slug: String!, \$user_id: uuid!) {
  classes(where: {url_slug: {_eq: \$url_slug}}){
     ${Fragments.classFragmentAllInfo}
     class_favorits(where: {user_id: {_eq: \$user_id}}) {
      id
      created_at
    }
     class_flags(where: {user_id: {_eq: \$user_id}}) {
      id
      }
  }
}
 """);

  static final getClassByIdWithFavorite = gql("""
query getClassByIdWithFavorite(\$class_id: uuid!, \$user_id: uuid!) {
   classes_by_pk(id: \$class_id){
     ${Fragments.classFragmentAllInfo}
     class_favorits(where: {user_id: {_eq: \$user_id}}) {
      id
      created_at
     }
     class_flags(where: {user_id: {_eq: \$user_id}}) {
      id
      }
  }
}
 """);

  static final getClassEventWithClasByIdWithFavorite = gql("""
query getClassEventWithClasByIdWithFavorite(\$class_event_id: uuid!, \$user_id: uuid!) {
  class_events_by_pk(id: \$class_event_id){
    ${Fragments.classEventFragment}
    class {
      ${Fragments.classFragmentAllInfo}
      class_favorits(where: {user_id: {_eq: \$user_id}}) {
      id
      created_at
      }
      class_flags(where: {user_id: {_eq: \$user_id}}) {
        id
      }
    }
  }
}
 """);

  static final allGender = gql("""
  query Query {
  acro_roles{
    id
    name
  }
}
  """);

  static final allLevels = gql("""
  query Query {
  levels{
    id
    name
  }
}
  """);

  static final getPlacesIdsCity = gql("""
  query GetPlaces(\$query: String!) {
    places(searchQuery: \$query) {
      id
      description
      matched_substrings {
        length
        offset
      }
    }
  }
  """);

  static final getPlacesIds = gql("""
  query GetPlaces(\$query: String!) {
    search_by_input_text(searchQuery: \$query) {
      id
      description
      matched_substrings {
        length
        offset
      }
    }
  }
  """);

  static final getPlace = gql("""
  query GetPlaces(\$id: String!) {
    place(id: \$id) {
      description
      id
      latitude
      longitude
    }
  }
  """);

  static final getMe = gql("""
  query GetMe {
    me {
      ${Fragments.userFragment}
      is_email_verified
    }
  }
  """);

  static final getMeCreator = gql("""
  query GetMe {
    me {
      teacher_profile {
        ${Fragments.teacherFragmentAllInfo}
      }
    }
  }
  """);

  static final getTeacherForList = gql("""
    query getTeacherForList(\$user_id: uuid, \$search: String!) {
      teachers(order_by: {user_likes_aggregate: {count: desc}}, where: {confirmation_status: {_eq: Confirmed}, _and: {name: {_ilike: \$search}}}) {
        id
        location_name
        name
        type
        images(where: {is_profile_picture: {_eq: true}}) {
          image {
            url
          }
          is_profile_picture
        }
        is_organization
        user_likes(where: {user_id: {_eq: \$user_id}}) {
          user_id
        }
        user_likes_aggregate {
          aggregate {
            count
          }
        }
      }
    }""");

  static final getTeacherForListWithoutUserID = gql("""
    query getTeacherForList(\$search: String!) {
      teachers(order_by: {user_likes_aggregate: {count: desc}}, where: {confirmation_status: {_eq: Confirmed}, _and: {name: {_ilike: \$search}}}) {
        id
        location_name
        name
        type
        images(where: {is_profile_picture: {_eq: true}}) {
          image {
            url
          }
          is_profile_picture
        }
        is_organization
       
        user_likes_aggregate {
          aggregate {
            count
          }
        }
      }
    }""");

  static final getFollowedTeacherForList = gql("""
  query getTeacherForList(\$user_id: uuid, \$search: String!) {
  me {
    followed_teacher(order_by: {created_at: desc}, where: {teacher: {confirmation_status: {_eq: Confirmed}}, _and: {teacher: {name: {_ilike: \$search}}}}) {
      teacher {
        id
        location_name
        name
        type
        images(where: {is_profile_picture: {_eq: true}}) {
          image {
            url
          }
          is_profile_picture
        }
        is_organization
        user_likes(where: {user_id: {_eq: \$user_id}}) {
          user_id
        }
        user_likes_aggregate {
          aggregate {
            count
          }
        }
      }
    }
  }
}""");

  static final getTeacherById = gql("""
  query getTeacherById(\$teacher_id: uuid!, \$user_id: uuid) {
    teachers_by_pk(id: \$teacher_id) {
      user_likes(where: {user_id: {_eq: \$user_id}}) {
        user_id
      }
      ${Fragments.teacherFragmentAllInfo}
    }
  }
  """);

  static final getTeacherBySlug = gql("""
  query getTeacherById(\$teacher_slug: String!, \$user_id: uuid) {
    teachers(where: {url_slug: {_eq: \$teacher_slug}}) {
      user_likes(where: {user_id: {_eq: \$user_id}}) {
        user_id
      }
      ${Fragments.teacherFragmentAllInfo}
    }
  }
  """);

  static final getClassEventsByClassId = gql("""
query getClassEventsByClassId (\$class_id: uuid) {
  class_events(where: {class_id: {_eq: \$class_id}}) {
   ${Fragments.classEventFragment}
   class {
      ${Fragments.classFragmentAllInfo}
    }
  }
}
""");

  static final getClassesByTeacherId = gql("""
query getClassesByTeacherId(\$teacher_id: uuid) {
  classes(where: {class_teachers: {teacher_id: {_eq: \$teacher_id}}}) {
    ${Fragments.classFragmentAllInfo}
  }
}""");

  static final getClassEventParticipants = gql("""
query getClassEventParticipants(\$class_event_id: uuid) {
  class_events_participants(where: {class_event_id: {_eq: \$class_event_id}}) {
    user {
      ${Fragments.userFragment}
    }
  }
}
  """);

  static final getAllUsers = gql("""
    query getAllUsers(\$limit: Int, \$offset: Int) {
      users(limit: \$limit, offset: \$offset) {
        ${Fragments.userFragment}
      }
    }
      """);

  static final getAcroRoleAggregatesFromClassEvent =
      gql("""query GetAcroRoleAggregates(\$class_event_id: uuid!) {
  total_aggregate: class_events_participants_aggregate(where: {class_event_id: {_eq: \$class_event_id}}) {
    aggregate {
      count
    }
  }
  base_aggregate: class_events_participants_aggregate(where: {class_event_id: {_eq: \$class_event_id}, user: {acro_role_id: {_eq: "dc321f52-fce9-4b00-bef6-e59fb05f4624"}}}) {
    aggregate {
      count
    }
  }
  flyer_aggregate: class_events_participants_aggregate(where: {class_event_id: {_eq: \$class_event_id}, user: {acro_role_id: {_eq: "83a6536f-53ba-44d2-80d9-9842375ebe8b"}}}) {
    aggregate {
      count
    }
  }
}""");

  static final getFollowedTeachers = gql("""
query getFollowedTeachers(\$user_id: uuid!) {
  teachers(where: {user_likes: {user_id: {_eq: \$user_id}, _and: {teacher: {confirmation_status: {_eq: Confirmed}}}}}) {
     ${Fragments.teacherFragmentAllInfo}
  }
}
""");

  static final getAcroRoleAggregatesFromJam =
      gql("""query getAcroRoleAggregatesFromJam(\$jam_id: uuid!) {
  total_aggregate: jam_participants_aggregate(where: {jam_id: {_eq: \$jam_id}}) {
    aggregate {
      count
    }
  }
  base_aggregate: jam_participants_aggregate(where: {jam_id: {_eq: \$jam_id}, user: {acro_role_id: {_eq: "dc321f52-fce9-4b00-bef6-e59fb05f4624"}}}) {
    aggregate {
      count
    }
  }
  flyer_aggregate: jam_participants_aggregate(where: {jam_id: {_eq: \$jam_id}, user: {acro_role_id: {_eq: "83a6536f-53ba-44d2-80d9-9842375ebe8b"}}}) {
    aggregate {
      count
    }
  }
}""");

  static final getClassParticipants = gql("""
    query getCommunityUsers(\$class_event_id: uuid!, \$limit: Int, \$offset: Int) {
      users(where: {
        class_event_participations: {
          class_event_id: {_eq: \$class_event_id}}}, 
          limit: \$limit, 
          offset: \$offset) {
        ${Fragments.userFragment}
      }
    }
      """);
}
