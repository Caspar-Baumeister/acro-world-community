import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/data/repositories/stripe_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// State for creator management
class CreatorState {
  final TeacherModel? activeTeacher;
  final bool isLoading;

  const CreatorState({
    this.activeTeacher,
    this.isLoading = false,
  });

  CreatorState copyWith({
    TeacherModel? activeTeacher,
    bool? isLoading,
  }) {
    return CreatorState(
      activeTeacher: activeTeacher ?? this.activeTeacher,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier for creator state management
class CreatorNotifier extends StateNotifier<CreatorState> {
  CreatorNotifier() : super(const CreatorState()) {
    _initialize();
  }

  /// Initialize the creator from token
  Future<void> _initialize() async {
    await setCreatorFromToken();
  }

  /// Get stripe login link
  Future<String?> getStripeLoginLink() async {
    try {
      final stripeRepository = StripeRepository(apiService: GraphQLClientSingleton());
      final stripeLoginLink = await stripeRepository.getStripeLoginLink();
      CustomErrorHandler.logDebug("stripeLoginLink: $stripeLoginLink");
      return stripeLoginLink;
    } catch (e) {
      CustomErrorHandler.logError('Error getting stripe login link: $e');
      return null;
    }
  }

  /// Create stripe user
  Future<String?> createStripeUser({
    String? countryCode,
    String? defaultCurrency,
  }) async {
    try {
      final stripeRepository = StripeRepository(apiService: GraphQLClientSingleton());
      final stripeLoginLink = await stripeRepository.createStripeUser(
        countryCode: countryCode,
        defaultCurrency: defaultCurrency,
      );
      CustomErrorHandler.logDebug("stripeLoginLink: $stripeLoginLink");
      return stripeLoginLink;
    } catch (e, s) {
      CustomErrorHandler.logError('Error creating stripe user: $e', stackTrace: s);
      return null;
    }
  }

  /// Delete active creator
  void deleteActiveTeacher() {
    state = state.copyWith(activeTeacher: null);
  }

  /// Set creator from token
  Future<bool> setCreatorFromToken() async {
    CustomErrorHandler.logDebug("setting creator from token");
    
    final token = await TokenSingletonService().getToken();
    if (token == null) {
      CustomErrorHandler.logDebug("no token");
      state = state.copyWith(activeTeacher: null);
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      final client = GraphQLClientSingleton().client;
      final result = await client.query(QueryOptions(
        document: Queries.getMeCreator,
        fetchPolicy: FetchPolicy.networkOnly,
      ));

      if (result.hasException) {
        CustomErrorHandler.logError('Error fetching teacher: ${result.exception}');
        state = state.copyWith(isLoading: false, activeTeacher: null);
        return false;
      }

      if (result.data?["me"] == null || result.data?["me"].isEmpty) {
        CustomErrorHandler.logError("no me found in creator");
        state = state.copyWith(isLoading: false, activeTeacher: null);
        return false;
      }

      final teacher = TeacherModel.fromJson(result.data!["me"][0]["teacher_profile"]);
      state = state.copyWith(
        activeTeacher: teacher,
        isLoading: false,
      );
      CustomErrorHandler.logDebug("Creator set successfully");
      return true;
    } catch (e, s) {
      CustomErrorHandler.logError('Error in setCreatorFromToken: $e', stackTrace: s);
      state = state.copyWith(isLoading: false, activeTeacher: null);
      return false;
    }
  }

  /// Update creator
  Future<void> updateCreator(TeacherModel teacher) async {
    state = state.copyWith(activeTeacher: teacher);
  }

  /// Test constructor for unit tests
  CreatorNotifier.test() : super(const CreatorState());
}

/// Provider for creator state
final creatorProvider = StateNotifierProvider<CreatorNotifier, CreatorState>((ref) {
  return CreatorNotifier();
});
