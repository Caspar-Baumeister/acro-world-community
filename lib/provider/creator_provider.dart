import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/teacher_model.dart';
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

  // delete active creator
  void deleteActiveTeacher() {
    _activeTeacher = null;
    notifyListeners();
  }

  Future<bool> setCreatorFromToken() async {
    if (await TokenSingletonService().getToken() == null) {
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
      print("no me found");
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
      CustomErrorHandler.captureException(e.toString(), stackTrace: stackTrace);
      return false;
    }
  }
}
