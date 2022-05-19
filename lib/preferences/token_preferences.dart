import 'package:shared_preferences/shared_preferences.dart';

class TokenPreferences {
  static SharedPreferences? _preferences;

  static const _keyToken = 'token';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setToken(String token) async {
    if (_preferences != null) await _preferences!.setString(_keyToken, token);
  }

  static String getToken() => _preferences!.getString(_keyToken) ?? "";

  static removeToken() async {
    if (_preferences != null) _preferences!.remove(_keyToken);
  }
}
