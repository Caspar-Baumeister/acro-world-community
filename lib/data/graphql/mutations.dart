import 'package:acroworld/data/graphql/fragments.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Mutations {
  // ----------------------------------
  // Class flags
  // ----------------------------------

  static final resolveAllClassFlags = gql("""
    mutation ResolveAllClassFlags(\$classId: uuid!) {
  
  update_class_flag(where: {class_id: {_eq: \$classId}}, _set: {is_active: false}) {
    affected_rows
    returning {
      user_id
    }
  }
}


  """);

  // ----------------------------------
  // Insert Booking Options
  // ----------------------------------
  static final insertBookingOptions = gql("""
    mutation InsertBookingOptions(\$options: [booking_option_insert_input!]!) {
      insert_booking_option(objects: \$options) {
        affected_rows
      }
    }
  """);

  // ----------------------------------
  // Update Booking Option
  // ----------------------------------
  static final updateBookingOption = gql("""
    mutation UpdateBookingOption(\$id: uuid!, \$option: booking_option_set_input!) {
      update_booking_option_by_pk(pk_columns: {id: \$id}, _set: \$option) {
        id
      }
    }
  """);

  // ----------------------------------
  // Delete Booking Option
  // ----------------------------------
  static final deleteBookingOption = gql("""
    mutation DeleteBookingOption(\$id: uuid!) {
      delete_booking_option_by_pk(id: \$id) {
        id
      }
    }
  """);

  // ----------------------------------
  // Create Class Booking
  // ----------------------------------
  static final insertClassEventBooking = gql("""
  mutation InsertClassEventBooking(\$booking: class_event_bookings_insert_input!) {
    insert_class_event_bookings_one(object: \$booking) {
      id
    }
  }
""");

  // ----------------------------------
  // Update Class Booking
  // ----------------------------------
  // update class booking by id
  static final updateClassEventBooking = gql("""
    mutation UpdateClassEventBooking(\$id: uuid!, \$booking: class_event_bookings_set_input!) {
      update_class_event_bookings_by_pk(pk_columns: {id: \$id}, _set: \$booking) {
        id
      }
    }
  """);

  /// CATEGORY ///

  static final insertCategories = gql("""
  mutation InsertCategories(\$categories: [booking_category_insert_input!]!) {
    insert_booking_category(objects: \$categories) {
      affected_rows
    }
  }
""");

  // updateCategory
  static final updateCategory = gql("""
    mutation UpdateCategory(\$id: uuid!, \$category: booking_category_set_input!) {
      update_booking_category_by_pk(pk_columns: {id: \$id}, _set: \$category) {
        id
      }
    }
  """);

  // deleteCategory
  static final deleteCategory = gql("""
    mutation DeleteCategory(\$id: uuid!) {
      delete_booking_category_by_pk(id: \$id) {
        id
      }
    }
  """);

  /// Question Form ///
  //insertQuestions questions: [questions_insert_input!]!
  static final insertQuestions = gql("""
    mutation InsertQuestions(\$questions: [questions_insert_input!]!) {
      insert_questions(objects: \$questions) {
        affected_rows
         returning {
          id
        }
      }
    }
  """);

  static final insertSingleQuestion = gql("""
  mutation InsertQuestion(\$question: questions_insert_input!) {
    insert_questions_one(object: \$question) {
      id
    }
  }
""");

  static final insertMultipleChoiceOptions = gql("""
  mutation InsertMultipleChoiceOptions(\$options: [multiple_choice_option_insert_input!]!) {
    insert_multiple_choice_option(objects: \$options) {
      affected_rows
    }
  }
""");

  // updateQuestions questions: [questions_insert_input!]!
  static final updateQuestionByPk = gql("""
    mutation UpdateQuestionByPk(\$id: uuid!, \$updates: questions_set_input!) {
      update_questions_by_pk(pk_columns: {id: \$id}, _set: \$updates) {
       id
      }
    }
  """);

  // deleteQuestions questionIds: [uuid!]!
  static final deleteQuestions = gql("""
    mutation DeleteQuestions(\$questionIds: [uuid!]!) {
      delete_questions(where: {id: {_in: \$questionIds}}) {
        affected_rows
      }
    }
  """);

  /// answers ///
  //insert
  static final insertAnswers = gql("""
    mutation InsertAnswers(\$answers: [answers_insert_input!]!) {
      insert_answers(objects: \$answers) {
        returning {
          id
        }
      }
    }
  """);

  //update
  static final updateAnswerByPk = gql("""
    mutation UpdateAnswerByPk(\$id: uuid!, \$updates: answers_set_input!) {
      update_answers_by_pk(pk_columns: {id: \$id}, _set: \$updates) {
        id
      }
    }
  """);

  //delete
  static final deleteAnswers = gql("""
    mutation DeleteAnswers(\$answerIds: [uuid!]!) {
      delete_answers(where: {id: {_in: \$answerIds}}) {
        affected_rows
      }
    }
  """);

  /// Multiple Choice Answers ///
  /// insert

  static final insertMultipleChoiceAnswers = gql("""
    mutation InsertMultipleChoiceAnswers(\$answers: [multiple_choice_answer_insert_input!]!) {
      insert_multiple_choice_answer(objects: \$answers) {
        affected_rows
      }
    }
  """);

  /// delete
  /// delete_multiple_choice_answer_by_pk
  static final deleteMultipleChoiceAnswerByPk = gql("""
    mutation DeleteMultipleChoiceAnswerByPk(\$id: uuid!) {
      delete_multiple_choice_answer_by_pk(id: \$id) {
        id
      }
    }
  """);

  /// STRIPE ///
  // verifyStripeAccount
  static final verifyStripeAccount = gql("""
    mutation {verify_stripe_account}
  """);

  // Create a payment sheet for highlighting through the backend with create_direct_charge_payment_sheet
  static final createDirectChargePaymentSheet = gql("""
mutation CreateDirectChargePaymentSheet(\$classEventId: String!, \$amount: Float!) {
  create_direct_charge_payment_sheet(class_event_id: \$classEventId, amount: \$amount) {
    payment_intent
    ephemeral_key
    customer_id
  }
}
""");

  /// INVITATIONS ///

  // invite a user by email
  static final inviteByEmail = gql("""
    mutation InviteByEmail(\$email: String!) {
      invite(email: \$email) {
        success
      }
    }
  """);

  /// CLASSES ///
  // cancel a class event
  static final cancelClassEvent = gql(r"""
  mutation CancelClassEvent($id: uuid!) {
    update_class_events_by_pk(_set: {is_cancelled: true}, pk_columns: {id: $id}) {
      id
    }
  }
""");

  // delete a class
  static final deleteClassById = gql(r"""
    mutation DeleteClass($id: uuid!) {
      delete_recurring_patterns(where: { class_id: { _eq: $id } }) {
        affected_rows
      }
      delete_class_events(where: { class_id: { _eq: $id } }) {
        affected_rows
      }
      delete_class_booking_option(where: { class_id: { _eq: $id } }) { 
        affected_rows
      }
      delete_classes_by_pk(id: $id) {
        id
      }
    }
  """);

  /// STRIPE ///

  static final createStripeUser = gql("""
mutation createStripeUser(\$countryCode: String, \$defaultCurrency: String) {
  create_stripe_user(country_code: \$countryCode, default_currency: \$defaultCurrency) {
    url
  }
}
""");

  static final createTeacher = gql("""
    mutation CreateTeacher(
    \$userId: uuid!, 
    \$name: String!, 
    \$description: String!, 
    \$urlSlug: String!, 
    \$type: teacher_type_enum!, 
    \$images: [teacher_images_insert_input!]!
    ) {
      insert_teachers(
        objects: {
          name: \$name,
          description: \$description,
          url_slug: \$urlSlug,
          user_id: \$userId,
          type: \$type,
          images: { data: \$images }
        }
      ) {
        affected_rows
      }
    }
  """);

  // add these:
