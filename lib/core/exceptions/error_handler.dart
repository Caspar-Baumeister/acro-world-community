// build an errorhandler class with an captureException method that takes in an exception and a stacktrace and if the app is in production mode, it will send the exception to sentry.

import 'package:acroworld/core/environment.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CustomErrorHandler {
  static Future<void> captureException(dynamic exception,
      {StackTrace? stackTrace}) async {
    if (AppEnvironment.enableSentry) {
      // ignore: avoid_print
      print(exception);
      // ignore: avoid_print
      print(stackTrace.toString());
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    } else {
      // ignore: avoid_print
      print(exception);
      // ignore: avoid_print
      print(stackTrace.toString());
    }
  }
}
