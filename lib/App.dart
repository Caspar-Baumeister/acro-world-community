import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/components/loggin_wrapper.dart';
import 'package:acroworld/provider/all_other_coms.dart';
import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/constants.dart';
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
          ChangeNotifierProvider(create: (_) => EventBusProvider()),
        ],
        child: GraphQLProvider(
          client: client,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              dividerColor: Colors.grey,
              dividerTheme: const DividerThemeData(color: Colors.grey),
              scaffoldBackgroundColor: Colors.white,
              tabBarTheme: const TabBarTheme(
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: PRIMARY_COLOR,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              textTheme: const TextTheme(
                headline1: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                headline2:
                    TextStyle(fontSize: 22.5, fontWeight: FontWeight.bold),
                headline3: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                headline4:
                    TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                actionsIconTheme: IconThemeData(color: Colors.black),
                centerTitle: true,
                elevation: 0,
                titleTextStyle: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ),
            // LoginWrapper checks for token?
            // Also possible: Routerdelegate with auth check and guards
            home: const LogginWrapper(),
          ),
        ));
  }
}
