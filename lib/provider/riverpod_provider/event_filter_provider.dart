import 'package:acroworld/data/models/event_model.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class EventFilterState {
  final List<String> eventPoster;
  final List<EventModel> initialEvents;
  final List<EventModel> activeEvents;
  final List<String> initialCategories;
  final List<String> initialCountries;
  final List<DateTime> initialDates;
  final List<String> activeCategories;
  final List<String> activeCountries;
  final List<DateTime> activeDates;
  final bool onlyHighlighted;
  final List<TeacherModel> followedTeachers;
  final bool initialized;

  const EventFilterState({
    this.eventPoster = const [],
    this.initialEvents = const [],
    this.activeEvents = const [],
    this.initialCategories = const [],
    this.initialCountries = const [],
    this.initialDates = const [],
    this.activeCategories = const [],
    this.activeCountries = const [],
    this.activeDates = const [],
    this.onlyHighlighted = false,
    this.followedTeachers = const [],
    this.initialized = false,
  });

  EventFilterState copyWith({
    List<String>? eventPoster,
    List<EventModel>? initialEvents,
    List<EventModel>? activeEvents,
    List<String>? initialCategories,
    List<String>? initialCountries,
    List<DateTime>? initialDates,
    List<String>? activeCategories,
    List<String>? activeCountries,
    List<DateTime>? activeDates,
    bool? onlyHighlighted,
    List<TeacherModel>? followedTeachers,
    bool? initialized,
  }) {
    return EventFilterState(
      eventPoster: eventPoster ?? this.eventPoster,
      initialEvents: initialEvents ?? this.initialEvents,
      activeEvents: activeEvents ?? this.activeEvents,
      initialCategories: initialCategories ?? this.initialCategories,
      initialCountries: initialCountries ?? this.initialCountries,
      initialDates: initialDates ?? this.initialDates,
      activeCategories: activeCategories ?? this.activeCategories,
      activeCountries: activeCountries ?? this.activeCountries,
      activeDates: activeDates ?? this.activeDates,
      onlyHighlighted: onlyHighlighted ?? this.onlyHighlighted,
      followedTeachers: followedTeachers ?? this.followedTeachers,
      initialized: initialized ?? this.initialized,
    );
  }

  int getActiveFilterCount() {
    int count = 0;
    if (activeCategories.isNotEmpty) {
      count += activeCategories.length;
    }
    if (activeCountries.isNotEmpty) {
      count += activeCountries.length;
    }
    if (activeDates.isNotEmpty) {
      count += activeDates.length;
    }
    if (onlyHighlighted) {
      count += 1;
    }
    if (followedTeachers.isNotEmpty) {
      count += 1;
    }
    return count;
  }

  bool isFilterActive() {
    return activeCategories.isNotEmpty ||
        activeDates.isNotEmpty ||
        activeCountries.isNotEmpty ||
        onlyHighlighted ||
        followedTeachers.isNotEmpty;
  }

  String filterString() {
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');

    String fString = "";

    // Case 1: no filter active
    if (activeCategories.isEmpty &&
        activeDates.isEmpty &&
        activeCountries.isEmpty &&
        !onlyHighlighted &&
        followedTeachers.isEmpty) {
      fString = "Set filters";
      return fString;
    }

    // Trainings ...
    if (activeCategories.length == 1) {
      fString +=
          " ${capitalizeWords(activeCategories[0].replaceAllMapped(exp, (Match m) => (' ${m.group(0)}')).toLowerCase())},";
    } else if (activeCategories.length > 1) {
      fString +=
          " ${capitalizeWords(activeCategories[0].replaceAllMapped(exp, (Match m) => (' ${m.group(0)}')).toLowerCase())} + ${activeCategories.length - 1},";
    }

    // ... Jul ...
    if (activeDates.length == 1) {
      fString += " ${DateFormat.MMM().format(activeDates[0])},";
    } else if (activeDates.length > 1) {
      fString +=
          " ${DateFormat.MMM().format(activeDates[0])} + ${activeDates.length - 1},";
    }

    // ... Germany
    if (activeCountries.length == 1) {
      fString += " ${activeCountries[0]},";
    } else if (activeCountries.length > 1) {
      fString += " ${activeCountries[0]} + ${activeCountries.length - 1},";
    }

    // ... highlights
    if (onlyHighlighted) {
      fString += " Highlights,";
    }

    // ... followedTeachers
    if (followedTeachers.isNotEmpty) {
      fString += " Your teacher,";
    }

    if (fString.isNotEmpty) {
      fString = fString.trim();
    }

    return fString.substring(0, fString.length - 1);
  }
}

