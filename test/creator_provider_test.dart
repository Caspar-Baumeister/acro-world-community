import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/provider/riverpod_provider/creator_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreatorNotifier', () {
    late CreatorNotifier notifier;

    setUp(() {
      notifier = CreatorNotifier.test();
    });

    test('initial state should have default values', () {
      expect(notifier.state.activeTeacher, isNull);
      expect(notifier.state.isLoading, false);
    });

    test('deleteActiveTeacher should set activeTeacher to null', () {
      // First set a teacher
      final mockTeacher = TeacherModel(
        id: 'test-id',
        userId: 'user-id',
        name: 'Test Teacher',
        bio: 'Test Bio',
        profileImageUrl: 'test-url',
        stripeAccountId: 'stripe-id',
        isVerified: true,
        createdAt: '2024-01-01',
        updatedAt: '2024-01-01',
      );
      
      notifier.state = notifier.state.copyWith(activeTeacher: mockTeacher);
      expect(notifier.state.activeTeacher, isNotNull);

      // Then delete it
      notifier.deleteActiveTeacher();
      expect(notifier.state.activeTeacher, isNull);
    });

    test('updateCreator should update activeTeacher', () {
      final mockTeacher = TeacherModel(
        id: 'test-id',
        userId: 'user-id',
        name: 'Test Teacher',
        bio: 'Test Bio',
        profileImageUrl: 'test-url',
        stripeAccountId: 'stripe-id',
        isVerified: true,
        createdAt: '2024-01-01',
        updatedAt: '2024-01-01',
      );

      notifier.updateCreator(mockTeacher);
      expect(notifier.state.activeTeacher, mockTeacher);
    });

    test('state copyWith should work correctly', () {
      final newState = notifier.state.copyWith(isLoading: true);
      expect(newState.isLoading, true);
      expect(newState.activeTeacher, isNull); // Should remain unchanged
    });
  });
}
