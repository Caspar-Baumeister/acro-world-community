import 'package:acroworld/provider/riverpod_provider/event_filter_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EventFilterProvider Tests', () {
    test('EventFilterState should initialize with default values', () {
      const state = EventFilterState();

      expect(state.eventPoster, isEmpty);
      expect(state.initialEvents, isEmpty);
      expect(state.activeEvents, isEmpty);
      expect(state.initialCategories, isEmpty);
      expect(state.initialCountries, isEmpty);
      expect(state.initialDates, isEmpty);
      expect(state.activeCategories, isEmpty);
      expect(state.activeCountries, isEmpty);
      expect(state.activeDates, isEmpty);
      expect(state.onlyHighlighted, false);
      expect(state.followedTeachers, isEmpty);
      expect(state.initialized, false);
    });

    test('EventFilterState should calculate active filter count correctly', () {
      const state = EventFilterState();
      expect(state.getActiveFilterCount(), 0);

      final stateWithFilters = state.copyWith(
        activeCategories: ['Workshop'],
        activeCountries: ['Germany'],
        onlyHighlighted: true,
      );
      expect(stateWithFilters.getActiveFilterCount(), 3);
    });

    test('EventFilterState should detect if filter is active', () {
      const state = EventFilterState();
      expect(state.isFilterActive(), false);

      final stateWithFilters = state.copyWith(
        activeCategories: ['Workshop'],
      );
      expect(stateWithFilters.isFilterActive(), true);
    });

    test('EventFilterNotifier should initialize with default state', () {
      final notifier = EventFilterNotifier();
      expect(notifier.state.initialized, false);
      expect(notifier.state.activeEvents, isEmpty);
    });

    test('EventFilterNotifier should set initial data', () {
      final notifier = EventFilterNotifier();
      final mockEvents = [
        {
          'id': '1',
          'name': 'Test Event',
          'start_date': '2024-01-01',
          'end_date': '2024-01-02',
          'event_type': 'Workshop',
          'location_country': 'Germany',
          'is_highlighted': false,
        }
      ];

      notifier.setInitialData(mockEvents);

      expect(notifier.state.initialized, true);
      expect(notifier.state.initialEvents.length, 1);
      expect(notifier.state.activeEvents.length, 1);
      expect(notifier.state.initialCategories, contains('Workshop'));
      expect(notifier.state.initialCountries, contains('Germany'));
    });

    test('EventFilterNotifier should change active category', () {
      final notifier = EventFilterNotifier();

      notifier.changeActiveCategory('Workshop');
      expect(notifier.state.activeCategories, contains('Workshop'));

      notifier.changeActiveCategory('Workshop'); // Remove it
      expect(notifier.state.activeCategories, isEmpty);
    });

    test('EventFilterNotifier should change highlighted filter', () {
      final notifier = EventFilterNotifier();

      expect(notifier.state.onlyHighlighted, false);

      notifier.changeHighlighted();
      expect(notifier.state.onlyHighlighted, true);

      notifier.changeHighlighted();
      expect(notifier.state.onlyHighlighted, false);
    });

    test('EventFilterNotifier should reset filter', () {
      final notifier = EventFilterNotifier();

      // Set some filters
      notifier.changeActiveCategory('Workshop');
      notifier.changeHighlighted();

      expect(notifier.state.activeCategories, isNotEmpty);
      expect(notifier.state.onlyHighlighted, true);

      // Reset
      final result = notifier.resetFilter();

      expect(result, true);
      expect(notifier.state.activeCategories, isEmpty);
      expect(notifier.state.onlyHighlighted, false);
    });
  });
}
