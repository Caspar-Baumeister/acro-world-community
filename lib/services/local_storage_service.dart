import 'package:acroworld/types_and_extensions/preferences_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static SharedPreferences? _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future<bool> set(Preferences preferenceKey, value) async {
    if (_preferences != null) {
      switch (preferenceKey.getType) {
        case (int):
          return await _preferences!.setInt(preferenceKey.toString(), value);
        case (double):
          return await _preferences!.setDouble(preferenceKey.toString(), value);
        case (bool):
          return await _preferences!.setBool(preferenceKey.toString(), value);
        case (String):
          return await _preferences!.setString(preferenceKey.toString(), value);
        default:
          print('default called: $preferenceKey');
          return Future(() => false);
      }
    } else {
      return Future(() => false);
    }
  }

  static dynamic get(
    Preferences preference,
  ) {
    if (_preferences != null &&
        _preferences!.containsKey(preference.toString())) {
      switch (preference.getType) {
        case (int):
          return _preferences!.getInt(preference.toString());
        case (double):
          return _preferences!.getDouble(preference.toString());
        case (bool):
          return _preferences!.getBool(preference.toString()) ?? false;
        case (String):
          return _preferences!.getString(preference.toString());
        default:
          return _preferences!.get(preference.toString());
      }
    } else {
      return null;
    }
  }

  static Future<bool> remove(Preferences preference) async {
    if (_preferences != null &&
        _preferences!.containsKey(preference.toString())) {
      return await _preferences!.remove(preference.toString());
    }
    return Future(() => false);
  }

  static void deleteLocalStorage() {
    List<Preferences> keys = Preferences.values.map((e) => e).toList();
    for (Preferences key in keys) {
      // if (key != Preferences.isFirstUsage &&
      //     key != Preferences.loginEmail &&
      //     key != Preferences.loginPassword) {
      remove(key);
      // }
    }
  }
}
