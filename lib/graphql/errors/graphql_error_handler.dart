import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLErrorHandler {
  void handleError(OperationException? errorData) {
    String errorMessage = "";
    if (errorData != null) {
      if (errorData.graphqlErrors.isNotEmpty) {
        errorMessage = errorData.graphqlErrors[0].message;
      }
    }
    if (errorMessage == "") {
      errorMessage = "An unknown error occured";
    }
    showErrorToast(errorMessage);
  }
}
