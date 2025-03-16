import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/data/repositories/stripe_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

// Keeps track of the signed in Creator in the creator mode.
// Deletes the creator when switching to user mode.
// Updates the creator when in creator settings
// sets stripe account when creating a stripe account
class CreatorProvider extends ChangeNotifier {
  TeacherModel? _activeTeacher;
  bool _isLoading = false;

  CreatorProvider() {
    setCreatorFromToken();
  }

  TeacherModel? get activeTeacher {
    return _activeTeacher;
  }

  bool get isLoading {
    return _isLoading;
  }

  // get stripe login link
  Future<String?> getStripeLoginLink() async {
    try {
      StripeRepository stripeRepository =
          StripeRepository(apiService: GraphQLClientSingleton());
      String? stripeLoginLink = await stripeRepository.getStripeLoginLink();
      print("stripeLoginLink: $stripeLoginLink");
      return stripeLoginLink;
    } catch (e) {
      CustomErrorHandler.captureException(e.toString());
      return null;
    }
  }

  // create stripe user
  Future<String?> createStripeUser({
    String? countryCode,
    String? defaultCurrency,
  }) async {
    try {
      StripeRepository stripeRepository =
          StripeRepository(apiService: GraphQLClientSingleton());
      String? stripeLoginLink = await stripeRepository.createStripeUser(
          countryCode: countryCode, defaultCurrency: defaultCurrency);
      print("stripeLoginLink: $stripeLoginLink");
      return stripeLoginLink;
    } catch (e, s) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: s);
      return null;
    }
  }

  // delete active creator
  void deleteActiveTeacher() {
    _activeTeacher = null;
    notifyListeners();
  }

  Future<bool> setCreatorFromToken() async {
    print("setting creator from token");
    if (await TokenSingletonService().getToken() == null) {
      print("no token");
      _activeTeacher = null;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();
    // create the options
    QueryOptions options = QueryOptions(
        document: Queries.getMeCreator, fetchPolicy: FetchPolicy.networkOnly);

    final graphQLClient = GraphQLClientSingleton().client;

    // get the result
    final result = await graphQLClient.query(options);

    // if there is an exception, throw it
    if (result.hasException) {
      CustomErrorHandler.captureException(result.exception.toString(),
          stackTrace: result.exception!.originalStackTrace);
      _activeTeacher = null;
      _isLoading = false;
      notifyListeners();
      return false;
    } else if (result.data!["me"] == null || result.data!["me"].isEmpty) {
      CustomErrorHandler.captureException("no me found in creator",
          stackTrace: StackTrace.current);
      _activeTeacher = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }
    // creates a Creator object from the result
    try {
      _isLoading = false;
      _activeTeacher =
          TeacherModel.fromJson(result.data!["me"][0]["teacher_profile"]);

      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      _activeTeacher = null;
      _isLoading = false;
      CustomErrorHandler.captureException(
          "Error in setting creator from token, $e ${result.data!["me"][0]}",
          stackTrace: stackTrace);
      notifyListeners();
      return false;
    }
  }

  // clean up the creator
  void cleanUp() {
    _activeTeacher = null;
    _isLoading = false;
    notifyListeners();
  }
}
