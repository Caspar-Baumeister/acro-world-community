import 'package:flutter_test/flutter_test.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';

void main() {
  group('DiscoveryProvider Tests', () {
    test('DiscoveryState should initialize with default values', () {
      const state = DiscoveryState();
      
      expect(state.allEventOccurences, isEmpty);
      expect(state.allDates, isEmpty);
      expect(state.allEventTypes, isEmpty);
      expect(state.allCountries, isEmpty);
      expect(state.allRegionsByCountry, isEmpty);
      expect(state.filteredEventOccurences, isEmpty);
      expect(state.filterCountries, isEmpty);
      expect(state.filterRegions, isEmpty);
      expect(state.filterCategories, isEmpty);
      expect(state.filterDates, isEmpty);
      expect(state.isOnlyBookableFilter, false);
      expect(state.isOnlyHighlightedFilter, false);
      expect(state.isOnlyFollowedTeacherFilter, false);
      expect(state.isOnlyCloseToMeFilter, false);
      expect(state.loading, false);
    });

    test('DiscoveryState should detect if filter is active', () {
      const state = DiscoveryState();
      expect(state.isFilterActive(), false);
      
      final stateWithFilters = state.copyWith(
        filterCountries: ['Germany'],
      );
      expect(stateWithFilters.isFilterActive(), true);
    });

    test('DiscoveryState should calculate filtered events length', () {
      const state = DiscoveryState();
      expect(state.filteredEventOccurencesLength, 0);
    });

    test('DiscoveryNotifier should initialize with default state', () {
      // Create a notifier without calling the constructor that triggers network call
      final notifier = DiscoveryNotifier.test();
      expect(notifier.state.loading, false);
      expect(notifier.state.filteredEventOccurences, isEmpty);
    });

    test('DiscoveryNotifier should change active category', () {
      final notifier = DiscoveryNotifier.test();
      
      notifier.changeActiveCategory(EventType.Workshops);
      expect(notifier.state.filterCategories, contains(EventType.Workshops));
      
      notifier.changeActiveCategory(EventType.Workshops); // Remove it
      expect(notifier.state.filterCategories, isEmpty);
    });

    test('DiscoveryNotifier should change active country', () {
      final notifier = DiscoveryNotifier.test();
      
      notifier.changeActiveCountry('Germany');
      expect(notifier.state.filterCountries, contains('Germany'));
      
      notifier.changeActiveCountry('Germany'); // Remove it
      expect(notifier.state.filterCountries, isEmpty);
    });

    test('DiscoveryNotifier should change active region', () {
      final notifier = DiscoveryNotifier.test();
      
      notifier.changeActiveRegion('Berlin');
      expect(notifier.state.filterRegions, contains('Berlin'));
      
      notifier.changeActiveRegion('Berlin'); // Remove it
      expect(notifier.state.filterRegions, isEmpty);
    });

    test('DiscoveryNotifier should toggle highlighted filter', () {
      final notifier = DiscoveryNotifier.test();
      
      expect(notifier.state.isOnlyHighlightedFilter, false);
      
      notifier.setToOnlyHighlightedFilter();
      expect(notifier.state.isOnlyHighlightedFilter, true);
      
      notifier.setToOnlyHighlightedFilter();
      expect(notifier.state.isOnlyHighlightedFilter, false);
    });

    test('DiscoveryNotifier should toggle bookable filter', () {
      final notifier = DiscoveryNotifier.test();
      
      expect(notifier.state.isOnlyBookableFilter, false);
      
      notifier.setToOnlyBookableFilter();
      expect(notifier.state.isOnlyBookableFilter, true);
      
      notifier.setToOnlyBookableFilter();
      expect(notifier.state.isOnlyBookableFilter, false);
    });

    test('DiscoveryNotifier should toggle followed teacher filter', () {
      final notifier = DiscoveryNotifier.test();
      
      expect(notifier.state.isOnlyFollowedTeacherFilter, false);
      
      notifier.setToOnlyFollowedTeacherFilter();
      expect(notifier.state.isOnlyFollowedTeacherFilter, true);
      
      notifier.setToOnlyFollowedTeacherFilter();
      expect(notifier.state.isOnlyFollowedTeacherFilter, false);
    });

    test('DiscoveryNotifier should reset filter', () {
      final notifier = DiscoveryNotifier.test();
      
      // Set some filters
      notifier.changeActiveCategory(EventType.Workshops);
      notifier.changeActiveCountry('Germany');
      notifier.setToOnlyHighlightedFilter();
      
      expect(notifier.state.filterCategories, isNotEmpty);
      expect(notifier.state.filterCountries, isNotEmpty);
      expect(notifier.state.isOnlyHighlightedFilter, true);
      
      // Reset
      notifier.resetFilter();
      
      expect(notifier.state.filterCategories, isEmpty);
      expect(notifier.state.filterCountries, isEmpty);
      expect(notifier.state.isOnlyHighlightedFilter, false);
    });
  });
}
