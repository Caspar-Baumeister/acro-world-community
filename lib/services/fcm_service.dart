import 'package:acroworld/data/graphql/mutations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final GraphQLClient _gqlClient;

  NotificationService(this._gqlClient);

  /// Call this once, after Firebase.initializeApp() and after the user is authenticated.
  Future<void> init(String userId) async {
    if (kIsWeb) return;

    // 1️⃣ Request permission (iOS)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      print('🔕 Notification permission denied');
      return;
    }
    print('✅ Notification permission granted');

    // 2️⃣ Get current token & sync if needed
    await _syncToken(userId);

    // 3️⃣ Listen for token refreshes
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _saveToken(userId, newToken);
    });
  }

  /// Compare the FCM token vs last-sent. If different, send it up and cache it.
  Future<void> _syncToken(String userId) async {
    final currentToken = await _messaging.getToken();
    print('🔑 Current FCM token: $currentToken');
    if (currentToken == null) return;

    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('fcm_token') ?? '';
    print("Is cached token different? ${currentToken != cached}");
    if (currentToken != cached) {
      if (await _saveToken(userId, currentToken)) {
        await prefs.setString('fcm_token', currentToken);
      }
    }
  }

  /// Sends the token to your backend via a Hasura mutation.
  Future<bool> _saveToken(String userId, String token) async {
    try {
      print('📤 Registering FCM token: $token');
      print('User ID: $userId');
      final res = await _gqlClient.mutate(MutationOptions(
        document: Mutations.updateOrInsertFcmToken,
        variables: {'userId': userId, 'fcmToken': token},
      ));

      if (res.hasException) {
        print('❌ Failed to register FCM token: ${res.exception}');
        return false;
      } else {
        print('✅ FCM token registered: $token');
        return true;
      }
    } catch (e) {
      print('❌ Error occurred while registering FCM token: $e');
      rethrow; // Re-throw to handle it upstream if needed
    }
  }
}