class EventFilterNotifier extends StateNotifier<EventFilterState> {
  EventFilterNotifier() : super(const EventFilterState());

  void setInitialData(List events) {
    CustomErrorHandler.logDebug('EventFilterNotifier: Setting initial data');

    // get the events
    final initialEvents =
        events.map((event) => EventModel.fromJson(event)).toList();

    List<String> initialCategories = [];
    List<String> initialCountries = [];
    List<DateTime> initialDates = [];

    // set the initialFilter
    for (EventModel event in initialEvents) {
      if (event.eventType != null &&
          !initialCategories.contains(event.eventType)) {
        initialCategories.add(event.eventType!);
      }

      if (event.locationCountry != null &&
          !initialCountries.contains(event.locationCountry)) {
        initialCountries.add(event.locationCountry!);
      }

      try {
        if (event.startDate != null) {
          final newDate = DateTime.parse(event.startDate!);
          bool isInInitialDates =
              isDateMonthAndYearInList(initialDates, newDate);
          if (!isInInitialDates) {
            initialDates.add(newDate);
          }
        }
      } catch (e, s) {
        CustomErrorHandler.captureException(e.toString(), stackTrace: s);
      }
    }

    final sortedEvents = List<EventModel>.from(initialEvents);
    sortedEvents.sort((a, b) => a.startDate!.compareTo(b.startDate!));

    state = state.copyWith(
      initialEvents: sortedEvents,
      activeEvents: sortedEvents,
      initialCategories: initialCategories,
      initialCountries: initialCountries,
      initialDates: initialDates,
      initialized: true,
    );
  }

  void setActiveCategory(List<String> newActiveCategories) {
    CustomErrorHandler.logDebug(
        'EventFilterNotifier: Setting active categories');
    state = state.copyWith(
      activeCategories: newActiveCategories,
      activeDates: [], // also reset dates
    );
    _resetActiveEventsFromFilter();
  }

  void changeActiveEventDates(DateTime changeDate) {
    CustomErrorHandler.logDebug(
        'EventFilterNotifier: Changing active event dates');
    List<DateTime> newActiveDates = List.from(state.activeDates);

    if (isDateMonthAndYearInList(newActiveDates, changeDate)) {
      newActiveDates.removeWhere((date) =>
          date.month == changeDate.month && date.year == changeDate.year);
    } else {
      newActiveDates.add(changeDate);
    }

    state = state.copyWith(activeDates: newActiveDates);
    _resetActiveEventsFromFilter();
  }

  void tryAddingActiveEventDates(DateTime addDate) {
    CustomErrorHandler.logDebug(
        'EventFilterNotifier: Adding active event dates');
    List<DateTime> newActiveDates = List.from(state.activeDates);

    if (!isDateMonthAndYearInList(newActiveDates, addDate)) {
      newActiveDates.add(addDate);
    }

    state = state.copyWith(activeDates: newActiveDates);
    _resetActiveEventsFromFilter();
  }

  void changeActiveCategory(String changeCategory) {
    CustomErrorHandler.logDebug(
        'EventFilterNotifier: Changing active category');
    List<String> newActiveCategories = List.from(state.activeCategories);

    if (newActiveCategories.contains(changeCategory)) {
      newActiveCategories.remove(changeCategory);
    } else {
      newActiveCategories.add(changeCategory);
    }

    state = state.copyWith(activeCategories: newActiveCategories);
    _resetActiveEventsFromFilter();
  }

