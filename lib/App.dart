// ignore_for_file: file_names

import 'package:acroworld/data/repositories/invitation_repository.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/main.dart';
import 'package:acroworld/presentation/components/wrapper/auth_wrapper.dart';
import 'package:acroworld/provider/calendar_provider.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/provider/discover_provider.dart';
import 'package:acroworld/provider/event_answers_provider.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/provider/map_events_provider.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/provider/teacher_event_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/state/provider/creator_bookings_provider.dart';
import 'package:acroworld/state/provider/invites_provider.dart';
import 'package:acroworld/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // final NotificationService notificationService = NotificationService();

  // @override
  // void initState() {
  //   super.initState();
  //   // add listeners to the notification service to handle notifications with context
  //   notificationService.addListeners(context);
  // }

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
        ChangeNotifierProvider(create: (_) => TeacherEventsProvider()),
        ChangeNotifierProvider(create: (_) => CreatorBookingsProvider()),
        ChangeNotifierProvider(
            create: (_) => EventCreationAndEditingProvider()),
        ChangeNotifierProvider(create: (_) => CreatorProvider()),
        ChangeNotifierProvider(create: (_) => UserRoleProvider()),
        ChangeNotifierProvider(create: (_) => EventAnswerProvider()),
        ChangeNotifierProvider(
            create: (_) => InvitesProvider(
                invitationRepository: InvitationRepository(
                    apiService: GraphQLClientSingleton()))),
      ],
      child: ValueListenableBuilder<GraphQLClient>(
        valueListenable: GraphQLClientSingleton().clientNotifier,
        builder: (context, client, child) {
          return GraphQLProvider(
            client: GraphQLClientSingleton().clientNotifier,
            child: MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: MyThemes.lightTheme,
              home: const AuthWrapper(),
            ),
          );
        },
      ),
    );
  }
}
