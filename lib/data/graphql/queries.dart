import 'package:acroworld/data/graphql/fragments.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Queries {
  /// CATEGORIES ///
  static final getConfirmedBookingsForCategoryAggregate = gql("""
query getConfirmedBookingsForCategory(\$category_id: uuid!, \$class_event_id: uuid!) {
  class_event_bookings_aggregate(where: {booking_option: {category_id: {_eq: \$category_id}}, _and: {class_event_id: {_eq: \$class_event_id}, status: {_in: ["Confirmed","WaitingForPayment"]}}}) {
    aggregate {
      count
    }
  }
}
""");

  static final getBookingCategories = gql("""
query getBookingCategories(\$classId: uuid!) {
  booking_category(where: {class_id: {_eq: \$classId}}) {
    id
    name
    description
    contingent
    booking_options {
      ${Fragments.bookingOptionFragment}
    }
  }
}
""");

  /// Questions and Answers ///

  static final getQuestionsForEvent = gql("""
query getQuestionsForEvent(\$eventId: uuid!) {
  questions(where: {event_id: {_eq: \$eventId}}, order_by: {position: asc}) {
    ${Fragments.questionFragment}
  }
}
""");

  static final getQuestionsForEventOccurence = gql("""
query getQuestionsForEvent(\$eventOccurenceId: uuid!) {
  questions(where: {event: {class_events: {id: {_eq: \$eventOccurenceId}}}}, order_by: {position: asc}) {
    ${Fragments.questionFragment}
  }
}
""");

  static final getAnswersOfUserAndEventOccurence = gql("""
query getAnswersOfUserAndEventOccurence(\$user_id: uuid!, \$event_occurence_id: uuid!) {
  answers(where: {user_id: {_eq: \$user_id}, event_occurence: {_eq: \$event_occurence_id}}) {
    ${Fragments.answerFragment}
  }
}
""");

  /// INVITES ///

  // getInvites - COMMENTED OUT FOR LATER USE
  // static final getCreatedInvitesPageableQuery = gql("""
  // query GetCreatedInvitesPageable(\$limit: Int, \$offset: Int) {
  //   created_invites(
  //     limit: \$limit
  //     offset: \$offset
  //     order_by: { created_at: desc }
  //   ) {
  //     id
  //     email
  //     confirmation_status
  //     entity
  //     created_at
  //     invited_user {
  //       name
  //     }
  //     class {
  //       name
  //     }
  //     event {
  //       name
  //     }
  //   }
  //   created_invites_aggregate {
  //     aggregate {
  //       count
  //     }
  //   }
  // }
  // """);

  // getInvites - NEW: Get invites where current user is the invited user
  static final getInvitedInvitesPageableQuery = gql("""
query GetInvitedInvitesPageable(\$limit: Int, \$offset: Int, \$user_id: uuid!) {
  invites(
    limit: \$limit
    offset: \$offset
    order_by: { created_at: desc }
    where: { 
      invited_user_id: { _eq: \$user_id },
      entity: { _eq: class }
    }
  ) {
    id
    email
    confirmation_status
    entity
    created_at
    created_by {
      name
    }
    class {
      id
      name
      image_url
      location_city
      location_country
      created_by {
        name
      }
      class_teachers {
        teacher {
          name
        }
      }
      class_events(
        where: { start_date: { _gte: "now()" } }
        order_by: { start_date: asc }
        limit: 1
      ) {
        start_date
        end_date
      }
    }
    event {
      name
    }
  }
  invites_aggregate(
    where: { 
      invited_user_id: { _eq: \$user_id },
      entity: { _eq: class }
    }
  ) {
    aggregate {
      count
    }
  }
}
""");

  // getPendingInvitesCount - Get count of pending invites for badge
  static final getPendingInvitesCountQuery = gql("""
query GetPendingInvitesCount(\$user_id: uuid!) {
  invites_aggregate(
    where: { 
      invited_user_id: { _eq: \$user_id },
      confirmation_status: { _eq: Pending },
      entity: { _eq: class }
    }
  ) {
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
  class_event_bookings(where: {class_event: {class: {created_by_id: {_eq: \$id}}}, _and: {status: { _in: ["Confirmed","WaitingForPayment"]}}}, limit: \$limit, offset: \$offset, order_by: {created_at: desc}) {
    ${Fragments.classEventBookingFragment}
  }
}

""");

  //fetches all classeventbookings of a creator with a specific class event id
  static final getClassEventBookingsByClassEventId = gql(
      """query getClassEventBookingsByClassSlug(\$class_event_id: uuid!, \$created_by_id: uuid!) {
  class_event_bookings(where: {class_event: {class: {created_by_id: {_eq: \$created_by_id}}, id: {_eq: \$class_event_id}}, status: { _in: ["Confirmed","WaitingForPayment"]}}) {
    ${Fragments.classEventBookingFragment}
  }
}
  """);

