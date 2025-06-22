import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

Future<void> sendEmail(String body, String subject, List<String>? cc,
    List<String>? recipients) async {
  final Email email = Email(
    body: body,
    subject: subject,
    recipients: recipients ?? ["info@acroworld.de"],
    cc: cc ?? ["info@acroworld.de"],
  );

  try {
    await FlutterEmailSender.send(email);
  } catch (error, s) {
    CustomErrorHandler.captureException(error, stackTrace: s);
    if (error is PlatformException && error.code == 'not_available') {
      showErrorToast(
        "No email clients found! Please contact us at info@acroworld.de",
      );
    } else {
      showErrorToast(
        "An error occurred sending feedback. Please contact us at info@acroworld.de",
      );
    }
  }
}
