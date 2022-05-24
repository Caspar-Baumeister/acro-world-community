import 'package:acroworld/auth/auth_provider.dart';
import 'package:acroworld/loggin_wrapper.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  // We're using HiveStore for persistence,
  // so we need to initialize Hive.
  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink(
    'https://bro-devs.com/hasura/v1/graphql',
  );

  final WebSocketLink websocketLink = WebSocketLink(
    'wss://bro-devs.com/hasura/v1/graphql',
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: const Duration(seconds: 30),
      initialPayload: () async {
        print('initialPayload');
        String token = await AuthProvider.fetchToken();
        return {'Authorization': 'Bearer $token'};
      },
    ),
  );

  final AuthLink authLink = AuthLink(
    getToken: () async {
      String token = await AuthProvider.fetchToken();
      print(token);
      return 'Bearer $token';
    },
  );

  final Link concatLink = authLink.concat(httpLink);

  final Link link = Link.split(
      (request) => request.isSubscription, websocketLink, concatLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      // The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();

  await CredentialPreferences.init();
  return runApp(App(client: client));
}

class App extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const App({Key? key, required this.client}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: GraphQLProvider(
          client: client,
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            // LoginWrapper checks for token?
            // Also possible: Routerdelegate with auth check and guards
            home: LogginWrapper(),
          ),
        ));
  }
}