// fetches all classeventbookings of a user with a specific class event id
  static final myClassEventBookings = gql("""
query isClassEventBooked(\$class_event_id: uuid, \$user_id: uuid) {
   class_event_bookings(where: {class_event_id: {_eq: \$class_event_id}, user_id: {_eq: \$user_id}, status: {_in: ["Confirmed","WaitingForPayment"]}}) {
    ${Fragments.classEventBookingFragment}
}
}
""");

//class_event_bookings_aggregate
  static final getClassEventBookingsAggregate =
      gql("""query getClassEventBookingsAggregate(\$id: uuid!) {
class_event_bookings_aggregate(where: {status: {_in: ["Confirmed","WaitingForPayment"]}, class_event: {class: {created_by_id: {_eq: \$id}}}}
) {
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
      
      user_likes_aggregate {
        aggregate {
          count
        }
      }
       ${Fragments.teacherFragmentAllInfo}
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
      is_highlighted
    }
    class_events_aggregate(where: {end_date: {_gte: now}}) {
      aggregate {
        count
      }
    }
   class_flags {
      id
      is_active
      user_id
    }
  }
 
}
""");

  // Optimized query for My Events page with minimal data
  static final getMyEventsOptimized = gql("""
query getMyEventsOptimized(\$limit: Int!, \$offset: Int!, \$where: classes_bool_exp!) {
   classes(where: \$where, limit: \$limit, offset: \$offset, order_by: {created_at: desc}) {
    id
    name
    image_url
    location_name
    city
    location_country
    url_slug
    created_at
    class_events(where: {end_date: {_gte: now}}, order_by: {start_date: asc}, limit: 1) {
      id
      start_date
      is_highlighted
    }
    class_events_aggregate(where: {end_date: {_gte: now}}) {
      aggregate {
        count
      }
    }
    class_teachers(limit: 3) {
      teacher {
        id
        name
        images(where: {is_profile_picture: {_eq: true}}, limit: 1) {
          image {
            url
          }
        }
      }
      is_owner
    }
    class_owners {
      teacher {
        id
        name
        user_id
        images(where: {is_profile_picture: {_eq: true}}, limit: 1) {
          image {
            url
          }
        }
      }
      is_payment_receiver
    }
    class_flags(where: {is_active: {_eq: true}}) {
      id
      user_id
    }
  }
}
""");

  static final userBookings = gql("""
query userBookings {
  me {
    bookings(where: {status: { _in: ["Confirmed","WaitingForPayment"]}}, order_by: {class_event: {start_date: asc}}) {
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

  static final userFavoriteClassEventsUpcoming = gql("""
query UserFavoriteClassEventsUpcoming(\$limit: Int, \$offset: Int) {
  me {
    class_favorits {
      classes {
        id
        class_events(
          where: { 
            start_date: { 
              _gte: "now()" 
            }
          }
          order_by: { start_date: asc }
          limit: \$limit
          offset: \$offset
        ) {
          ${Fragments.classEventFragment}
          class {
            ${Fragments.classFragmentAllInfo}
          }
        }
      }
    }
  }
}""");

  static final userFavoriteClassEventsAll = gql("""
query UserFavoriteClassEventsAll(\$limit: Int, \$offset: Int) {
  me {
    class_favorits {
      classes {
        id
        class_events(
          order_by: { start_date: asc }
          limit: \$limit
          offset: \$offset
        ) {
          ${Fragments.classEventFragment}
          class {
            ${Fragments.classFragmentAllInfo}
          }
        }
      }
    }
  }
}""");

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
     
      
    }
  }
}
""");

  static final config = gql("""
query Config {
  config {
    min_version
    daily_highlight_commission
  }
}
""");

  static final getClassBySlug = gql("""
query getClassById(\$url_slug: String!) {
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
    class_events(where: {end_date: {_gte: now}}, order_by: {start_date: asc}) {
      ${Fragments.classEventFragment}
    }
    
  }
}
 """);

  // Check if a class url slug is available
  static final isSlugAvailable = gql("""
query IsSlugAvailable(\$slug: String!) {
  classes(where: {url_slug: {_eq: \$slug}}) { id }
}
""");

  static final isClassFavorited = gql("""
query isClassFavorited(\$class_id: uuid!, \$user_id: uuid!) {
   class_favorits(where: {user_id: {_eq: \$user_id}}, class_id: {_eq: \$class_id}}) {
      id
      created_at
    }
  }
""");

  static final getClassEventWithClasById = gql("""
query getClassEventWithClasById(\$class_event_id: uuid!) {
  class_events_by_pk(id: \$class_event_id){
    ${Fragments.classEventFragment}
    class {
      ${Fragments.classFragmentAllInfo}
     
      
      
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
        stripe_id
        is_stripe_enabled
        individual_commission
      }
    }
  }
  """);

  static final getTeacherForList = gql("""
    query getTeacherForList(\$user_id: uuid, \$search: String!, \$limit: Int, \$offset: Int) {
      teachers(
        limit: \$limit, 
        offset: \$offset,
        order_by: {user_likes_aggregate: {count: desc}}, 
        where: {confirmation_status: {_eq: Confirmed}, _and: {name: {_ilike: \$search}}}
      ) {
        ${Fragments.teacherFragmentAllInfo}
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
    query getTeacherForList(\$search: String!, \$limit: Int, \$offset: Int) {
      teachers(
        limit: \$limit, 
        offset: \$offset,
        order_by: {user_likes_aggregate: {count: desc}}, 
        where: {confirmation_status: {_eq: Confirmed}, _and: {name: {_ilike: \$search}}}
      ) {
         ${Fragments.teacherFragmentAllInfo}
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
        ${Fragments.teacherFragmentAllInfo}
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
  query getTeacherById(\$teacher_slug: String!) {
    teachers(where: {url_slug: {_eq: \$teacher_slug}}) {
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
  classes(where: {
    _or: [
      {class_teachers: {teacher_id: {_eq: \$teacher_id}}},
      {class_owners: {teacher_id: {_eq: \$teacher_id}}}
    ]
  }) {
    ${Fragments.classFragmentAllInfo}
  }
}""");

  // Count pending event invitations for a teacher (has_accepted is null)
  // Excludes classes created by the current user
  static final getPendingTeacherInvitesCount = gql("""
  query GetPendingTeacherInvitesCount(\$user_id: uuid!) {
    class_teachers_aggregate(
      where: {
        teacher: {user_id: {_eq: \$user_id}},
        class_id: {_is_null: false},
        class: {created_by_id: {_neq: \$user_id}}
      }
    ) {
      aggregate { count }
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

  static final getUserById = gql("""
    query getUserById(\$userId: uuid!) {
      users_by_pk(id: \$userId) {
        ${Fragments.userFragment}
      }
    }
      """);

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

  /// Comments ///

  static final getCommentsForTeacher = gql("""
query getCommentsForTeacher(\$teacher_id: uuid!, \$limit: Int, \$offset: Int) {
  comments(
    where: {teacher_id: {_eq: \$teacher_id}}
    order_by: {created_at: desc}
    limit: \$limit
    offset: \$offset
  ) {
    id
    content
    rating
    created_at
    updated_at
    teacher_id
    user_id
    user {
      id
      name
      image_url
    }
    teacher {
      id
      name
    }
  }
}
""");

  static final getCommentsCountForTeacher = gql("""
query getCommentsCountForTeacher(\$teacher_id: uuid!) {
  comments_aggregate(where: {teacher_id: {_eq: \$teacher_id}}) {
    aggregate {
      count
    }
  }
}
""");

  static final getCommentsStatsForTeacher = gql("""
query getCommentsStatsForTeacher(\$teacher_id: uuid!) {
  comments_aggregate(where: {teacher_id: {_eq: \$teacher_id}}) {
    aggregate {
      count
      avg {
        rating
      }
    }
  }
}
""");

  static final getUserCommentForTeacher = gql("""
query getUserCommentForTeacher(\$teacher_id: uuid!, \$user_id: uuid!) {
  comments(where: {teacher_id: {_eq: \$teacher_id}, user_id: {_eq: \$user_id}}, limit: 1) {
    id
    content
    rating
    created_at
    updated_at
    teacher_id
    user_id
    user {
      id
      name
      image_url
    }
    teacher {
      id
      name
    }
  }
}
""");

  static final getTeacherEventsStats = gql("""
query getTeacherEventsStats(\$teacher_id: uuid!) {
  class_events_aggregate(where: {class: {class_owners: {teacher_id: {_eq: \$teacher_id}}}, end_date: {_lt: "now()"}}) {
    aggregate {
      count
    }
  }
}
""");

  static final getTeacherParticipatedEventsStats = gql("""
query getTeacherParticipatedEventsStats(\$teacher_id: uuid!) {
  class_events_aggregate(where: {class: {class_teachers: {teacher_id: {_eq: \$teacher_id}}}, end_date: {_lt: "now()"}}) {
    aggregate {
      count
    }
  }
}
""");

  static final getTeacherBookingsStats = gql("""
query getTeacherBookingsStats(\$teacher_id: uuid!) {
  class_event_bookings_aggregate(where: {class_event: {class: {class_owners: {teacher_id: {_eq: \$teacher_id}}}}}) {
    aggregate {
      count
    }
  }
}
""");
}
