const bool isProduction = bool.fromEnvironment('dart.vm.product');

class AppEnvironment {
  static const String backendHost =
      isProduction ? "bro-devs.com" : "bro-devs.com"; // "dev.bro-devs.com";
}
