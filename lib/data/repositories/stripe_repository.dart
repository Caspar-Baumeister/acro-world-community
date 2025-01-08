import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StripeRepository {
  final GraphQLClientSingleton apiService;

  StripeRepository({required this.apiService});

  /// Create a payment sheet through the backend.
  /// Takes the booking option id and class event id as arguments.
  /// Returns the payment sheet data.
  Future<Map<String, dynamic>?> createPaymentSheet(
      String bookingOptionId, String classEventId) async {
    print("classEventId: $classEventId");
    final response = await apiService.mutate(
      MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: Mutations.createPaymentSheet,
        variables: {
          "bookingOptionId": bookingOptionId,
          "classEventId": classEventId,
        },
      ),
    );

    if (response.hasException) {
      throw Exception(
          'Failed to create payment sheet. Status code: ${response.exception?.raw.toString()}');
    }

    return response.data?["create_payment_sheet"];
  }

  /// Confirm the payment intent after presenting the payment sheet.
  Future<void> confirmPayment(String paymentIntentId) async {
    await apiService.mutate(
      MutationOptions(
        document: Mutations.confirmPayment,
        variables: {'payment_intent_id': paymentIntentId},
      ),
    );
  }

  Future<String?> getStripeLoginLink() async {
    QueryOptions queryOptions = QueryOptions(
      document: Queries.getStripeLoginLink,
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.query(queryOptions);

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to get stripe login link. Status code: ${result.exception?.raw.toString()}');
    }

    return result.data!['stripe_login_link'];
  }

  //createStripeUser
  Future<String?> createStripeUser() async {
    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.createStripeUser,
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);

    print("result: ${result.data}");
    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to create stripe user. result: ${result.data}. Status code: ${result.exception?.raw.toString()}');
    }

    return result.data!['create_stripe_user']['url'];
  }

  // createDirectChargePaymentSheet
  Future<Map<String, dynamic>?> createDirectChargePaymentSheet(
      String classEventId, double amount) async {
    final response = await apiService.mutate(
      MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: Mutations.createDirectChargePaymentSheet,
        variables: {
          "classEventId": classEventId,
          "amount": amount,
        },
      ),
    );

    if (response.hasException) {
      throw Exception(
          'Failed to create direct charge payment sheet. Status code: ${response.exception?.raw.toString()}');
    }

    return response.data?["create_direct_charge_payment_sheet"];
  }

  // verify_stripe_account
  Future<bool> verifyStripeAccount() async {
    final response = await apiService.mutate(
      MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: Mutations.verifyStripeAccount,
      ),
    );

    print("stripe response: ${response.data}");

    if (response.hasException) {
      throw Exception(
          'Failed to verify stripe account. Status code: ${response.exception?.raw.toString()}');
    }

    return response.data!["verify_stripe_account"];
  }
}
