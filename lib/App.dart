// ignore_for_file: file_names

import 'package:acroworld/core/utils/theme.dart';
import 'package:acroworld/main.dart';
import 'package:acroworld/presentation/shared_components/wrapper/auth_wrapper.dart';
import 'package:acroworld/services/fb_notification_service.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/state/events/event_bus_provider.dart';
import 'package:acroworld/state/provider/calendar_provider.dart';
import 'package:acroworld/state/provider/discover_provider.dart';
import 'package:acroworld/state/provider/event_filter_provider.dart';
import 'package:acroworld/state/provider/map_events_provider.dart';
import 'package:acroworld/state/provider/place_provider.dart';
import 'package:acroworld/state/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

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
    print('App:build');
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => EventFilterProvider()),
          ChangeNotifierProvider(create: (_) => EventBusProvider()),
          ChangeNotifierProvider(create: (_) => CalendarProvider()),
          ChangeNotifierProvider(create: (_) => MapEventsProvider()),
          ChangeNotifierProvider(create: (_) => DiscoveryProvider()),
          ChangeNotifierProvider(create: (_) => PlaceProvider()),
        ],
        child: GraphQLProvider(
          client: ValueNotifier(GraphQLClientSingleton().client),
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: MyThemes.lightTheme,
            home: const AuthWrapper(),
          ),
        ));
  }
}
