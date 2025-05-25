import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/fcm_service.dart'; // your NotificationService
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationInitializer extends ConsumerStatefulWidget {
  final Widget child;
  const NotificationInitializer({required this.child, super.key});

  @override
  ConsumerState<NotificationInitializer> createState() =>
      _NotificationInitializerState();
}

class _NotificationInitializerState
    extends ConsumerState<NotificationInitializer> {
  bool _hasListener = false;
  bool _hasInited = false;

  @override
  Widget build(BuildContext context) {
    // Register the listener exactly once
    if (!_hasListener) {
      ref.listen<AsyncValue<User?>>(
        userNotifierProvider, // or userRiverpodProvider
        (prev, next) {
          next.whenData((user) async {
            if (user != null && !_hasInited) {
              // we just got a logged‐in user
              final service = NotificationService(
                GraphQLClientSingleton().client,
              );
              if (user.id == null) {
                // user has no ID, can't init
                return;
              }
              await service.init(user.id!);
              _hasInited = true;
            } else if (user == null && _hasInited) {
              // user signed out → reset so we can re‐init on next sign in
              _hasInited = false;
            }
          });
        },
      );
      _hasListener = true;
    }

    return widget.child;
  }
}
