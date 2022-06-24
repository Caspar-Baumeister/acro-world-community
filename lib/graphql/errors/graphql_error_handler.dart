import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLErrorHandler {
  void handleError(OperationException? errorData) {
    print(errorData);
    String errorMessage = "";
    if (errorData != null) {
      if (errorData.graphqlErrors.isNotEmpty) {
        errorMessage = errorData.graphqlErrors[0].message;
      }
    }
    if (errorMessage == "") {
      errorMessage = "An unknown error occured";
    }
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
