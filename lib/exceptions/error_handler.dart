// Centralized logging service that handles different log levels and integrates with Sentry

import 'package:acroworld/environment.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class CustomErrorHandler {
  static Future<void> captureException(dynamic exception,
      {StackTrace? stackTrace}) async {
    await _log(LogLevel.error, exception.toString(), stackTrace: stackTrace);

    if (AppEnvironment.enableSentry) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> logDebug(String message, {StackTrace? stackTrace}) async {
    await _log(LogLevel.debug, message, stackTrace: stackTrace);
  }

  static Future<void> logInfo(String message, {StackTrace? stackTrace}) async {
    await _log(LogLevel.info, message, stackTrace: stackTrace);
  }

  static Future<void> logWarning(String message,
      {StackTrace? stackTrace}) async {
    await _log(LogLevel.warning, message, stackTrace: stackTrace);
  }

  static Future<void> logError(String message, {StackTrace? stackTrace}) async {
    await _log(LogLevel.error, message, stackTrace: stackTrace);
  }

  static Future<void> _log(LogLevel level, String message,
      {StackTrace? stackTrace}) async {
    final timestamp = DateTime.now().toIso8601String();
    final levelString = level.name.toUpperCase();

    // Format the log message
    final formattedMessage = '[$timestamp] [$levelString] $message';

    // Print to console (always in development, controlled in production)
    if (AppEnvironment.isDev || level == LogLevel.error) {
      // ignore: avoid_print
      print(formattedMessage);

      if (stackTrace != null) {
        // ignore: avoid_print
        print('Stack trace: $stackTrace');
      }
    }

    // Send to Sentry for errors and warnings in production
    if (AppEnvironment.enableSentry &&
        (level == LogLevel.error || level == LogLevel.warning)) {
      await Sentry.addBreadcrumb(
        Breadcrumb(
          message: formattedMessage,
          level:
              level == LogLevel.error ? SentryLevel.error : SentryLevel.warning,
          timestamp: DateTime.now(),
        ),
      );
    }
  }
}
