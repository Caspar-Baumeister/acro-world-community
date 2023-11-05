import 'package:acroworld/App.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/firebase_options.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/preferences/place_preferences.dart';
import 'package:acroworld/provider/auth/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  // We're using HiveStore for persistence,
  // so we need to initialize Hive.
  await initHiveForFlutter();
  await CredentialPreferences.init();
  await PlacePreferences.init();

  final HttpLink httpLink = HttpLink(
    'https://${AppEnvironment.backendHost}/hasura/v1/graphql',
  );

  final WebSocketLink websocketLink = WebSocketLink(
    'wss://${AppEnvironment.backendHost}/hasura/v1/graphql',
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: const Duration(seconds: 30),
      initialPayload: () async {
        String? token = await AuthProvider.fetchToken();
        return {
          'headers': token == null || token == ""
              ? {}
              : {'Authorization': 'Bearer $token'}
        };
      },
    ),
  );

  final AuthLink authLink = AuthLink(
    getToken: () async {
      String? token = await AuthProvider.fetchToken();

      return token != null ? 'Bearer $token' : null;
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

  // FIREBASE //
  String? name;
  if (kIsWeb) {
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured for web - '
      'you can reconfigure this by running the FlutterFire CLI again.',
    );
  } else {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        name = AppEnvironment.isProdBuild ? "acroworld" : null;
        break;
      case TargetPlatform.iOS:
        name = "acroworld";
        break;
      default:
        name = "acroworld";
    }
  }
  await Firebase.initializeApp(
    name: name,
    options: DefaultFirebaseOptions.currentPlatform,
  );

  return runApp(App(client: client));
}
