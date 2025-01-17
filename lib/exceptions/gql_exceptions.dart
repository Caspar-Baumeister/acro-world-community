enum GraphQLErrorCode {
  INVALID_EMAIL,
  MISSING_PASSWORD,
  INVALID_PASSWORD,
  EMAIL_NOT_FOUND,
  DEFAULT_ERROR
}

Map<String, String> parseGraphQLError(dynamic response) {
  Map<String, String> errorMap = {
    'emailError': '',
    'passwordError': '',
    'error': ''
  };

  if (response['errors'] != null && response['errors'].isNotEmpty) {
    for (var error in response['errors']) {
      final errorCode = _getCodeFromError(error);
      final errorMessage = _getErrorMessage(errorCode);

      if (errorCode == GraphQLErrorCode.INVALID_EMAIL ||
          errorCode == GraphQLErrorCode.EMAIL_NOT_FOUND) {
        errorMap['emailError'] = errorMessage;
      } else if (errorCode == GraphQLErrorCode.MISSING_PASSWORD ||
          errorCode == GraphQLErrorCode.INVALID_PASSWORD) {
        // Assuming you have a bad password error code
        errorMap['passwordError'] = errorMessage;
      } else {
        errorMap['error'] = errorMessage;
      }
    }
  }

  return errorMap;
}

String _getErrorMessage(GraphQLErrorCode errorCode) {
  switch (errorCode) {
    case GraphQLErrorCode.INVALID_EMAIL:
      return "Email is invalid";
    case GraphQLErrorCode.MISSING_PASSWORD:
      return "Password is missing";
    case GraphQLErrorCode.EMAIL_NOT_FOUND:
      return "Email not found";
    case GraphQLErrorCode.INVALID_PASSWORD:
      return "Password is invalid";

    default:
      return "An unknown error occurred";
  }
}

GraphQLErrorCode _getCodeFromError(Map<String, dynamic> error) {
  final codeString =
      error['extensions']?['exception']?['thrownValue']?['message'];
  if (codeString != null) {
    return GraphQLErrorCode.values.firstWhere(
      (e) =>
          e.toString().split('.').last.toUpperCase() ==
          codeString.toUpperCase(),
      orElse: () => GraphQLErrorCode.DEFAULT_ERROR, // Default error code
    );
  }
  return GraphQLErrorCode.DEFAULT_ERROR;
}
