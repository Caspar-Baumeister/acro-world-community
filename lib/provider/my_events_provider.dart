import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MyEventsProvider extends ChangeNotifier {
  // loads and keeps track of events that are created by me or where I'm taking place in.
  // Will
  bool _loading = true;
  List<ClassModel> _myCreatedEvents = [];

  // getter for loading
  bool get loading => _loading;
  List<ClassModel> get myCreatedEvents => _myCreatedEvents;

  // fetch data init
  MyEventsProvider() {
    fetchMyEvents();
  }

  // fetch classevents from the backend in a certain radius of the location
  Future<void> fetchMyEvents() async {
    // set loading
    _loading = true;
    notifyListeners();

    QueryOptions queryOptions = QueryOptions(
      document: Queries.getClasses,
      fetchPolicy: FetchPolicy.networkOnly,
    );
    try {
      final graphQLClient = GraphQLClientSingleton().client;
      QueryResult<Object?> result = await graphQLClient.query(queryOptions);

      if (result.hasException) {
        CustomErrorHandler.captureException(result.exception!);
        return;
      }

      if (result.data != null && result.data!["classes"] != null) {
        try {
          _myCreatedEvents = List<ClassModel>.from(
            result.data!['classes'].map((json) => ClassModel.fromJson(json)),
          );
        } catch (e, s) {
          CustomErrorHandler.captureException(e, stackTrace: s);
        }
      }
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
    }

    // set classevents
    _loading = false;
    notifyListeners();
  }
}
