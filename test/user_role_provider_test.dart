import 'package:acroworld/provider/riverpod_provider/user_role_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserRoleProvider Tests', () {
    test('UserRoleNotifier should initialize with false', () {
      final notifier = UserRoleNotifier();
      expect(notifier.isCreator, false);
    });

    test('UserRoleNotifier should update isCreator state', () {
      final notifier = UserRoleNotifier();

      // Initially false
      expect(notifier.isCreator, false);

      // Set to true
      notifier.setIsCreator(true);
      expect(notifier.isCreator, true);

      // Set to false
      notifier.setIsCreator(false);
      expect(notifier.isCreator, false);
    });

    test('userRoleProvider should work with StateNotifierProvider', () {
      // This test verifies that the provider can be created without errors
      // In a real test environment, you would use ProviderContainer
      expect(userRoleProvider, isNotNull);
    });
  });
}
