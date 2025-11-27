import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DiscoveryState {
  final List<ClassEvent> allEventOccurences;
  final List<DateTime> allDates;
  final List<EventType> allEventTypes;
  final List<String> allCountries;
  final Map<String, List<String>> allRegionsByCountry;
  final List<ClassEvent> filteredEventOccurences;
  final List<String> filterCountries;
  final List<String> filterRegions;
  final List<EventType> filterCategories;
  final List<DateTime> filterDates;
  final bool isOnlyBookableFilter;
  final bool isOnlyHighlightedFilter;
  final bool isOnlyFollowedTeacherFilter;
  final bool isOnlyCloseToMeFilter;
  final bool loading;

  const DiscoveryState({
    this.allEventOccurences = const [],
    this.allDates = const [],
    this.allEventTypes = const [],
    this.allCountries = const [],
    this.allRegionsByCountry = const {},
    this.filteredEventOccurences = const [],
    this.filterCountries = const [],
    this.filterRegions = const [],
    this.filterCategories = const [],
    this.filterDates = const [],
    this.isOnlyBookableFilter = false,
    this.isOnlyHighlightedFilter = false,
    this.isOnlyFollowedTeacherFilter = false,
    this.isOnlyCloseToMeFilter = false,
    this.loading = false,
  });

  DiscoveryState copyWith({
    List<ClassEvent>? allEventOccurences,
    List<DateTime>? allDates,
    List<EventType>? allEventTypes,
    List<String>? allCountries,
    Map<String, List<String>>? allRegionsByCountry,
    List<ClassEvent>? filteredEventOccurences,
    List<String>? filterCountries,
    List<String>? filterRegions,
    List<EventType>? filterCategories,
    List<DateTime>? filterDates,
    bool? isOnlyBookableFilter,
    bool? isOnlyHighlightedFilter,
    bool? isOnlyFollowedTeacherFilter,
    bool? isOnlyCloseToMeFilter,
    bool? loading,
  }) {
    return DiscoveryState(
      allEventOccurences: allEventOccurences ?? this.allEventOccurences,
      allDates: allDates ?? this.allDates,
      allEventTypes: allEventTypes ?? this.allEventTypes,
      allCountries: allCountries ?? this.allCountries,
      allRegionsByCountry: allRegionsByCountry ?? this.allRegionsByCountry,
      filteredEventOccurences:
          filteredEventOccurences ?? this.filteredEventOccurences,
      filterCountries: filterCountries ?? this.filterCountries,
      filterRegions: filterRegions ?? this.filterRegions,
      filterCategories: filterCategories ?? this.filterCategories,
      filterDates: filterDates ?? this.filterDates,
      isOnlyBookableFilter: isOnlyBookableFilter ?? this.isOnlyBookableFilter,
      isOnlyHighlightedFilter:
          isOnlyHighlightedFilter ?? this.isOnlyHighlightedFilter,
      isOnlyFollowedTeacherFilter:
          isOnlyFollowedTeacherFilter ?? this.isOnlyFollowedTeacherFilter,
      isOnlyCloseToMeFilter:
          isOnlyCloseToMeFilter ?? this.isOnlyCloseToMeFilter,
      loading: loading ?? this.loading,
    );
  }

  bool get isFilter => isFilterActive();
  int get filteredEventOccurencesLength => filteredEventOccurences.length;

  bool isFilterActive() {
    return filterCountries.isNotEmpty ||
        filterCategories.isNotEmpty ||
        filterDates.isNotEmpty ||
        filterRegions.isNotEmpty ||
        isOnlyBookableFilter ||
        isOnlyHighlightedFilter ||
        isOnlyFollowedTeacherFilter ||
        isOnlyCloseToMeFilter;
  }

  List<ClassEvent> getHighlightedEvents() {
    return allEventOccurences
        .where((event) => event.isHighlighted == true)
        .toList();
  }

  List<ClassEvent> getEventsByType(EventType eventType) {
    return allEventOccurences
        .where((event) => event.classModel?.eventType == eventType)
        .toList();
  }

  List<ClassEvent> getBookableEvents() {
    return allEventOccurences.where((event) => event.isBookable).toList();
  }

  List<String> getRegionsForSelectedCountries() {
    List<String> selectedRegions = [];
    for (var country in filterCountries) {
      if (allRegionsByCountry.containsKey(country)) {
        selectedRegions.addAll(allRegionsByCountry[country]!);
      }
    }
    return selectedRegions.toSet().toList(); // remove duplicates if any
  }
}

