const bool isProduction = bool.fromEnvironment('dart.vm.product');

class AppEnvironment {
  static const String backendHost =
      isProduction ? "bro-devs.com" : "dev.acroworld.de";
  static const String dashboardUrl = isProduction
      ? "https://teacher.acroworld.de"
      : "https://admin-dev.acroworld.de";
}


// falls Caspar hier mal wieder dran rum gespielt hat ist hier das original:
// isProduction ? "bro-devs.com" : ""dev.acroworld.de"; 