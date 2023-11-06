const bool isProduction = bool.fromEnvironment('dart.vm.product');

class AppEnvironment {
  // static const bool isProdBuild = isProduction;
  static const bool isProdBuild = true;
  static const String backendHost =
      AppEnvironment.isProdBuild ? "bro-devs.com" : "dev.acroworld.de";
  static const String dashboardUrl = AppEnvironment.isProdBuild
      ? "https://teacher.acroworld.de"
      : "https://admin-dev.acroworld.de";
}


// falls Caspar hier mal wieder dran rum gespielt hat ist hier das original:
// isProduction ? "bro-devs.com" : "dev.acroworld.de";