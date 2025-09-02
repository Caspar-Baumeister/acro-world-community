import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/provider/riverpod_provider/activity_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityNotifier', () {
    late ActivityNotifier notifier;

    setUp(() {
      notifier = ActivityNotifier.test();
    });

    test('initial state should have default values', () {
      expect(notifier.state.loading, true);
      expect(notifier.state.activeClassEvents, isEmpty);
      expect(notifier.state.activeDay, isA<DateTime>());
    });

    test('setActiveClasses should update activeClassEvents', () {
      final mockEvents = [
        ClassEvent(
          id: '1',
          startDate: DateTime.now().toIso8601String(),
          endDate: DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
        ),
        ClassEvent(
          id: '2',
          startDate: DateTime.now().toIso8601String(),
          endDate: DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
        ),
      ];

      notifier.setActiveClasses(mockEvents);

      expect(notifier.state.activeClassEvents, mockEvents);
      expect(notifier.state.loading, true); // Should remain unchanged
    });

    test('setLoading should update loading state', () {
      notifier.setLoading(false);

      expect(notifier.state.loading, false);
      expect(notifier.state.activeClassEvents, isEmpty); // Should remain unchanged
    });

    test('setActiveDay should update activeDay', () {
      final newDay = DateTime(2024, 1, 15);
      notifier.setActiveDay(newDay);

      expect(notifier.state.activeDay, newDay);
      expect(notifier.state.loading, true); // Should remain unchanged
    });

    test('multiple state changes should work correctly', () {
      final mockEvents = [
        ClassEvent(
          id: '1',
          startDate: DateTime.now().toIso8601String(),
          endDate: DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
        ),
      ];
      final newDay = DateTime(2024, 1, 15);

      notifier.setActiveClasses(mockEvents);
      notifier.setLoading(false);
      notifier.setActiveDay(newDay);

      expect(notifier.state.activeClassEvents, mockEvents);
      expect(notifier.state.loading, false);
      expect(notifier.state.activeDay, newDay);
    });
  });
}
