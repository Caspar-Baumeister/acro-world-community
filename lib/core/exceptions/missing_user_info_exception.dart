class MissingUserInfoException implements Exception {
  String cause;
  MissingUserInfoException(this.cause);
}
