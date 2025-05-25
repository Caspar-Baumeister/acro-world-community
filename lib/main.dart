import 'package:acroworld/App.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/firebase_options.dart';
import 'package:acroworld/preferences/place_preferences.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/version_to_old_page.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/local_storage_service.dart';
import 'package:acroworld/services/version_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:url_strategy/url_strategy.dart';

void main() async {
  ////////////
  // Sentry //
  ////////////
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
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  try {
    //////////////
    // FIREBASE //
    //////////////
    const bool isWeb = bool.fromEnvironment('dart.library.js_util');
    if (isWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.initializeApp();
    }
    FirebaseOptions options = Firebase.app().options;
    String projectId = options.projectId;

    print('Firebase Project ID: $projectId');

    ////////////////////////
    // FIREBASE MESSAGING //
    ////////////////////////
    // initialize the firebase messaging service
    // NotificationService notificationService = NotificationService();
    // await notificationService.initialize();
    // notificationService.getToken();

    ////////////
    // STRIPE //
    ////////////
    Stripe.publishableKey = AppEnvironment.stripePublishableKey;
    if (!kIsWeb) Stripe.merchantIdentifier = 'merchant.de.acroworld';
    Stripe.urlScheme = 'acroworld';
    await Stripe.instance.applySettings();
  } catch (exception, stackTrace) {
    CustomErrorHandler.captureException(exception, stackTrace: stackTrace);
  }

  ///////////////////
  // VERSION CHECK //
  ///////////////////
  // Initialize the GraphQL client in the client singleton
  bool isValid = true;
  String currentVersion = '0.0.0';
  String minVersion = '0.0.0';
  if (!kIsWeb) {
    final graphQLClientSingleton = GraphQLClientSingleton().client;
    minVersion = await VersionService.getVersionInfo(graphQLClientSingleton);
    if (minVersion == 'Error') {
      // TODO if there is an error, send the User to the error page
      minVersion = '0.0.0';
      CustomErrorHandler.captureException(
          "error in receiving version info from backend");
    }
    currentVersion = await VersionService.getCurrentAppVersion();
    isValid = VersionService.verifyVersionString(
        currentVersion: currentVersion, minVersion: minVersion);
  }

  if (kIsWeb) {
    setPathUrlStrategy();
  }

  runApp(isValid
      ? ProviderScope(child: const App())
      : VersionToOldPage(
          currentVersion: currentVersion, minVersion: minVersion));
}