class DiscoveryNotifier extends StateNotifier<DiscoveryState> {
  DiscoveryNotifier() : super(const DiscoveryState()) {
    fetchAllEventOccurences(isNetworkOnly: false);
  }

  // Test constructor that doesn't trigger network calls
  DiscoveryNotifier.test() : super(const DiscoveryState());

  void resetFilter() {
    CustomErrorHandler.logDebug('DiscoveryNotifier: Resetting filter');
    state = state.copyWith(
      filterCountries: [],
      filterCategories: [],
      filterDates: [],
      filterRegions: [],
      isOnlyBookableFilter: false,
      isOnlyHighlightedFilter: false,
      isOnlyFollowedTeacherFilter: false,
      isOnlyCloseToMeFilter: false,
      filteredEventOccurences: state.allEventOccurences,
    );
  }

  void setActiveEvents() {
    CustomErrorHandler.logDebug('DiscoveryNotifier: Setting active events');
    List<ClassEvent> filteredEvents = state.allEventOccurences;

    if (state.filterCountries.isNotEmpty) {
      filteredEvents = filteredEvents
          .where((event) =>
              event.classModel?.country != null &&
              state.filterCountries.contains(event.classModel?.country))
          .toList();
    }

    if (state.filterRegions.isNotEmpty) {
      filteredEvents = filteredEvents.where((event) {
        final region = event.classModel?.city ?? "Not specified";
        final matchesRegion = state.filterRegions.contains(region);
        final matchesNotSpecified = region == "Not specified" &&
            state.filterRegions.contains("Not specified");
        return matchesRegion || matchesNotSpecified;
      }).toList();
    }

    if (state.filterCategories.isNotEmpty) {
      filteredEvents = filteredEvents
          .where((event) =>
              event.classModel?.eventType != null &&
              state.filterCategories.contains(event.classModel?.eventType))
          .toList();
    }

    if (state.filterDates.isNotEmpty) {
      filteredEvents = filteredEvents
          .where((ClassEvent event) =>
              isDateMonthAndYearInList(state.filterDates, event.startDateDT) ||
              isDateMonthAndYearInList(
                  state.filterDates, DateTime.parse(event.endDate!)))
          .toList();
    }

    if (state.isOnlyBookableFilter) {
      filteredEvents =
          filteredEvents.where((event) => event.isBookable).toList();
    }

    if (state.isOnlyHighlightedFilter) {
      filteredEvents =
          filteredEvents.where((event) => event.isHighlighted == true).toList();
    }

    state = state.copyWith(filteredEventOccurences: filteredEvents);
  }

  Future<void> fetchAllEventOccurences({bool? isNetworkOnly}) async {
    CustomErrorHandler.logDebug(
        'DiscoveryNotifier: Fetching all event occurrences');

    if (isNetworkOnly == false) {
      state = state.copyWith(loading: true);
    }

    QueryOptions options = QueryOptions(
        document: Queries.getEventOccurences,
        fetchPolicy: isNetworkOnly == false
            ? FetchPolicy.cacheAndNetwork
            : FetchPolicy.networkOnly);

    try {
      final graphQLClient = GraphQLClientSingleton().client;
      QueryResult<Object?> result = await graphQLClient.query(options);

      if (result.hasException) {
        CustomErrorHandler.captureException(result.exception);
      }

      if (result.data != null && result.data!['class_events'] != null) {
        try {
          var newEvents = List<ClassEvent>.from(
            result.data!['class_events']
                .map((json) => ClassEvent.fromJson(json)),
          );

          List<ClassEvent> allEvents = List.from(state.allEventOccurences);
          List<DateTime> allDates = List.from(state.allDates);
          List<EventType> allEventTypes = List.from(state.allEventTypes);
          List<String> allCountries = List.from(state.allCountries);
          Map<String, List<String>> allRegionsByCountry =
              Map.from(state.allRegionsByCountry);

          for (var newEvent in newEvents) {
            try {
              if (newEvent.startDate != null) {
                final newDate = DateTime.parse(newEvent.startDate!);
                bool isInInitialDates =
                    isDateMonthAndYearInList(allDates, newDate);
                if (!isInInitialDates) {
                  allDates.add(newDate);
                }
              }
            } catch (e, s) {
              CustomErrorHandler.captureException(e.toString(), stackTrace: s);
            }

            if (newEvent.classModel?.country != null &&
                !allCountries.contains(newEvent.classModel!.country!)) {
              allCountries.add(newEvent.classModel!.country!);
            }

            if (newEvent.classModel?.country != null) {
              final country = newEvent.classModel!.country!;
              final region = newEvent.classModel?.city ?? "Not specified";

              if (!allRegionsByCountry.containsKey(country)) {
                allRegionsByCountry[country] = [];
              }
              if (!allRegionsByCountry[country]!.contains(region)) {
                allRegionsByCountry[country]!.add(region);
              }
            }

            if (newEvent.classModel?.eventType != null &&
                !allEventTypes.contains(newEvent.classModel!.eventType!)) {
              allEventTypes.add(newEvent.classModel!.eventType!);
            }

            int index = allEvents.indexWhere((existingEvent) =>
                existingEvent.classId == newEvent.classId &&
                existingEvent.recurringPattern?.isRecurring == true &&
                existingEvent.recurringPattern?.id ==
                    newEvent.recurringPattern?.id);

            if (index != -1) {
              if (newEvent.startDateDT.isBefore(allEvents[index].startDateDT)) {
                allEvents[index] = newEvent;
              }
            } else {
              allEvents.add(newEvent);
            }
          }

          state = state.copyWith(
            allEventOccurences: allEvents,
            allDates: allDates,
            allEventTypes: allEventTypes,
            allCountries: allCountries,
            allRegionsByCountry: allRegionsByCountry,
            loading: false,
          );

          setActiveEvents();
        } catch (e, s) {
          CustomErrorHandler.captureException(e, stackTrace: s);
        }
      }
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
    }

    state = state.copyWith(loading: false);
  }

