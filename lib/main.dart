import 'package:acroworld/firebase_options.dart';
import 'package:acroworld/provider/auth/auth_provider.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/loggin_wrapper.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/all_other_coms.dart';
import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
        String? token = await AuthProvider.fetchToken();
        return {
          'headers': {'Authorization': 'Bearer $token'}
        };
      },
    ),
  );

  final AuthLink authLink = AuthLink(
    getToken: () async {
      String? token = await AuthProvider.fetchToken();
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

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
          ChangeNotifierProvider(create: (_) => UserCommunitiesProvider()),
          ChangeNotifierProvider(create: (_) => AllOtherComs()),
          ChangeNotifierProvider(create: (_) => EventBusProvider()),
        ],
        child: GraphQLProvider(
          client: client,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
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
