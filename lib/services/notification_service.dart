import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Here we decide the type of the event and call the respective handler
      print("onMessage.data");
      print(message.data);
      Fluttertoast.showToast(
          msg: "onMessage ${message.data}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      // var eventType = message.data['event_type'];
      // switch (eventType) {
      //   case 'EventCreated':

      //     break;
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Fluttertoast.showToast(
          msg: "onMessageOpenedApp ${message.data}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      print("onMessageOpenedApp.data");
      print(message.data);
      //... handle notification tap when in background
    });

    // For handling notification when the app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      Fluttertoast.showToast(
          msg: "initialMessage ${initialMessage.data}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      print("initialMessage.data");
      print(initialMessage.data);
      // print('Message clicked when app was terminated: ${initialMessage.notification.body}');
    }
  }
  //... other initialization code

  //... other event handlers
}
