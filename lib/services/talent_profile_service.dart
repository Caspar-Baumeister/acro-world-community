import 'package:acroworld/data/graphql/talent_profile_queries.dart';
import 'package:acroworld/data/models/talent_profile_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TalentProfileService {
  final GraphQLClient _client;

  TalentProfileService() : _client = GraphQLClientSingleton().client;

  /// Check if a talent profile exists for the given user ID
  Future<bool> checkTalentProfileExists(String userId) async {
    try {
      final result = await _client.query(
        QueryOptions(
          document: TalentProfileQueries.checkTalentProfileExists,
          variables: {'user_id': userId},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        CustomErrorHandler.captureException(
          'Error checking talent profile: ${result.exception}',
        );
        return false;
      }

      final profiles = result.data?['talent_profiles'] as List<dynamic>?;
      return profiles != null && profiles.isNotEmpty;
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      return false;
    }
  }

  /// Get the talent profile for the given user ID
  Future<TalentProfile?> getTalentProfile(String userId) async {
    try {
      final result = await _client.query(
        QueryOptions(
          document: TalentProfileQueries.getTalentProfile,
          variables: {'user_id': userId},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        CustomErrorHandler.captureException(
          'Error fetching talent profile: ${result.exception}',
        );
        return null;
      }

      final profiles = result.data?['talent_profiles'] as List<dynamic>?;
      if (profiles == null || profiles.isEmpty) {
        return null;
      }

      return TalentProfile.fromJson(profiles.first as Map<String, dynamic>);
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      return null;
    }
  }

  /// Create a new talent profile
  Future<TalentProfile?> createTalentProfile({
    required String userId,
    required String workTypesText,
    required String locationCitiesText,
    required String disciplinesText,
    required String disciplineDetailsText,
    required String certificationsText,
    required String experienceLength,
    required String experienceDescription,
    required String languagesText,
    required String paymentExpectations,
    required bool acceptsTicketCompensation,
    required bool emailOptIn,
  }) async {
    try {
      final profileInput = {
        'user_id': userId,
        'work_types_text': workTypesText,
        'location_cities_text': locationCitiesText,
        'disciplines_text': disciplinesText,
        'discipline_details_text': disciplineDetailsText,
        'certifications_text': certificationsText,
        'experience_length': experienceLength,
        'experience_description': experienceDescription,
        'languages_text': languagesText,
        'payment_expectations': paymentExpectations,
        'accepts_ticket_compensation': acceptsTicketCompensation,
        'email_opt_in': emailOptIn,
      };

      final result = await _client.mutate(
        MutationOptions(
          document: TalentProfileMutations.createTalentProfile,
          variables: {'profile': profileInput},
        ),
      );

      if (result.hasException) {
        CustomErrorHandler.captureException(
          'Error creating talent profile: ${result.exception}',
        );
        return null;
      }

      final data = result.data?['insert_talent_profiles_one'];
      if (data == null) {
        return null;
      }

      return TalentProfile.fromJson(data as Map<String, dynamic>);
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      return null;
    }
  }
}

