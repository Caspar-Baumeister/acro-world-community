import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:acroworld/services/local_storage_service.dart';
import 'package:acroworld/types_and_extensions/preferences_extension.dart';
import 'package:jwt_decode/jwt_decode.dart';

class TokenSingletonService {
  static final TokenSingletonService _instance =
      TokenSingletonService._internal();
  String? _token;

  factory TokenSingletonService() {
    return _instance;
  }

  TokenSingletonService._internal();

  Future<bool> _isTokenExpired() async {
    if (_token == null) {
      _token = await LocalStorageService.get(Preferences.token);
      if (_token == null) {
        return true;
      }
    }
    if (Jwt.isExpired(_token!)) {
      return true;
    }
    return false;
  }

  Future<String?> getToken() async {
    if (_token == null || await _isTokenExpired()) {
      await _fetchToken();
    }
    return _token;
  }

  Future<String?> _fetchToken() async {
    if (await _isTokenExpired()) {
      // check if there is a refresh token in shared preferences
      String? refreshToken =
          await LocalStorageService.get(Preferences.refreshToken);
      // if there is no refresh token, return null
      if (refreshToken == null) {
        return null;
      }
      // if there is a refresh token, fetch a new token from the backend
      dynamic response =
          await DatabaseService().loginWithRefreshToken(refreshToken);
      if (response["data"]?["loginWithRefreshToken"]?["token"] != null) {
        _token = response["data"]["loginWithRefreshToken"]["token"];
        await LocalStorageService.set(Preferences.token, _token);

        // if there is a new refresh token, save it in shared preferences
        if (response["data"]?["loginWithRefreshToken"]?["refreshToken"] !=
            null) {
          refreshToken =
              response["data"]["loginWithRefreshToken"]["refreshToken"];
          await LocalStorageService.set(Preferences.refreshToken, refreshToken);
        }

        return _token;
      } else {
        return null;
      }
    }
    return _token;
  }

  // LOGIN //
  Future<Map> login(String email, String password) async {
    var response = await DatabaseService().loginApi(email, password);
    if (response["data"]?["login"]?["token"] != null) {
      print("new token received");
      _token = response["data"]["login"]["token"];
      await LocalStorageService.set(Preferences.token, _token);

      // if there is a new refresh token, save it in shared preferences
      if (response["data"]?["login"]?["refreshToken"] != null) {
        print("new refreshtoken received");
        String refreshToken = response["data"]["login"]["refreshToken"];
        await LocalStorageService.set(Preferences.refreshToken, refreshToken);
      }
      // add error : false to response to indicate that there is no error
      response["error"] = false;
      return response;
    }
    // add error : true to response to indicate that there is an error
    response["error"] = true;
    return response;
  }

  // REGISTER //
  Future<Map> register(String email, String password, String name) async {
    var response = await DatabaseService().registerApi(email, password, name);
    if (response["data"]?["register"]?["token"] != null) {
      _token = response["data"]["register"]["token"];
      await LocalStorageService.set(Preferences.token, _token);

      // if there is a new refresh token, save it in shared preferences
      if (response["data"]?["register"]?["refreshToken"] != null) {
        String refreshToken = response["data"]["register"]["refreshToken"];
        await LocalStorageService.set(Preferences.refreshToken, refreshToken);
      }
      // add error : false to response to indicate that there is no error
      response["error"] = false;
      return response;
    }
    // add error : true to response to indicate that there is an error
    response["error"] = true;
    return response;
  }

  // LOGOUT //
  Future<void> logout() async {
    _token = null;
    await LocalStorageService.remove(Preferences.token);
    await LocalStorageService.remove(Preferences.refreshToken);
  }
}
