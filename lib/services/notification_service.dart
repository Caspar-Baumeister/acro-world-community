import 'package:acroworld/screens/single_event/single_event_query_wrapper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future initialize(BuildContext context) async {
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message.messageType");

      print(message.messageType);
      print("message.data[]");
      print(message.data["type"]);

      switch (message.data["type"]) {
        case "EventCreated":
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
                    "Teacher you follow where added to the ${getReadableEventType(event.eventType!)} ${event.name}",
                    textAlign: TextAlign.center,
                  ),
                ),
                action: SnackBarAction(
                  label: 'View Event',
                  onPressed: () {
                    // Navigate to the EventScreen with the extracted ID
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SingleEventQueryWrapper(
                          eventId: event.id,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } catch (e) {
            Fluttertoast.showToast(
                msg: "We could not redirect you to the relevant event",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SingleEventQueryWrapper(
                          eventId: event.id,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } catch (e) {
            Fluttertoast.showToast(
                msg: "We could not redirect you to the relevant event",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            print("onMessage error");
            print(e.toString());
          }
          break;

        default:
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("message.messageType");
      print(message.messageType);
      print("message.data[]");
      print(message.data["type"]);
      switch (message.data["type"]) {
        case "EventCreated":
          try {
            final event = FCMEvent.fromJson(message.data);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SingleEventQueryWrapper(
                  eventId: event.id,
                ),
              ),
            );
          } catch (e) {
            Fluttertoast.showToast(
                msg: "We could not redirect you to the relevant event",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            print("onMessageOpenedApp error");
            print(e.toString());
          }
          break;

        case "EventUpdated":
          try {
            final event = FCMEvent.fromJson(message.data);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SingleEventQueryWrapper(
                  eventId: event.id,
                ),
              ),
            );
          } catch (e) {
            Fluttertoast.showToast(
                msg: "We could not redirect you to the relevant event",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
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

EventType _mapStringToEventType(String eventTypeString) {
  switch (eventTypeString) {
    case 'FestivalsAndCons':
      return EventType.FestivalsAndCons;
    case 'Retreats':
      return EventType.Retreats;
    case 'Trainings':
      return EventType.Trainings;
    default:
      throw ArgumentError('Invalid event type string: $eventTypeString');
  }
}

class FCMEvent {
  EventType? eventType;
  DateTime? endDate;
  String? locationCountry;
  String? locationCity;
  String name;
  String id;
  String type;
  DateTime? startDate;

  FCMEvent({
    required this.eventType,
    required this.endDate,
    required this.locationCountry,
    required this.locationCity,
    required this.name,
    required this.id,
    required this.type,
    required this.startDate,
  });

  factory FCMEvent.fromJson(Map<String, dynamic> json) {
    return FCMEvent(
      eventType: json['event_type'] != null
          ? _mapStringToEventType(json['event_type'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      locationCountry: json['location_country'],
      locationCity: json['location_city'],
      name: json['name'],
      id: json['id'],
      type: json['type'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_type': eventType,
      'endDate': endDate?.toIso8601String(),
      'location_country': locationCountry,
      'location_city': locationCity,
      'name': name,
      'id': id,
      'type': type,
      'startDate': startDate?.toIso8601String(),
    };
  }
}

enum EventType {
  FestivalsAndCons,
  Retreats,
  Trainings,
}

String getReadableEventType(EventType eventType) {
  switch (eventType) {
    case EventType.FestivalsAndCons:
      return 'festival or convention';
    case EventType.Retreats:
      return 'retreat';
    case EventType.Trainings:
      return 'training';
    default:
      return 'Unknown';
  }
}
