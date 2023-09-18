const bool isProduction = bool.fromEnvironment('dart.vm.product');

class AppEnvironment {
  static const String backendHost =
      isProduction ? "bro-devs.com" : "dev.acroworld.de";
}


// falls Caspar hier mal wieder dran rum gespielt hat ist hier das original:
// isProduction ? "bro-devs.com" : "dev.bro-devs.com"; 