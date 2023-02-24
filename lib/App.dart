import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/components/loggin_wrapper.dart';
import 'package:acroworld/provider/all_other_coms.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/provider/user_communities.dart';
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
          ChangeNotifierProvider(create: (_) => UserCommunitiesProvider()),
          ChangeNotifierProvider(create: (_) => AllOtherComs()),
          ChangeNotifierProvider(create: (_) => PlaceProvider()),
          ChangeNotifierProvider(create: (_) => EventBusProvider()),
        ],
        child: GraphQLProvider(
          client: client,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: MyThemes.lightTheme,
            // TODO version and internet check wrapper (pulls min version, compares, if no result
            // TODO no wifi screen. Otherwise either old version screen or continue)
            // LoginWrapper checks for token?
            // Also possible: Routerdelegate with auth check and guards
            home: const LogginWrapper(),
          ),
        ));
  }
}
