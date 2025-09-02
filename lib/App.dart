// ignore_for_file: file_names

import 'package:acroworld/data/repositories/invitation_repository.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/provider/calendar_provider.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/provider/discover_provider.dart';
import 'package:acroworld/provider/event_answers_provider.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/map_events_provider.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/provider/teacher_event_provider.dart';

import 'package:acroworld/router_app.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/state/provider/creator_bookings_provider.dart';
import 'package:acroworld/state/provider/invites_provider.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    CustomErrorHandler.logDebug('App:build');

    return MultiProvider(
      providers: [
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
            child: RouterApp(),
          );
        },
      ),
    );
  }
}
