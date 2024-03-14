import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DiscoveryProvider extends ChangeNotifier {
  // initial data
  final List<ClassEvent> _allEventOccurences = [];
  final List<DateTime> _allDates = [];
  final List<EventType> _allEventTypes = [];
  final List<String> _allCountries = [];

  // filtered data
  List<ClassEvent> _filteredEventOccurences = [];

  // filter
  final List<String> filterCountries = [];
  final List<EventType> filterCategories = [];
  final List<DateTime> filterDates = [];
  bool isOnlyBookableFilter = false;
  bool isOnlyHighlightedFilter = false;
  bool isOnlyFollowedTeacherFilter = false;
  bool isOnlyCloseToMeFilter = false;

  bool _loading = false;

  // getter
  List<ClassEvent> get filteredEventOccurences => _filteredEventOccurences;

  bool get loading => _loading;
  bool get isFilter => isFilterActive();
  int get filteredEventOccurencesLength => _filteredEventOccurences.length;

  List<EventType> get allEventTypes => _allEventTypes;
  List<String> get allCountries => _allCountries;
  List<DateTime> get allDates => _allDates;

  // is filter active
  bool isFilterActive() {
    return filterCountries.isNotEmpty ||
        filterCategories.isNotEmpty ||
        filterDates.isNotEmpty ||
        isOnlyBookableFilter ||
        isOnlyHighlightedFilter ||
        isOnlyFollowedTeacherFilter ||
        isOnlyCloseToMeFilter;
  }

  // reset filter
  void resetFilter() {
    filterCountries.clear();
    filterCategories.clear();
    filterDates.clear();
    isOnlyBookableFilter = false;
    isOnlyHighlightedFilter = false;
    isOnlyFollowedTeacherFilter = false;
    isOnlyCloseToMeFilter = false;
    _filteredEventOccurences = _allEventOccurences;
    notifyListeners();
  }

  // get active events (filtered)
  void setActiveEvents() {
    _filteredEventOccurences = _allEventOccurences;

    if (filterCountries.isNotEmpty) {
      _filteredEventOccurences = _filteredEventOccurences
          .where((event) =>
              event.classModel?.country != null &&
              filterCountries.contains(event.classModel?.country))
          .toList();
    }

    if (filterCategories.isNotEmpty) {
      _filteredEventOccurences = _filteredEventOccurences
          .where((event) =>
              event.classModel?.eventType != null &&
              filterCategories.contains(event.classModel?.eventType))
          .toList();
    }

    // where one of the filtermonts is between the start and end date
    if (filterDates.isNotEmpty) {
      _filteredEventOccurences = _filteredEventOccurences
          .where((ClassEvent event) =>
              isDateMonthAndYearInList(filterDates, event.startDateDT) ||
              isDateMonthAndYearInList(
                  filterDates, DateTime.parse(event.endDate!)))
          .toList();
    }

    if (isOnlyBookableFilter) {
      _filteredEventOccurences = _filteredEventOccurences
          .where((event) =>
              event.maxBookingSlots != null &&
              event.availableBookingSlots != null &&
              event.classModel?.classBookingOptions != null &&
              event.classModel!.classBookingOptions!.isNotEmpty &&
              event.availableBookingSlots! > 0)
          .toList();
    }

    if (isOnlyHighlightedFilter) {
      _filteredEventOccurences = _filteredEventOccurences
          .where((event) => event.isHighlighted == true)
          .toList();
    }

    notifyListeners();
  }

  // all highlighted events
  List<ClassEvent> getHighlightedEvents() {
    return _allEventOccurences
        .where((event) => event.isHighlighted == true)
        .toList();
  }

  List<ClassEvent> getEventsByType(EventType eventType) {
    return _allEventOccurences
        .where((event) => event.classModel?.eventType == eventType)
        .toList();
  }

  // get bookable events (maxBookingSlots > 0)
  List<ClassEvent> getBookableEvents() {
    return _allEventOccurences
        .where((event) =>
            event.maxBookingSlots != null &&
            event.availableBookingSlots != null &&
            event.classModel?.classBookingOptions != null &&
            event.classModel!.classBookingOptions!.isNotEmpty &&
            event.availableBookingSlots! > 0)
        .toList();
  }

  DiscoveryProvider() {
    fetchAllEventOccurences(isNetworkOnly: false);
  }

  fetchAllEventOccurences({bool? isNetworkOnly}) async {
    // TODO create smarter function in nest server with pagination and only fetch the nearest occurences
    if (isNetworkOnly == false) {
      _loading = true;
      notifyListeners();
    }

    // fetch classevents from the backend
    QueryOptions options = QueryOptions(
        document: Queries.getEventOccurences,
        fetchPolicy: isNetworkOnly == false
            ? FetchPolicy.cacheAndNetwork
            : FetchPolicy.networkOnly);
    try {
      QueryResult<Object?> result =
          await GraphQLClientSingleton().query(options);

      if (result.hasException) {
        CustomErrorHandler.captureException(result.exception);
      }

      if (result.data != null && result.data!['class_events'] != null) {
        _allEventOccurences.clear();
        _allEventTypes.clear();
        _allCountries.clear();
        try {
          // Temporary list to hold new events
          var newEvents = List<ClassEvent>.from(
            result.data!['class_events']
                .map((json) => ClassEvent.fromJson(json)),
          );

          // if the new Event recurrent pattern has is_recurrent = true,
          // and the recurrent pattern id is the same as an existing event,
          // only keep the nearest occurence
          for (var newEvent in newEvents) {
            // if the event.startDate is not in the list, add it
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
            // if the event.classModel?.country is not in the list, add it
            if (newEvent.classModel?.country != null &&
                !_allCountries.contains(newEvent.classModel!.country!)) {
              _allCountries.add(newEvent.classModel!.country!);
            }
            // if the event.eventype is not in the list, add it
            if (newEvent.classModel?.eventType != null &&
                !_allEventTypes.contains(newEvent.classModel!.eventType!)) {
              _allEventTypes.add(newEvent.classModel!.eventType!);
            }

            int index = _allEventOccurences.indexWhere((existingEvent) =>
                existingEvent.classId == newEvent.classId &&
                existingEvent.recurringPattern?.isRecurring == true &&
                existingEvent.recurringPattern?.id ==
                    newEvent.recurringPattern?.id);

            if (index != -1) {
              // Event exists, check if the new event's start date is earlier
              if (newEvent.startDateDT
                  .isBefore(_allEventOccurences[index].startDateDT)) {
                _allEventOccurences[index] =
                    newEvent; // Update the existing event
              }
            } else {
              _allEventOccurences
                  .add(newEvent); // Add new event as it does not exist
            }
          }
        } catch (e, s) {
          CustomErrorHandler.captureException(e, stackTrace: s);
        }
      }
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
    }

    print("length of allEventOccurences: ${_allEventOccurences.length}");
    _loading = false;
    notifyListeners();
  }

  // change active filter

  changeActiveEventDates(DateTime changeDate) {
    if (isDateMonthAndYearInList(filterDates, changeDate)) {
      filterDates.removeWhere((date) =>
          date.month == changeDate.month && date.year == changeDate.year);
    } else {
      filterDates.add(changeDate);
    }
    setActiveEvents();
  }

  changeActiveCategory(EventType changeCategory) {
    if (filterCategories.contains(changeCategory)) {
      filterCategories.remove(changeCategory);
    } else {
      filterCategories.add(changeCategory);
    }
    setActiveEvents();
  }

  changeActiveCountry(String changeCountry) {
    if (filterCountries.contains(changeCountry)) {
      filterCountries.remove(changeCountry);
    } else {
      filterCountries.add(changeCountry);
    }
    setActiveEvents();
  }

  setToOnlyHighlightedFilter() {
    isOnlyHighlightedFilter = !isOnlyHighlightedFilter;
    setActiveEvents();
  }

  setToOnlyBookableFilter() {
    isOnlyBookableFilter = !isOnlyBookableFilter;
    setActiveEvents();
  }

  setToOnlyFollowedTeacherFilter() {
    isOnlyFollowedTeacherFilter = !isOnlyFollowedTeacherFilter;
    setActiveEvents();
  }
}
