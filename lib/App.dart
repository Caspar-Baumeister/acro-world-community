// ignore_for_file: file_names

import 'package:acroworld/components/wrapper/connection_wrapper.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/provider/activity_provider.dart';
import 'package:acroworld/provider/all_other_coms.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class App extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const App({Key? key, required this.client}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => AllOtherComs()),
          ChangeNotifierProvider(create: (_) => PlaceProvider()),
          ChangeNotifierProvider(create: (_) => EventFilterProvider()),
          ChangeNotifierProvider(create: (_) => EventBusProvider()),
          ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ],
        child: GraphQLProvider(
          client: client,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: MyThemes.lightTheme,
            home: const ConnectionWrapper(),
          ),
        ));
  }
}
