import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthProvider {
  static String? token;

  static bool isTokenExpired() {
    if (token == null) {
      return true;
    }
    final DateTime? expirationDate = Jwt.getExpiryDate(token!)?.toLocal();
    if (expirationDate != null) {
      return expirationDate.difference(DateTime.now()) <
          const Duration(minutes: 1);
    } else {
      return false;
    }
  }

  static Future<String?> fetchToken() async {
    if (isTokenExpired()) {
      String? email = CredentialPreferences.getEmail();
      String? password = CredentialPreferences.getPassword();
      token = await Database().loginApi(email!, password!);
    }
    return token;
  }
}
