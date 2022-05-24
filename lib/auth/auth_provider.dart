import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/services/database.dart';

class AuthProvider {
  static Future<String> fetchToken() async {
    String? email = CredentialPreferences.getEmail();
    print('Email: $email');
    String? password = CredentialPreferences.getPassword();
    String? token = await Database().loginApi(email!, password!);
    return token!;
  }
}
