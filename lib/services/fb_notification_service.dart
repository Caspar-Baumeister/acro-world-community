import 'package:acroworld/core/exceptions/error_handler.dart';
import 'package:acroworld/core/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/models/fcm/fcm_event.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future initialize() async {
    // Request permissions
    await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<String?> getToken() async {
    String? token = await _fcm.getToken();
    return token;
  }

  // updateToken function with userprovider
  Future<void> updateToken() async {
    getToken().then((value) {
      if (value == null) {
        return;
      }
      try {
        GraphQLClientSingleton().mutate(
          MutationOptions(
            document: Mutations.updateFcmToken,
            variables: {
              'fcmToken': value,
            },
          ),
        );
      } catch (e) {
        CustomErrorHandler.captureException(e, stackTrace: StackTrace.current);
      }
    }).catchError((err) {
      CustomErrorHandler.captureException(err, stackTrace: StackTrace.current);
    });
  }

  Future<void> addListeners(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      switch (message.data["type"]) {
        case "EventCreated":
          try {
            // Show a Snackbar to notify the user about the message
            // final event = FCMEvent.fromJson(message.data);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     behavior: SnackBarBehavior.floating,
            //     backgroundColor: Colors.teal,
            //     duration: const Duration(seconds: 5),
            //     content: Center(
            //       child: Text(
            //         "Teacher you follow where added to the ${event.eventType?.value} ${event.name}",
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //     action: SnackBarAction(
            //       label: 'View Event',
            //       onPressed: () {
            //         // Navigate to the EventScreen with the extracted ID
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) => SingleEventQueryWrapper(
            //               eventId: event.id,
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // );
          } catch (e) {
            showErrorToast(
              "We could not redirect you to the relevant event",
            );
            print("onMessage error");
            print(e.toString());
          }

          break;
        case "EventUpdated":
          try {
            // Show a Snackbar to notify the user about the message
            final event = FCMEvent.fromJson(message.data);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.teal,
                duration: const Duration(seconds: 5),
                content: Center(
                  child: Text(
                    "${event.name} has been updated. Click to learn more",
                    textAlign: TextAlign.center,
                  ),
                ),
                action: SnackBarAction(
                  label: 'View Event',
                  onPressed: () {
                    // Navigate to the EventScreen with the extracted ID
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => SingleEventQueryWrapper(
                    //       eventId: event.id,
                    //     ),
                    //   ),
                    // );
                    // navigatorKey.currentState!.push(
                    // MaterialPageRoute(
                    //   builder: (context) => SingleEventQueryWrapper(
                    //     eventId: event.id,
                    //   ),
                    // ),
                    // );
                  },
                ),
              ),
            );
          } catch (e) {
            showErrorToast(
              "We could not redirect you to the relevant event",
            );
            print("onMessage error");
            print(e.toString());
          }
          break;

        default:
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      switch (message.data["type"]) {
        case "EventCreated":
          try {
            // final event = FCMEvent.fromJson(message.data);
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => SingleEventQueryWrapper(
            //       eventId: event.id,
            //     ),
            //   ),
            // );
            // navigatorKey.currentState!.push(
            //   MaterialPageRoute(
            //     builder: (context) => SingleEventQueryWrapper(
            //       eventId: event.id,
            //     ),
            //   ),
            // );
          } catch (e) {
            showErrorToast(
              "We could not redirect you to the relevant event",
            );
            print("onMessageOpenedApp error");
            print(e.toString());
          }
          break;

        case "EventUpdated":
          try {
            // final event = FCMEvent.fromJson(message.data);
            // navigatorKey.currentState!.push(
            // MaterialPageRoute(
            //   builder: (context) => SingleEventQueryWrapper(
            //     eventId: event.id,
            //   ),
            // ),
            // );
          } catch (e) {
            showErrorToast(
              "We could not redirect you to the relevant event",
            );
            print("onMessageOpenedApp error");
            print(e.toString());
          }
          break;
        default:
      }
    });

    // For handling notification when the app is terminated
    //   RemoteMessage? initialMessage =
    //       await FirebaseMessaging.instance.getInitialMessage();
    //   if (initialMessage != null) {

    //   }
  }
}
