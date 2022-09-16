const bool isProduction = bool.fromEnvironment('dart.vm.product');

class AppEnvironment {
  static const String backendHost =
      isProduction ? "bro-devs.com" : "dev.bro-devs.com";
}

// class AppEnvironment {
//   static const String backendHost = "bro-devs.com";
// }
