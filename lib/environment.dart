import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;

const bool isProduction = bool.fromEnvironment('dart.vm.product');

class AppEnvironment {
  static const bool isProdBuild = isProduction;
  static const String backendHost =
      isProduction ? "bro-devs.com" : "dev.acroworld.de";
  static const String dashboardUrl = isProduction
      ? "https://teacher.acroworld.de"
      : "https://admin-dev.acroworld.de";

  static const String sentryDsn =
      'https://fb76faf08aa435a6de1ffb468aff6136@o4506325948366848.ingest.sentry.io/4506325953937408';

  static String stripePublishableKey = isProduction
      ? dot_env.dotenv.env['STRIPE_PUBLISHABLE_LIVE_KEY']!
      : dot_env.dotenv.env['STRIPE_PUBLISHABLE_TEST_KEY']!;
}


// falls Caspar hier mal wieder dran rum gespielt hat ist hier das original:
// isProduction ? "bro-devs.com" : "dev.acroworld.de";