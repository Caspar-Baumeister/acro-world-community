import 'package:acroworld/graphql/fragments.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Queries {
  static final getEventsFromTo = gql("""
query getEventsFromTo(\$from: timestamptz!, \$to: timestamptz!, \$is_classe: Boolean) {
  event_instance(where: {end_date: {_gte: \$from}, start_date: {_lte: \$to}}) {
    ${Fragments.eventInstanceWithEventTemplate}
  }
}
""");

  static final getAllBookingsOfClassEvent = gql("""
query classEventBooking(\$class_event_id: uuid) {
  class_event_booking(where: {class_event_id: {_eq: \$class_event_id}}) {
    user_id
    booking_option {
      discount
      price
      title
      commission
    }
  }
}
""");

  static final getClassEventsFromToLocationWithClass = gql("""
query getClassEventsFromToLocationWithClass(\$from: timestamptz!, \$to: timestamptz!, \$latitude: numeric, \$longitude: numeric, \$distance: float8, \$is_classe: Boolean){
  class_events_by_location_v1(args: {lat: \$latitude, lng: \$longitude}, order_by: {distance: asc}, where: {start_date: {_gte: \$from}, end_date: {_lte: \$to} , distance: {_lte: \$distance}, class: {is_classe: {_eq: \$is_classe}}}) {
    distance
    ${Fragments.classEventFragment}
  }
}
""");
  static final getClassEventsFromToWithClass = gql("""
query getClassEventsFromToWithClass(\$from: timestamptz!, \$to: timestamptz!, \$is_classe: Boolean) {
  class_events(where: {end_date: {_gte: \$from}, start_date: {_lte: \$to}, class: {class_teachers: {teacher: {confirmation_status: {_eq: Confirmed}}}}, _and: {class: {is_classe: {_eq: \$is_classe}}}}) {
    ${Fragments.classEventFragment}
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

  static final getEventsByTeacherId = gql("""
query getEventsByTeacherId(\$teacher_id: uuid) {
  events(where: {confirmation_status: {_eq: Confirmed}, _and: {teachers: {teacher_id: {_eq: \$teacher_id}}}}) {
    ${Fragments.eventFragment}
  }
}
""");

  static final events = gql("""
query Events {
  events (where: {confirmation_status: {_eq: Confirmed}}){
     ${Fragments.eventFragment}
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
      id
      image_url
      fcm_token
      bio
      created_at
      name
    }
  }
  """);

  static final getTeacherForList = gql("""
    query getTeacherForList(\$user_id: uuid) {
      teachers(order_by: {user_likes_aggregate: {count: desc}}, where: {confirmation_status: {_eq: Confirmed}}) {
        id
        location_name
        name
        type
        community_id
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

  static final getClasses = gql("""
  query getClasses {
    classes {
      ${Fragments.classFragment}
      class_teachers (where: {teacher: {confirmation_status: {_eq: Confirmed}}}) {
      teacher {
        id
        name
        images(where: {is_profile_picture: {_eq: true}}) {
          image {
            url
          }
        }
      }
    }
    }
  }
  """);

  static final getClassesByLocation = gql("""
  query GetClassesByLocation(\$latitude: numeric, \$longitude: numeric) {
    classes_by_location_v1(args: {lat: \$latitude, lng: \$longitude}, order_by: {distance: asc}, where: {distance: {_lte: "20"}, teacher: {teacher: {confirmation_status: {_eq: Confirmed}}}}) {
        ${Fragments.classFragment}
        distance
        teacher (where: {teacher: {confirmation_status: {_eq: Confirmed}}}){
          teacher {
            id
            name
            images(where: {is_profile_picture: {_eq: true}}) {
              image {
                url
              }
            }
          }
        }
      }
    }
  """);

  static final getClassEventsByClassId = gql("""
query getClassEventsByClassId (\$class_id: uuid) {
  class_events(where: {class_id: {_eq: \$class_id}}) {
   ${Fragments.classEventFragment}
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
