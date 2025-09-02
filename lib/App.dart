// ignore_for_file: file_names

import 'package:acroworld/data/repositories/invitation_repository.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/provider/event_answers_provider.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/map_events_provider.dart';
import 'package:acroworld/router_app.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/state/provider/creator_bookings_provider.dart';
import 'package:acroworld/state/provider/invites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart' as provider;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    CustomErrorHandler.logDebug('App:build');

    return ProviderScope(
      child: provider.MultiProvider(
        providers: [
          // Keep only the providers that haven't been migrated to Riverpod yet
          provider.ChangeNotifierProvider(create: (_) => EventBusProvider()),
          provider.ChangeNotifierProvider(create: (_) => MapEventsProvider()),
          provider.ChangeNotifierProvider(create: (_) => CreatorBookingsProvider()),
          provider.ChangeNotifierProvider(
              create: (_) => EventCreationAndEditingProvider()),
          provider.ChangeNotifierProvider(create: (_) => CreatorProvider()),
          provider.ChangeNotifierProvider(create: (_) => EventAnswerProvider()),
          provider.ChangeNotifierProvider(
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
      ),
    );
  }
}
