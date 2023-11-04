import 'package:acroworld/App.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/firebase_options.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/preferences/place_preferences.dart';
import 'package:acroworld/provider/auth/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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
  await Firebase.initializeApp(
    // if the current platform is android, use no name, otherwise use acroworld
    name: "acroworld",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // STRIPE //
  Stripe.publishableKey =
      "pk_test_51O3GqCKwmxSCW9DthK2a7OK4oT642myOk2KiiBIk8uqNturYtGiJ4Nz2IqPF67SpjESquJRjZ7I8Vyfkdzu4Knbx00lyD9wCVl";

// set stripe account
  Stripe.merchantIdentifier = 'merchant.de.acroworld';
  Stripe.urlScheme = 'acroworld';

  await Stripe.instance.applySettings();

  return runApp(App(client: client));
}