  void changeActiveCountry(String changeCountry) {
    CustomErrorHandler.logDebug('EventFilterNotifier: Changing active country');
    List<String> newActiveCountries = List.from(state.activeCountries);

    if (newActiveCountries.contains(changeCountry)) {
      newActiveCountries.remove(changeCountry);
    } else {
      newActiveCountries.add(changeCountry);
    }

    state = state.copyWith(activeCountries: newActiveCountries);
    _resetActiveEventsFromFilter();
  }

  void changeHighlighted() {
    CustomErrorHandler.logDebug(
        'EventFilterNotifier: Changing highlighted filter');
    state = state.copyWith(onlyHighlighted: !state.onlyHighlighted);
    _resetActiveEventsFromFilter();
  }

  void changeOneFollowedTeachers(TeacherModel teacher) {
    CustomErrorHandler.logDebug(
        'EventFilterNotifier: Changing followed teachers');
    List<TeacherModel> newFollowedTeachers = List.from(state.followedTeachers);

    if (newFollowedTeachers.contains(teacher)) {
      newFollowedTeachers.remove(teacher);
    } else {
      newFollowedTeachers.add(teacher);
    }

    state = state.copyWith(followedTeachers: newFollowedTeachers);
    _resetActiveEventsFromFilter();
  }

  void changeAllFollowedTeachers(List<TeacherModel> teachers) {
    CustomErrorHandler.logDebug(
        'EventFilterNotifier: Changing all followed teachers');
    state = state.copyWith(followedTeachers: teachers);
    _resetActiveEventsFromFilter();
  }

  bool resetFilter() {
    CustomErrorHandler.logDebug('EventFilterNotifier: Resetting filter');
    state = state.copyWith(
      activeCategories: [],
      activeCountries: [],
      activeDates: [],
      activeEvents: state.initialEvents,
      onlyHighlighted: false,
      followedTeachers: [],
    );
    return true;
  }

  void _resetActiveEventsFromFilter() {
    CustomErrorHandler.logDebug(
        'EventFilterNotifier: Resetting active events from filter');
    List<EventModel> returnEvents = state.initialEvents;

    if (state.onlyHighlighted) {
      returnEvents = returnEvents
          .where((EventModel event) => event.isHighlighted == true)
          .toList();
    }

    if (state.followedTeachers.isNotEmpty) {
      returnEvents = returnEvents.where((EventModel event) {
        if (event.teachers == null ||
            event.teachers!.isEmpty ||
            state.followedTeachers.isEmpty) {
          return false;
        }

        for (TeacherModel eventTeacher in event.teachers!) {
          for (TeacherModel followTeacher in state.followedTeachers) {
            if (eventTeacher.id == followTeacher.id) {
              return true;
            }
          }
        }
        return false;
      }).toList();
    }

    if (state.activeCountries.isNotEmpty) {
      returnEvents = returnEvents
          .where((EventModel event) =>
              state.activeCountries.contains(event.locationCountry))
          .toList();
    }

    if (state.activeCategories.isNotEmpty) {
      returnEvents = returnEvents
          .where((EventModel event) =>
              state.activeCategories.contains(event.eventType))
          .toList();
    }

    if (state.activeDates.isNotEmpty) {
      returnEvents = returnEvents
          .where((EventModel event) =>
              isDateMonthAndYearInList(
                  state.activeDates, DateTime.parse(event.startDate!)) ||
              isDateMonthAndYearInList(
                  state.activeDates, DateTime.parse(event.endDate!)))
          .toList();
    }

    state = state.copyWith(activeEvents: returnEvents);
  }
}

final eventFilterProvider =
    StateNotifierProvider<EventFilterNotifier, EventFilterState>((ref) {
  return EventFilterNotifier();
});
