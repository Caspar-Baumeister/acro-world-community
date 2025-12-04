import 'package:graphql_flutter/graphql_flutter.dart';

class TalentProfileQueries {
  /// Check if a talent profile exists for the current user
  static final checkTalentProfileExists = gql("""
    query CheckTalentProfileExists(\$user_id: uuid!) {
      talent_profiles(where: {user_id: {_eq: \$user_id}}, limit: 1) {
        id
      }
    }
  """);

  /// Get the talent profile for the current user
  static final getTalentProfile = gql("""
    query GetTalentProfile(\$user_id: uuid!) {
      talent_profiles(where: {user_id: {_eq: \$user_id}}, limit: 1) {
        id
        user_id
        work_types_text
        location_cities_text
        disciplines_text
        discipline_details_text
        certifications_text
        experience_length
        experience_description
        languages_text
        payment_expectations
        accepts_ticket_compensation
        email_opt_in
        created_at
        updated_at
      }
    }
  """);
}

class TalentProfileMutations {
  /// Create a new talent profile
  static final createTalentProfile = gql("""
    mutation CreateTalentProfile(\$profile: talent_profiles_insert_input!) {
      insert_talent_profiles_one(object: \$profile) {
        id
        user_id
        work_types_text
        location_cities_text
        disciplines_text
        discipline_details_text
        certifications_text
        experience_length
        experience_description
        languages_text
        payment_expectations
        accepts_ticket_compensation
        email_opt_in
        created_at
        updated_at
      }
    }
  """);
}
