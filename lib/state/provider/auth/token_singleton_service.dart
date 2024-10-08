import 'package:acroworld/data/graphql/no_token_apis.dart';
import 'package:acroworld/data/types_and_extensions/preferences_extension.dart';
import 'package:acroworld/services/local_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    bool isTokenExpired = await _isTokenExpired();
    if (_token == null || isTokenExpired) {
      print("token was null run fetch token");
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
        print("refetch token was null in fetchtoken");
        return null;
      }
      print("refetch token was not null in fetchtoken");
      // if there is a refresh token, fetch a new token from the backend
      dynamic response =
          await DatabaseService().loginWithRefreshToken(refreshToken);
      if (response["data"]?["loginWithRefreshToken_v2"]?["token"] != null) {
        String token = response["data"]["loginWithRefreshToken_v2"]["token"];
        final userCredential =
            await FirebaseAuth.instance.signInWithCustomToken(token);
        _token = await userCredential.user?.getIdToken();
        await LocalStorageService.set(Preferences.token, _token);

        // if there is a new refresh token, save it in shared preferences
        if (response["data"]?["loginWithRefreshToken_v2"]?["refreshToken"] !=
            null) {
          refreshToken =
              response["data"]["loginWithRefreshToken_v2"]["refreshToken"];
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
    if (response["data"]?["login_v2"]?["token"] != null) {
      print("new token received");
      String token = response["data"]["login_v2"]["token"];
      print(token);
      final userCredential =
          await FirebaseAuth.instance.signInWithCustomToken(token);
      _token = await userCredential.user?.getIdToken();
      // print(_token);
      await LocalStorageService.set(Preferences.token, _token);

      // if there is a new refresh token, save it in shared preferences
      if (response["data"]?["login_v2"]?["refreshToken"] != null) {
        print("new refreshtoken received");
        String refreshToken = response["data"]["login_v2"]["refreshToken"];
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
  Future<Map> register(String email, String password, String name,
      {bool? isNewsletterEnabled}) async {
    var response = await DatabaseService().registerApi(email, password, name,
        isNewsletterEnabled: isNewsletterEnabled);
    if (response["data"]?["register_v2"]?["token"] != null) {
      String token = response["data"]["register_v2"]["token"];
      final userCredential =
          await FirebaseAuth.instance.signInWithCustomToken(token);
      _token = await userCredential.user?.getIdToken();
      await LocalStorageService.set(Preferences.token, _token);

      // if there is a new refresh token, save it in shared preferences
      if (response["data"]?["register_v2"]?["refreshToken"] != null) {
        String refreshToken = response["data"]["register_v2"]["refreshToken"];
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

    print("this is the refetch token after logout");
    print(await LocalStorageService.get(Preferences.refreshToken));
  }
}
