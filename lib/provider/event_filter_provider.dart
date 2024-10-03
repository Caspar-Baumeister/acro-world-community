import 'package:acroworld/data/models/event_model.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class EventFilterProvider extends ChangeNotifier {
  List<String> eventPoster = [];

  List<EventModel> initialEvents = [];
  List<EventModel> activeEvents = [];

  List<String> initialCategories = [];
  List<String> initialCountries = [];
  List<DateTime> initialDates = [];

  List<String> activeCategories = [];
  List<String> activeCountries = [];
  List<DateTime> activeDates = [];

  bool onlyHighlighted = false;
  List<TeacherModel> followedTeachers = [];

  bool initialized = false;

  // there are allInitalFilter, activeFilter and possibleFilters

  // the inital filter parameters are set after loading the data
  // and everytime the provider is restarted
  EventFilterProvider() {
    // getInitialData();
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

  setInitialData(List events) {
    // get the events
    initialEvents = events
        .map((event) => EventModel.fromJson(event))
        // .where((element) =>
        //     DateTime.parse(element.endDate!).difference(DateTime.now()).inDays >
        //     0)
        .toList();

    initialCategories = [];
    initialCountries = [];
    initialDates = [];
    activeEvents = initialEvents;

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
      } catch (e) {
        // ignore: avoid_print
        print(e.toString());
      }
    }
    initialEvents.sort((a, b) => a.startDate!.compareTo(b.startDate!));

    // TODO INCLUDE YEAR FOR DATES
    initialized = true;
    notifyListeners();
  }
  // when a filter parameter is set to active, all other possibleFilter are recalculated
  // There needs to be a hirachy categories -> location -> time (categorie and location could change)

  // to replace the active categories completly
  setActiveCategory(List<String> newActiveCategories) {
    activeCategories = newActiveCategories;
    // also reset dates
    activeDates = [];
    resetActiveEventsFromFilter();
  }

  changeActiveEventDates(DateTime changeDate) {
    if (isDateMonthAndYearInList(activeDates, changeDate)) {
      activeDates.removeWhere((date) =>
          date.month == changeDate.month && date.year == changeDate.year);
    } else {
      activeDates.add(changeDate);
    }
    resetActiveEventsFromFilter();
  }

  tryAddingActiveEventDates(DateTime addDate) {
    if (!isDateMonthAndYearInList(activeDates, addDate)) {
      activeDates.add(addDate);
    }
    resetActiveEventsFromFilter();
  }

  changeActiveCategory(String changeCategory) {
    if (activeCategories.contains(changeCategory)) {
      activeCategories.remove(changeCategory);
    } else {
      activeCategories.add(changeCategory);
    }
    resetActiveEventsFromFilter();
  }

  changeActiveCountry(String changeCountry) {
    if (activeCountries.contains(changeCountry)) {
      activeCountries.remove(changeCountry);
    } else {
      activeCountries.add(changeCountry);
    }
    resetActiveEventsFromFilter();
  }

  changeHighlighted() {
    onlyHighlighted = !onlyHighlighted;
    resetActiveEventsFromFilter();
  }

  changeOneFollowedTeachers(TeacherModel teacher) {
    if (followedTeachers.contains(teacher)) {
      followedTeachers.remove(teacher);
    } else {
      followedTeachers.add(teacher);
    }
    resetActiveEventsFromFilter();
  }

  changeAllFollowedTeachers(List<TeacherModel> teachers) {
    followedTeachers = teachers;
    resetActiveEventsFromFilter();
  }

  bool resetFilter() {
    activeCategories = [];
    activeCountries = [];
    activeDates = [];
    activeEvents = initialEvents;
    onlyHighlighted = false;
    followedTeachers = [];
    notifyListeners();
    return true;
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

  bool isFilterActive() {
    return activeCategories.isNotEmpty ||
        activeDates.isNotEmpty ||
        activeCountries.isNotEmpty ||
        onlyHighlighted ||
        followedTeachers.isNotEmpty;
  }

  resetActiveEventsFromFilter() {
    List<EventModel> returnEvents = initialEvents;

    if (onlyHighlighted) {
      returnEvents = returnEvents
          .where((EventModel event) => event.isHighlighted == true)
          .toList();
    }

    if (followedTeachers.isNotEmpty) {
      returnEvents = returnEvents.where((EventModel event) {
        if (event.teachers == null ||
            event.teachers!.isEmpty ||
            followedTeachers.isEmpty) {
          return false;
        }

        for (TeacherModel eventTeacher in event.teachers!) {
          for (TeacherModel followTeacher in followedTeachers) {
            if (eventTeacher.id == followTeacher.id) {
              return true;
            }
          }
        }
        return false;
      }).toList();
    }

    if (activeCountries.isNotEmpty) {
      returnEvents = returnEvents
          .where((EventModel event) =>
              activeCountries.contains(event.locationCountry))
          .toList();
    }

    if (activeCategories.isNotEmpty) {
      returnEvents = returnEvents
          .where(
              (EventModel event) => activeCategories.contains(event.eventType))
          .toList();
    }
    if (activeDates.isNotEmpty) {
      returnEvents = returnEvents
          .where((EventModel event) =>
              isDateMonthAndYearInList(
                  activeDates, DateTime.parse(event.startDate!)) ||
              isDateMonthAndYearInList(
                  activeDates, DateTime.parse(event.endDate!)))
          // activeDates.contains(event.startDate!).month) ||
          // activeDates.contains(DateTime.parse(event.endDate!).month))
          .toList();
    }

    activeEvents = returnEvents;
    notifyListeners();
  }
}
