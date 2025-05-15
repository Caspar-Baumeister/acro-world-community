enum GraphQLErrorCode {
  INVALID_EMAIL,
  MISSING_PASSWORD,
  INVALID_PASSWORD,
  EMAIL_NOT_FOUND,
  DEFAULT_ERROR
}

Map<String, String> parseGraphQLError(dynamic response) {
  // Initialize an errorMap with empty strings
  Map<String, String> errorMap = {
    'emailError': '',
    'passwordError': '',
    'error': ''
  };

  // If response contains "errors", loop through them
  if (response['errors'] != null && response['errors'].isNotEmpty) {
    for (var error in response['errors']) {
      final errorCode = _getCodeFromError(error);
      final errorMessage = _getErrorMessage(errorCode);

      // Assign to emailError, passwordError, or generic error
      if (errorCode == GraphQLErrorCode.INVALID_EMAIL ||
          errorCode == GraphQLErrorCode.EMAIL_NOT_FOUND) {
        errorMap['emailError'] = errorMessage;
      } else if (errorCode == GraphQLErrorCode.MISSING_PASSWORD ||
          errorCode == GraphQLErrorCode.INVALID_PASSWORD) {
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
  // Attempt to parse code from 'extensions.exception.thrownValue.message'
  final codeString =
      error['extensions']?['exception']?['thrownValue']?['message'];
  if (codeString != null) {
    return _mapStringToErrorCode(codeString);
  }

  // If not found above, look at 'error['message']'
  // The server might embed something like:
  //   "Unexpected error value: { code: \"ERR_BAD_REQUEST\", message: \"EMAIL_NOT_FOUND\" }"
  final rawMessage = error['message'] as String?;
  if (rawMessage != null) {
    // Use a Regex to capture the text after `message: "` and before the next quote
    final match = RegExp(r'message:\s*"([^"]+)"').firstMatch(rawMessage);
    if (match != null) {
      final extractedMessage = match.group(1); // e.g. "EMAIL_NOT_FOUND"
      if (extractedMessage != null) {
        return _mapStringToErrorCode(extractedMessage);
      }
    }
  }

  // Fallback: default error
  return GraphQLErrorCode.DEFAULT_ERROR;
}

GraphQLErrorCode _mapStringToErrorCode(String codeString) {
  // Compare the uppercase version of the enum's name
  return GraphQLErrorCode.values.firstWhere(
    (e) =>
        e.toString().split('.').last.toUpperCase() == codeString.toUpperCase(),
    orElse: () => GraphQLErrorCode.DEFAULT_ERROR,
  );
}

/// lib/exceptions/auth_exception.dart

class AuthException implements Exception {
  /// Per-field error messages, e.g. `{ 'email': 'Email not found', 'password': '' }`
  final Map<String, String> fieldErrors;

  /// A top-level error message (if any), e.g. “An unexpected error occurred”
  final String globalError;

  AuthException({
    required this.fieldErrors,
    required this.globalError,
  });

  @override
  String toString() {
    // If you want something concise when logging:
    if (globalError.isNotEmpty) return globalError;
    return fieldErrors.values.where((e) => e.isNotEmpty).join('; ');
  }
}
