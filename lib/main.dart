import 'package:acroworld/App.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/firebase_options.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/preferences/place_preferences.dart';
import 'package:acroworld/provider/auth/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
  if (kIsWeb) {
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured for web - '
      'you can reconfigure this by running the FlutterFire CLI again.',
    );
  }
  await Firebase.initializeApp(
    name: "acroworld",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");
  // STRIPE //
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;

// set stripe account
  Stripe.merchantIdentifier = 'merchant.de.acroworld';
  Stripe.urlScheme = 'acroworld';

  await Stripe.instance.applySettings();

  // Sentry //

  if (AppEnvironment.isProdBuild) {
    await SentryFlutter.init(
      (options) {
        options.dsn = AppEnvironment.sentryDsn;
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 0.01;
      },
      appRunner: () => runApp(App(client: client)),
    );
  } else {
    runApp(App(client: client));
  }

  // try {
  //   int? a;
  //   a! + 1;
  // } catch (exception, stackTrace) {
  //   await Sentry.captureException(
  //     exception,
  //     stackTrace: stackTrace,
  //   );
  // }
}
