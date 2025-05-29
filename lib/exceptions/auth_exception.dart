class AuthException implements Exception {
  /// A top-level error message (if any), e.g. “An unexpected error occurred”
  final String error;

  AuthException({
    required this.error,
  });

  @override
  String toString() {
    // If you want something concise when logging:
    if (error.isNotEmpty) return error;
    return '';
  }
}
