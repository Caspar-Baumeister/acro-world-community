import 'package:acroworld/exceptions/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRoleNotifier extends StateNotifier<bool> {
  UserRoleNotifier() : super(false);

  void setIsCreator(bool isCreator) {
    CustomErrorHandler.logDebug(
        'UserRoleNotifier: Setting isCreator to $isCreator');
    state = isCreator;
  }

  bool get isCreator => state;
}

final userRoleProvider = StateNotifierProvider<UserRoleNotifier, bool>((ref) {
  return UserRoleNotifier();
});
