import 'package:acroworld/App.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/preferences/place_preferences.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/version_to_old_page.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/local_storage_service.dart';
import 'package:acroworld/services/version_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  // Sentry //
  if (AppEnvironment.enableSentry) {
    await SentryFlutter.init(
      (options) {
        options.dsn = AppEnvironment.sentryDsn;
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 0.01;
      },
      appRunner: () {
        return initMain();
      },
    );
  } else {
    initMain();
  }
}

initMain() async {
  // We're using HiveStore for persistence,
  // so we need to initialize Hive.
  await initHiveForFlutter();
  await LocalStorageService.init();
  await PlacePreferences.init();

  // Initialize the GraphQL client in the client singleton
  final graphQLClientSingleton = GraphQLClientSingleton().client;

  WidgetsFlutterBinding.ensureInitialized();

  try {
    // FIREBASE //
    await Firebase.initializeApp(
        // name: "acroworld",
        // options: DefaultFirebaseOptions.currentPlatform,
        );

    FirebaseOptions options = Firebase.app().options;
    String projectId = options.projectId;

    print('Firebase Project ID: $projectId');

    tz.initializeTimeZones();

    // FIREBASE MESSAGING //
    // initialize the firebase messaging service
    // NotificationService notificationService = NotificationService();
    // await notificationService.initialize();
    // notificationService.getToken();

    // STRIPE //
    Stripe.publishableKey = AppEnvironment.stripePublishableKey;
    Stripe.merchantIdentifier = 'merchant.de.acroworld';
    Stripe.urlScheme = 'acroworld';
    await Stripe.instance.applySettings();
  } catch (exception, stackTrace) {
    CustomErrorHandler.captureException(exception, stackTrace: stackTrace);
  }

  // VERSION CHECK //
  String minVersion =
      await VersionService.getVersionInfo(graphQLClientSingleton);
  if (minVersion == 'Error') {
    // TODO if there is an error, send the User to the error page
    minVersion = '0.0.0';
    CustomErrorHandler.captureException(
        "error in receiving version info from backend");
  }
  String currentVersion = await VersionService.getCurrentAppVersion();
  bool isValid = VersionService.verifyVersionString(
      currentVersion: currentVersion, minVersion: minVersion);

  runApp(isValid
      ? const App()
      : VersionToOldPage(
          currentVersion: currentVersion, minVersion: minVersion));
}
