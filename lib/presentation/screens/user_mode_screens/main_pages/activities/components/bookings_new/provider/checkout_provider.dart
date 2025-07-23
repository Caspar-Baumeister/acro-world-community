// lib/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/provider/checkout_provider.dart

import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/repositories/stripe_repository.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/provider/booking_option_selection_provider.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/provider/questionnaire_answers_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/stripe_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Represents the state of the checkout process
class CheckoutState {
  final bool isLoading;
  final String? error;

  const CheckoutState({this.isLoading = false, this.error});

  CheckoutState copyWith({bool? isLoading, String? error}) {
    return CheckoutState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final Ref ref;
  CheckoutNotifier(this.ref) : super(const CheckoutState());

  /// Kick off the complete booking flow:
  /// - Save answers
  /// - Create Stripe PaymentIntent & present sheet (if online)
  /// - Or perform cash-booking via GraphQL mutation
  /// - Advance to confirmation step
  Future<void> completeBooking(int bookingMethod, String classEventId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 1) Get current user
      final user = await ref.read(userRiverpodProvider.future);
      if (user?.id == null) {
        throw Exception("Not logged in");
      }

      // 2) Get selected option & eventId
      final bookingOption = ref.watch(selectedBookingOptionIdProvider);

      if (bookingOption == null) {
        throw Exception("Missing booking option or event ID");
      }

      // 3) Ensure required questions are answered
      final answers = ref.read(questionnaireAnswersProvider);

      // 4) Save answers via GraphQL mutation
      final answerModels = answers.values.toList();
      if (answerModels.isNotEmpty) {
        final gql = GraphQLClientSingleton();
        await gql.mutate(MutationOptions(
          document: Mutations.insertAnswers,
          variables: {
            "answers": answerModels.map((a) => a.toJson()).toList(),
          },
        ));
      }

      // 5) Depending on payment method:
      if (bookingMethod == 0) {
        // create & present Stripe sheet
        final gqlSingleton = GraphQLClientSingleton();
        final String? pi = await StripeService(
                stripeRepository: StripeRepository(apiService: gqlSingleton))
            .initPaymentSheet(
          user!,
          bookingOption,
          classEventId,
        );
        if (pi == null) {
          throw Exception("Failed to initialize payment sheet");
        }
        await StripeService(
          stripeRepository: StripeRepository(apiService: gqlSingleton),
        ).attemptToPresentPaymentSheet(pi);
      } else {
        // CASH: do direct GraphQL booking insert
        final gql = GraphQLClientSingleton();
        // await gql.mutate(MutationOptions(
        //   document: Mutations.insertClassEventBooking,
        //   variables: {
        //     "booking": {
        //       "amount": (option.realPriceDiscounted() * 100).round(),
        //       "booking_option_id": option.id,
        //       "class_event_id": eventId,
        //       "currency": option.currency.value,
        //       "status": "WaitingForPayment",
        //       "user_id": user?.id,
        //     }
        //   },
        // ));
      }

      // 6) Fire refetch event and advance step
      // ref.read(eventBusProvider).fireRefetchBookingQuery();

      // 7) Optionally clear local booking state:
      ref.read(selectedBookingOptionIdProvider.notifier).state = null;
      ref.invalidate(questionnaireAnswersProvider);

      state = state.copyWith(isLoading: false);
    } catch (e, st) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Expose as a Riverpod provider
final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>(
  (ref) => CheckoutNotifier(ref),
);
