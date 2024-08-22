import 'package:graphql_flutter/graphql_flutter.dart';

class Mutations {
  static final createPaymentSheet = gql("""
mutation CreatePaymentSheet(\$bookingOptionId: String!, \$classEventId: String!) {
  create_payment_sheet(
    booking_option_id: \$bookingOptionId
    class_event_id: \$classEventId
  ) {
    payment_intent
    ephemeral_key
    customer_id
  }
}

""");

  static final resetPassword = gql("""
  mutation resetPassword(\$email: String) {
  reset_password(input: {email: \$email}) {
    success
  }
}
""");

//   static final setGender = gql("""
// mutation setGender(\$user_id : uuid!, \$gender_id : uuid!) {
//   update_users_by_pk(pk_columns: {id: \$user_id}, _set: {acro_role_id: \$gender_id}) {
//     id
//   }
// }
// """);

  static final setUserLevel = gql("""
mutation setUserLevel(\$user_id : uuid!, \$level_id : uuid!) {
  update_users_by_pk(pk_columns: {id: \$user_id}, _set: {level_id: \$level_id}) {
    id
  }
}
""");

  static final confirmPayment = gql("""
mutation confirmPayment(\$payment_intent_id : uuid!) {
  payment_intent_succeeded(objects: {payment_intent_id: \$payment_intent_id}) {
    id
  } 
}""");

  static final updateFcmToken = gql("""
    mutation UpdateFcmToken(\$fcmToken: String!) {
      update_users(_set: {fcm_token: \$fcmToken}, where: {}) {
        affected_rows
      }
    }
  """);

  static final bookmarkEvent = gql("""
  mutation bookmarkEvent(\$event_id: uuid) {
  insert_event_bookmarks(objects: {event_id:  \$event_id}) {
    affected_rows
  }
}
""");

  static final unBookmarkEvent = gql("""
  mutation unBookmarkEvent(\$event_id: uuid, \$user_id: uuid) {
  delete_event_bookmarks(where: {event_id: {_eq: \$event_id}, user_id: {_eq: \$user_id}}) {
    affected_rows
  }
}

""");

  static final favoritizeClass = gql("""
  mutation favoritizeClass(\$class_id: uuid!) {
  insert_class_favorites(objects: {class_id:  \$class_id}) {
    affected_rows
  }
}
""");

  static final flagClass = gql("""
  mutation flagClass(\$class_id: uuid!, \$user_id: uuid!) {
  insert_class_flag(objects: {class_id:  \$class_id, user_id: \$user_id}) {
    affected_rows
  }
}
""");

  static final unFavoritizeClass = gql("""
  mutation unBookmarkEvent(\$class_id: uuid!, \$user_id: uuid!) {
  delete_class_favorites(where: {class_id: {_eq: \$class_id}, user_id: {_eq: \$user_id}}) {
    affected_rows
  }
}

""");

  static final unFlagClass = gql("""
  mutation unFlagEvent(\$class_id: uuid!, \$user_id: uuid!) {
  delete_class_flag(where: {class_id: {_eq: \$class_id}, user_id: {_eq: \$user_id}}) {
    affected_rows
  }
}

""");

  static final likeTeacher = gql("""
  mutation likeTeacher(\$teacher_id: uuid) {
  insert_teacher_likes(objects: {teacher_id: \$teacher_id}) {
    affected_rows
  }
}
""");

  static final unlikeTeacher = gql("""
  mutation unlikeTeacher(\$teacher_id: uuid, \$user_id: uuid) {
  delete_teacher_likes(where: {teacher_id: {_eq: \$teacher_id}, user_id: {_eq: \$user_id}}) {
    affected_rows
  }
}

""");

  static final participateToClass = gql("""
  mutation participateToClass (\$class_event_id: uuid){
  insert_class_events_participants_one(object: {class_event_id: \$class_event_id}) {
    class_event_id
  }
}

""");

  static final leaveParticipateClass = gql("""
mutation leaveParticipateClass (\$class_event_id: uuid, \$user_id: uuid){
  delete_class_events_participants(where: {class_event_id: {_eq: \$class_event_id}, user_id: {_eq: \$user_id}}) {
    affected_rows
  }
}""");

  static final deleteAccount = gql("""
mutation deleteAccount{
  delete_account {
    success
  }
}""");
}
