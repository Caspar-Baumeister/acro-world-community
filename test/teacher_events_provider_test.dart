import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_events_provider.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeacherEventsNotifier', () {
    late TeacherEventsNotifier notifier;

    setUp(() {
      notifier = TeacherEventsNotifier.test();
    });

    test('initial state should have default values', () {
      expect(notifier.state.loading, true);
      expect(notifier.state.myCreatedEvents, isEmpty);
      expect(notifier.state.myParticipatingEvents, isEmpty);
      expect(notifier.state.isLoadingMyEvents, false);
      expect(notifier.state.isLoadingParticipatingEvents, false);
      expect(notifier.state.isInitialized, false);
      expect(notifier.state.canFetchMoreMyEvents, true);
      expect(notifier.state.canFetchMoreParticipatingEvents, true);
    });

    test('cleanUp should reset state to initial values', () {
      // First modify the state
      notifier.state = notifier.state.copyWith(
        loading: false,
        isInitialized: true,
        myCreatedEvents: [
          ClassModel(
            id: '1',
            name: 'Test Class',
            description: 'Test Description',
            eventType: EventType.Workshops,
            country: 'Germany',
            city: 'Berlin',
            questions: [],
          ),
        ],
      );

      // Then clean up
      notifier.cleanUp();

      expect(notifier.state.loading, true);
      expect(notifier.state.myCreatedEvents, isEmpty);
      expect(notifier.state.isInitialized, false);
    });

    test('state copyWith should work correctly', () {
      final newState = notifier.state.copyWith(
        loading: false,
        isInitialized: true,
      );

      expect(newState.loading, false);
      expect(newState.isInitialized, true);
      expect(newState.myCreatedEvents, isEmpty); // Should remain unchanged
    });
  });
}