// Edit
// stripe_id- text, nullable

// Edit
// is_stripe_enabled- boolean, default: false

// Edit
// individual_commission- numeric, nullable

  static final updateTeacher = gql("""
    mutation UpdateTeacherAsTeacherUser(
      \$teacherId: uuid!,
      \$userId: uuid!,
      \$name: String!,
      \$description: String!,
      \$urlSlug: String!,
      \$type: teacher_type_enum!,
      \$images: [teacher_images_insert_input!]!
      \$teacherStripeId: String,
      \$isStripeEnabled: Boolean,
      \$individualCommission: numeric
    ) {
      delete_teachers_by_pk(id: \$teacherId) {
        id
      }
      delete_teacher_images(where: { teacher_id: { _eq: \$teacherId } }) {
        affected_rows
      }
      insert_teachers(
        objects: {
          id: \$teacherId,
          name: \$name,
          description: \$description,
          url_slug: \$urlSlug,
          user_id: \$userId,
          type: \$type,
          images: { data: \$images }
          stripe_id: \$teacherStripeId,
          is_stripe_enabled: \$isStripeEnabled,
          individual_commission: \$individualCommission
        }
      ) {
        affected_rows
      }
    }
  """);

// class_owners: {data: {teacher_id: "6d76a0f1-8e33-40f5-a300-505329d30ae0", is_payment_receiver: false}},
  static final insertClassWithRecurringPatterns = gql("""
  mutation InsertClassWithRecurringPatterns(
    \$name: String!,
    \$description: String!,
    \$imageUrl: String!,
    \$eventType: event_type_enum!,
    \$location: String!,
    \$locationName: String!,
    \$timezone: String!,
    \$urlSlug: String!,
    \$recurringPatterns: [recurring_patterns_insert_input!]!,
    \$classOwners: [class_owners_insert_input!]!
    \$classTeachers: [class_teachers_insert_input!]!
    \$max_booking_slots: Int
    \$location_country: String
    \$location_city: String
    \$is_cash_allowed: Boolean
  ) {
    insert_classes_one(
      object: {
        name: \$name,
        description: \$description,
        image_url: \$imageUrl,
        location_country: \$location_country,
        event_type: \$eventType,
        location: {type: "Point", coordinates: \$location},
        location_name: \$locationName,
        timezone: \$timezone,
        url_slug: \$urlSlug,
        location_city: \$location_city,
        is_cash_allowed: \$is_cash_allowed,
        recurring_patterns: {
          data: \$recurringPatterns
        }
   
        class_owners: {
          data: \$classOwners
        }
        class_teachers: {
          data: \$classTeachers
        }
        max_booking_slots: \$max_booking_slots
        created_by_id: \$created_by_id
      }
    ) {
      id
      name
      url_slug
      description
      image_url
      event_type
      location_name
      location_country
      location_city
      is_cash_allowed
      max_booking_slots
      timezone
    }
  }
  """);

  static final updateClassWithRecurringPatterns = gql("""
  mutation UpdateClassWithRecurringPatterns(
    \$id: uuid!,
    \$name: String!,
    \$description: String!,
    \$imageUrl: String!,
    \$eventType: event_type_enum!,
    \$location: String!,
    \$locationName: String!,
    \$timezone: String!,
    \$location_country: String,
    \$urlSlug: String!,
    \$recurringPatterns: [recurring_patterns_insert_input!]!,
    \$classOwners: [class_owners_insert_input!]!
    \$classTeachers: [class_teachers_insert_input!]!
    \$max_booking_slots: Int
    \$location_city: String
    \$is_cash_allowed: Boolean
  ) {

    # Delete the class by id
    delete_classes_by_pk(id: \$id) {
      id
    }
    
    # Recreate the class with updated information
    insert_classes_one(
      object: {
        id: \$id,
        name: \$name,
        description: \$description,
        image_url: \$imageUrl,
        event_type: \$eventType,
        location: {type: "Point", coordinates: \$location},
        location_name: \$locationName,
        timezone: \$timezone,
        url_slug: \$urlSlug,
        location_country: \$location_country,
        location_city: \$location_city,
        is_cash_allowed: \$is_cash_allowed,
        recurring_patterns: {
          data: \$recurringPatterns
        },
       
        class_owners: {
          data: \$classOwners
        },
        class_teachers: {
          data: \$classTeachers
        },
        max_booking_slots: \$max_booking_slots
      }
    ) {
      id
      class_owners {
        teacher_id
      }
    }
  }
""");

  // entityType -> "class_teacher"
  // entityId -> class_id
  // email can be null if you invite a user that is already registered
  static final inviteMutation = gql("""
  mutation Invite(
    \$entityId: String,
    \$entityType: String,
    \$email: String,
    \$userId: String
  ) {
    invite(
      entity_id: \$entityId,
      entity: \$entityType,
      email: \$email,
      userId: \$userId
    ) {
      success
    }
  }
""");

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

  /// USER ///

  static final updateUser = '''
      mutation updateUser(\$id: uuid!, \$changes: users_set_input!) {
        update_users_by_pk(pk_columns: {id: \$id}, _set: \$changes) {
          ${Fragments.userFragment}
        }
      }
    ''';

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

  static final updateOrInsertFcmToken = gql("""
   mutation UpdateFcmToken(\$fcmToken: String!, \$userId: uuid!) {
      update_users(_set: {fcm_token: \$fcmToken}, where: {id: {_eq: \$userId}}) {
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

// activate flag by userid and class id
  static final activateFlag = gql("""
  mutation activateFlag(\$class_id: uuid!, \$user_id: uuid!) {
  update_class_flag(where: {class_id: {_eq: \$class_id}, user_id: {_eq: \$user_id}}, _set: {is_active: true}) {
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

  static final deleteAccount = gql("""
mutation deleteAccount{
  delete_account {
    success
  }
}""");

  /// Comments ///

  static final insertComment = gql("""
mutation insertComment(\$content: String!, \$rating: Int!, \$teacher_id: uuid!, \$user_id: uuid!) {
  insert_comments_one(object: {
    content: \$content
    rating: \$rating
    teacher_id: \$teacher_id
    user_id: \$user_id
  }) {
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

  static final updateComment = gql("""
mutation updateComment(\$id: uuid!, \$content: String!, \$rating: Int!) {
  update_comments_by_pk(
    pk_columns: {id: \$id}
    _set: {
      content: \$content
      rating: \$rating
      updated_at: "now()"
    }
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

  static final deleteComment = gql("""
mutation deleteComment(\$id: uuid!) {
  delete_comments_by_pk(id: \$id) {
    id
  }
}
""");
}