  void changeActiveEventDates(DateTime changeDate) {
    CustomErrorHandler.logDebug(
        'DiscoveryNotifier: Changing active event dates');
    List<DateTime> newFilterDates = List.from(state.filterDates);

    if (isDateMonthAndYearInList(newFilterDates, changeDate)) {
      newFilterDates.removeWhere((date) =>
          date.month == changeDate.month && date.year == changeDate.year);
    } else {
      newFilterDates.add(changeDate);
    }

    state = state.copyWith(filterDates: newFilterDates);
    setActiveEvents();
  }

  void changeActiveCategory(EventType changeCategory) {
    CustomErrorHandler.logDebug('DiscoveryNotifier: Changing active category');
    List<EventType> newFilterCategories = List.from(state.filterCategories);

    if (newFilterCategories.contains(changeCategory)) {
      newFilterCategories.remove(changeCategory);
    } else {
      newFilterCategories.add(changeCategory);
    }

    state = state.copyWith(filterCategories: newFilterCategories);
    setActiveEvents();
  }

  void changeActiveCountry(String changeCountry) {
    CustomErrorHandler.logDebug('DiscoveryNotifier: Changing active country');
    List<String> newFilterCountries = List.from(state.filterCountries);

    if (newFilterCountries.contains(changeCountry)) {
      newFilterCountries.remove(changeCountry);
    } else {
      newFilterCountries.add(changeCountry);
    }

    state = state.copyWith(filterCountries: newFilterCountries);
    setActiveEvents();
  }

  void changeActiveRegion(String region) {
    CustomErrorHandler.logDebug('DiscoveryNotifier: Changing active region');
    List<String> newFilterRegions = List.from(state.filterRegions);

    if (newFilterRegions.contains(region)) {
      newFilterRegions.remove(region);
    } else {
      newFilterRegions.add(region);
    }

    state = state.copyWith(filterRegions: newFilterRegions);
    setActiveEvents();
  }

  void setToOnlyHighlightedFilter() {
    CustomErrorHandler.logDebug(
        'DiscoveryNotifier: Toggling highlighted filter');
    state =
        state.copyWith(isOnlyHighlightedFilter: !state.isOnlyHighlightedFilter);
    setActiveEvents();
  }

  void setToOnlyBookableFilter() {
    CustomErrorHandler.logDebug('DiscoveryNotifier: Toggling bookable filter');
    state = state.copyWith(isOnlyBookableFilter: !state.isOnlyBookableFilter);
    setActiveEvents();
  }

  void setToOnlyFollowedTeacherFilter() {
    CustomErrorHandler.logDebug(
        'DiscoveryNotifier: Toggling followed teacher filter');
    state = state.copyWith(
        isOnlyFollowedTeacherFilter: !state.isOnlyFollowedTeacherFilter);
    setActiveEvents();
  }
}

final discoveryProvider =
    StateNotifierProvider<DiscoveryNotifier, DiscoveryState>((ref) {
  return DiscoveryNotifier();
});
