// const bool isProduction = bool.fromEnvironment('dart.vm.product');
const bool isProduction = true;

class AppEnvironment {
  static const String backendHost =
      isProduction ? "bro-devs.com" : "dev.bro-devs.com";
}
