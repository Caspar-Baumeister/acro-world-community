import 'package:acroworld/graphql/fragments.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Queries {
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

  static final getUserCommunityMessageCount = gql("""
  query GetMyCommunityPreview(\$community_id: uuid!, \$last_visited_at: timestamptz!) {
  user_communities(where: {community_id: {_eq: \$community_id}}) {
    community {
        community_messages_aggregate(where: {created_at: {_gte: \$last_visited_at}}) {
          aggregate {
            count
          }
        }
      }
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

  static final getAllTeacher = gql("""
  query getAllTeacher{
    teachers {
    created_at
    description
    id
    location_name
    community_id
    name
    user_id
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
  }
  }
  """);

  static final getTeachersILike = gql("""
  query getTeachersILike(\$user_id: uuid) {
  teacher_likes(where: {user_id: {_eq: \$user_id}}) {
    teacher_id
  }
}
  """);

  static final getClasses = gql("""
  query getClasses {
    classes {
      ${Fragments.classFragment}
    }
  }
  """);

  static final getClassesDay = gql("""
  query getClasses {
    classes {
      ${Fragments.classFragment}
    }
  }
  """);

  static final getClassesByLocation = gql("""
  query GetClassesByLocation(\$latitude: numeric, \$longitude: numeric) {
    classes_by_location_v1(args: {lat: \$latitude, lng: \$longitude}, order_by: {distance: asc}, where: {distance: {_lte: "20"}}) {
        ${Fragments.classFragment}
        distance
      }
  }
  """);

  static final getOtherCommunities = gql("""
  query GetOtherCommunities(\$user_id: uuid, \$query: String) {
  communities(where: {_not: {users: {user_id: {_eq: \$user_id}}}, name: {_ilike: \$query}}, limit: 15) {
    id
    name
    confirmed
    latitude
    longitude
  }
}
  """);

  static final getOtherCommunitiesByLocation = gql("""
query GetOtherCommunitiesByLocation(\$latitude: numeric, \$longitude: numeric, \$user_id: uuid, \$query: String) {
  communities_by_location_v1(args: { lng: \$longitude, lat: \$latitude}, order_by: {distance: asc}, where: {_and: [{_not: {users: {user_id: {_eq: \$user_id}}}}, {distance: {_lte: "100"}}, {name: {_ilike: \$query}}]}, limit: 15) {
    id
    name
    confirmed
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
  }
}
""");

  static final getClassesByTeacherId = gql("""
query getClassesByTeacherId(\$teacher_id: uuid) {
  classes(where: {class_teachers: {teacher_id: {_eq: \$teacher_id}}}) {
    ${Fragments.classFragment}
  }
}""");

  static final getClassEventCommunity = gql("""
query getClassEventCommunity(\$class_event_id: uuid) {
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

  static final getCommunityUsers = gql("""
    query getCommunityUsers(\$community_id: uuid!, \$limit: Int, \$offset: Int) {
      users(where: {user_communities: {community_id: {_eq: \$community_id}}}, limit: \$limit, offset: \$offset) {
        ${Fragments.userFragment}
      }
    }
      """);

  static final getClassParticipants = gql("""
    query getCommunityUsers(\$class_event_id: uuid!, \$limit: Int, \$offset: Int) {
      users(where: {class_event_participations: {class_event_id: {_eq: \$class_event_id}}}, limit: \$limit, offset: \$offset) {
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
