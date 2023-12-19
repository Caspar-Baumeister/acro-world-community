// ignore_for_file: file_names

import 'package:acroworld/components/wrapper/auth_wrapper.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/main.dart';
import 'package:acroworld/provider/activity_provider.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/notification_service.dart';
import 'package:acroworld/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  final ValueNotifier<GraphQLClient> client;

  const App({Key? key, required this.client}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    // add listeners to the notification service to handle notifications with context
    notificationService.addListeners(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => UserProvider(client: widget.client.value)),
          ChangeNotifierProvider(create: (_) => PlaceProvider()),
          ChangeNotifierProvider(create: (_) => EventFilterProvider()),
          ChangeNotifierProvider(create: (_) => EventBusProvider()),
          ChangeNotifierProvider(create: (_) => ActivityProvider()),
          Provider<GraphQlClientService>(
            create: (_) => GraphQlClientService(widget.client.value),
          ),
        ],
        child: GraphQLProvider(
          client: widget.client,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: MyThemes.lightTheme,
            home: const AuthWrapper(),
          ),
        ));
  }
}
