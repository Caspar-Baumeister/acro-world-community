const bool isProduction = String.fromEnvironment('app.flavor') != 'dev';

class AppEnvironment {
  static const bool enableSentry = isProduction;
  static const bool isProdBuild = isProduction;
  static const String backendHost =
      isProduction ? "bro-devs.com" : "dev.acroworld.de";

  static const String websiteUrl =
      isProduction ? "https://acroworld.net" : "https://dev.acroworld.de";

  static const String sentryDsn =
      'https://fb76faf08aa435a6de1ffb468aff6136@o4506325948366848.ingest.sentry.io/4506325953937408';

  static String stripePublishableKey =
      isProduction ? stripeLivePublishableKey : stripeTestPublishableKey;

  static String stripeLivePublishableKey =
      "pk_live_51O3GqCKwmxSCW9DtYK0YflQyi30q4q0KkzboHwaPJ4N3YXsxZ9mE9tlreE3cr6eTWPf1OjH95BvyRnsa3c8NlNzI00vW4e2xap";
  static String stripeTestPublishableKey =
      "pk_test_51O3GqCKwmxSCW9DthK2a7OK4oT642myOk2KiiBIk8uqNturYtGiJ4Nz2IqPF67SpjESquJRjZ7I8Vyfkdzu4Knbx00lyD9wCVl";

  static double commissionPercentage = 2.5;
  static double commissionFixedFee = 0.2;
}
