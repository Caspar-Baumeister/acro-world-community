import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';

class TeacherEventsProvider extends ChangeNotifier {
  // loads and keeps track of events that are created by me or where I'm taking place in.

  bool _loading = true;
  final List<ClassModel> _myCreatedEvents = [];
  final List<ClassModel> _myParticipatingEvents = [];
  final int _limit = 10;
  int _offsetMyEvent = 0;
  int _offsetParticipatingEvent = 0;

  bool _isLoadingMyEvents = false;
  bool _isLoadingParticipatingEvents = false;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // getter for loading
  bool get loading => _loading;
  List<ClassModel> get myCreatedEvents => _myCreatedEvents;
  List<ClassModel> get myParticipatingEvents => _myParticipatingEvents;

  // are there more classes to fetch
  bool get isLoadingMyEvents => _isLoadingMyEvents;
  bool get isLoadingParticipatingEvents => _isLoadingParticipatingEvents;

  // can fetch more classes
  bool canFetchMoreMyEvents = true;
  bool canFetchMoreParticipatingEvents = true;

  // fetch data init
  TeacherEventsProvider() {
    _loading = true;
    notifyListeners();
  }

  // fetch more data
  Future<void> fetchMore(String userId, {bool myEvents = true}) async {
    if (myEvents) {
      _isLoadingMyEvents = true;
      _offsetMyEvent += _limit;
    } else {
      _isLoadingParticipatingEvents = true;
      _offsetParticipatingEvent += _limit;
    }
    notifyListeners();

    await fetchMyEvents(userId, isRefresh: false, myEvents: myEvents);

    myEvents
        ? _isLoadingMyEvents = false
        : _isLoadingParticipatingEvents = false;
    notifyListeners();
  }

  // fetch classevents from the backend in a certain radius of the location
  Future<void> fetchMyEvents(String userId,
      {bool isRefresh = true, bool myEvents = true}) async {
    _isInitialized = true;
    _loading = true;
    if (isRefresh) {
      if (myEvents) {
        _offsetMyEvent = 0;
        canFetchMoreMyEvents = true;
        _myCreatedEvents.clear();
      } else {
        _offsetParticipatingEvent = 0;
        canFetchMoreParticipatingEvents = true;
        _myParticipatingEvents.clear();
      }
    }

    notifyListeners();

    //  class repository
    ClassesRepository classesRepository =
        ClassesRepository(apiService: GraphQLClientSingleton());

    try {
      final repositoryReturn = await classesRepository.getClassesLazyAsTeacher(
        _limit,
        myEvents ? _offsetMyEvent : _offsetParticipatingEvent,
        {
          "_or": [
            if (myEvents)
              {
                "created_by_id": {"_eq": userId}
              },
            if (myEvents)
              {
                "class_owners": {
                  "teacher": {
                    "user_id": {"_eq": userId}
                  }
                }
              },
            if (!myEvents)
              {
                "class_teachers": {
                  "teacher": {
                    "user_id": {"_eq": userId}
                  }
                }
              },
          ],
          if (!myEvents)
            "_not": {
              "created_by_id": {"_eq": userId}
            },
        },
      );

      myEvents
          ? _myCreatedEvents
              .addAll(List<ClassModel>.from(repositoryReturn["classes"]))
          : _myParticipatingEvents
              .addAll(List<ClassModel>.from(repositoryReturn["classes"]));

      // if offset and limit align with the length of the fetched events, there are no more events to fetch
      if (myEvents) {
        if (_myCreatedEvents.length < _offsetMyEvent + _limit) {
          canFetchMoreMyEvents = false;
        }
      } else {
        if (_myParticipatingEvents.length <
            _offsetParticipatingEvent + _limit) {
          canFetchMoreParticipatingEvents = false;
        }
      }
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
      // set classevents
      _loading = false;
      notifyListeners();
      return;
    }

    // set classevents
    _loading = false;
    notifyListeners();
  }

  // clean up provider
  void cleanUp() {
    _loading = true;
    _myCreatedEvents.clear();
    _myParticipatingEvents.clear();
    _offsetMyEvent = 0;
    _offsetParticipatingEvent = 0;
    canFetchMoreMyEvents = true;
    canFetchMoreParticipatingEvents = true;
    _isLoadingMyEvents = false;
    _isLoadingParticipatingEvents = false;
    _isInitialized = false;
    notifyListeners();
  }
}
