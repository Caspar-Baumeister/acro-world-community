// ignore_for_file: file_names

import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/router_app.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    CustomErrorHandler.logDebug('App:build');

    return ProviderScope(
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
