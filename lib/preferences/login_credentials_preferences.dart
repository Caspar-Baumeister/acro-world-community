// import 'package:shared_preferences/shared_preferences.dart';

// class CredentialPreferences {
//   static SharedPreferences? _preferences;

//   static const _keyPassword = 'password';
//   static const _keyEmail = 'email';

//   static Future init() async =>
//       _preferences = await SharedPreferences.getInstance();

// // EMAIL
//   static Future setEmail(String email) async {
//     if (_preferences != null) await _preferences!.setString(_keyEmail, email);
//   }

//   static String? getEmail() => _preferences!.getString(_keyEmail);

//   static removeEmail() async {
//     if (_preferences != null) _preferences!.remove(_keyEmail);
//   }

// // PASSWORD
//   static Future setPassword(String password) async {
//     if (_preferences != null) {
//       await _preferences!.setString(_keyPassword, password);
//     }
//   }

//   static String? getPassword() => _preferences!.getString(_keyPassword);

//   static removePassword() async {
//     if (_preferences != null) _preferences!.remove(_keyPassword);
//   }
// }
