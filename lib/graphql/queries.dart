import 'package:acroworld/graphql/fragments.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Queries {
  static final userBookmarks = gql("""
query Me {
  me {
    bookmarks (where: {event: {end_date_tz: {_gte: now}}}) {
      id
      created_at
      event {
        ${Fragments.eventFragment}
      }
      
    }
  }
}""");

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
        ${Fragments.classFragment}
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
      ${Fragments.classFragment}
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
      ${Fragments.classFragment}
    }
  }
}
""");

// this is for the discovery page
// get all classes and for every class event
  static final getEventOccurences = gql("""
query getEventOccurences {
  class_events(where: {end_date: {_gte: "now"}}) {
    ${Fragments.classEventFragment}
    is_highlighted
    recurring_pattern {
      ${Fragments.recurringPatternFragment}
    }
    class {
      ${Fragments.classFragment}
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

  static final getEventsByTeacherId =
      gql("""query getEventsByTeacherId(\$teacher_id: uuid!) {
  teachers_by_pk(id: \$teacher_id) {
    events(where: {event: {confirmation_status: {_eq: Confirmed}, end_date_tz: {_gte: now}}}) {
      event {
         ${Fragments.eventFragment}
      }
    }
    owned_events(where: {event: {confirmation_status: {_eq: Confirmed}, end_date_tz: {_gte: now}}}) {
      event {
        ${Fragments.eventFragment}
      }
    }
  }
}""");

  static final events = gql("""
query Events {
  events (where: {confirmation_status: {_eq: Confirmed}, end_date_tz: {_gte: now}}){
     ${Fragments.eventFragment}
  }
}
 """);

  static final getEventByIdWithBookmark = gql("""
query getEventByIdWithBookmark(\$event_id: uuid!, \$user_id: uuid!) {
  events_by_pk(id: \$event_id){
     ${Fragments.eventFragment}
     bookmarks(where: {user_id: {_eq: \$user_id}}) {
      id
      created_at
    }
  }
}
 """);

  static final getClassBySlugWithFavorite = gql("""
query getClassByIdWithFavorite(\$url_slug: String!, \$user_id: uuid!) {
  classes(where: {url_slug: {_eq: \$url_slug}}){
     ${Fragments.classFragment}
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
     ${Fragments.classFragment}
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
      ${Fragments.classFragment}
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

  static final meGender = gql("""
  query {
  me {
    acro_role {
      id
      name
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

  static final getPlaces = gql("""
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
      ${Fragments.teacherFragment}
    }
  }
  """);

  static final getTeacherBySlug = gql("""
  query getTeacherById(\$teacher_slug: String!, \$user_id: uuid) {
    teachers(where: {url_slug: {_eq: \$teacher_slug}}) {
      user_likes(where: {user_id: {_eq: \$user_id}}) {
        user_id
      }
      ${Fragments.teacherFragment}
    }
  }
  """);

  static final getClassEventsByClassId = gql("""
query getClassEventsByClassId (\$class_id: uuid) {
  class_events(where: {class_id: {_eq: \$class_id}}) {
   ${Fragments.classEventFragment}
   class {
      ${Fragments.classFragment}
    }
  }
}
""");

  static final getClassesByTeacherId = gql("""
query getClassesByTeacherId(\$teacher_id: uuid) {
  classes(where: {class_teachers: {teacher_id: {_eq: \$teacher_id}}}) {
    ${Fragments.classFragment}
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
     ${Fragments.teacherFragment}
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
