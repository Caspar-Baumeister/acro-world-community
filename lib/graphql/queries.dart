import 'package:acroworld/graphql/fragments.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Queries {
  static final getClassEventsFromToLocationWithClass = gql("""
query getClassEventsFromToLocationWithClass(\$from: timestamptz!, \$to: timestamptz!, \$latitude: numeric, \$longitude: numeric, \$distance: float8){
  class_events_by_location_v1(args: {lat: \$latitude, lng: \$longitude}, order_by: {distance: asc}, where: {start_date: {_gte: \$from}, end_date: {_lte: \$to} , distance: {_lte: \$distance}}) {
    distance
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
  }
}
""");
  static final getClassEventsFromToWithClass = gql("""
query getClassEventsFromToWithClass(\$from: timestamptz!, \$to: timestamptz!) {
  class_events(where: {end_date: {_gte: \$from}, start_date: {_lte: \$to}, class: {class_teachers: {teacher: {confirmation_status: {_eq: Confirmed}}}}}) {
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

  static final jamsFromToWithDistance = gql("""
query jamsFromToWithDistance(\$from: timestamptz!, \$to: timestamptz!, \$latitude: numeric, \$longitude: numeric, \$distance: float8) {
 jams_by_location_v1(args: {lat: \$latitude, lng: \$longitude}, order_by: {distance: asc}, where: {date: {_gte: \$from}, _and: {date: {_lte: \$to}, distance: {_lte: \$distance}}}) {
    distance
    created_at
    created_by_id
    community {
      confirmation_status
      id
      location
      name
      longitude
      latitude
    }
    created_by {
      id
      name
    }
    date
    id
    info
    latitude
    longitude
    name
    participants_aggregate {
      aggregate {
        count
      }
    }
    participants {
      user_id
      user {
        id
        acro_role_id
        name
      }
    }
  }
}
""");

  static final jamsFromTo = gql("""
query jamsFromTo(\$from: timestamptz!, \$to: timestamptz!) {
  jams(order_by: {date: asc}, where: {date: {_gte: \$from}, _and: {date: {_lte: \$to}}}) {
    created_at
    created_by_id
    community {
      confirmation_status
      id
      location
      name
      longitude
      latitude
    }
    created_by {
      id
      name
    }
    date
    id
    info
    latitude
    longitude
    name
    participants_aggregate {
      aggregate {
        count
      }
    }
    participants {
      user_id
      user {
        id
        acro_role_id
        name
      }
    }
  }
}
""");

  static final jamsByCommunityId = gql("""
  query JamsByCommunityId(\$communityId: uuid) {
    jams(where: {community_id: {_eq: \$communityId}}) {
      ${Fragments.jamFragment}
    }
  }
  """);

  static final getAllJamsFromMyCommunities = gql("""
  query GetMyCommunities { 
    me {
      communities {
        community {
          jams {
            ${Fragments.jamFragment}
          }
        }
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

  static final getCommunityById = gql("""
  query getCommunityById(\$communityId: uuid!){
    communities(where: {id: {_eq: \$communityId}}){
      ${Fragments.communityFragment}
    }
  }
  """);

  static final getTeacherForList = gql("""
    query getTeacherForList(\$user_id: uuid) {
      teachers(order_by: {user_likes_aggregate: {count: desc}}, where: {confirmation_status: {_eq: Confirmed}}) {
        id
        location_name
        name
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

  static final getOtherCommunities = gql("""
  query GetOtherCommunities(\$user_id: uuid, \$query: String) {
  communities(where: {_and: [{_not: {users: {user_id: {_eq: \$user_id}}}}, {name: {_ilike: \$query}}], confirmation_status: {_eq: Confirmed}}, limit: 15) {
    id
    name
    latitude
    longitude
    location
    confirmation_status
  }
}
  """);

  static final getOtherCommunitiesByLocation = gql("""
query GetOtherCommunitiesByLocation(\$latitude: numeric, \$longitude: numeric, \$user_id: uuid, \$query: String) {
  communities_by_location_v1(args: { lng: \$longitude, lat: \$latitude}, order_by: {distance: asc}, where: {_and: [{_not: {users: {user_id: {_eq: \$user_id}}}}, {distance: {_lte: "100"}}, {name: {_ilike: \$query}}], confirmation_status: {_eq: "Confirmed"}}, limit: 15) {
    id
    name
    latitude
    longitude
    location
    distance
  }
}
  """);

  static final getClassEventsByClassId = gql("""
query getClassEventsByClassId (\$class_id: uuid) {
  class_events(where: {class_id: {_eq: \$class_id}}) {
    class_id
    created_at
    end_date
    id
    is_cancelled
    start_date
    class { 
      class_teachers (where: {teacher: {confirmation_status: {_eq: Confirmed}}})  {
        teacher{
          id
          images {
            is_profile_picture
            image {
              url
            }
          }
          name
        }
      }
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

  static final getCommunityUsers = gql("""
    query getCommunityUsers(\$community_id: uuid!, \$limit: Int, \$offset: Int) {
      users(where: {user_communities: {community_id: {_eq: \$community_id}}}, limit: \$limit, offset: \$offset) {
        ${Fragments.userFragment}
      }
    }
      """);

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

  static final getUserCommunities = gql("""
  query getUserCommunities() {
  me {
    communities(order_by: {community: {community_messages_aggregate: {max: {created_at: desc_nulls_last}}}}) {
      last_visited_at
      community_id
      community {
        ${Fragments.communityFragment}
          community_messages(limit: 1, order_by: {created_at: desc}) {
          content
          created_at
          from_user {
            name
          }
        }
      }
    }
  }
}
  """);
}
