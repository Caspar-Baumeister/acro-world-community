import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';

class TeacherEventsProvider extends ChangeNotifier {
  // loads and keeps track of events that are created by me or where I'm taking place in.
  // Will
  bool _loading = true;
  final List<ClassModel> _myCreatedEvents = [];
  final List<ClassModel> _myParticipatingEvents = [];
  final int _limit = 3;
  int _offsetMyEvent = 0;
  int _offsetParticipatingEvent = 0;

  int _totalMyEvents = 0;
  int _totalParticipatingEvents = 0;

  bool _isLoadingMyEvents = false;
  bool _isLoadingParticipatingEvents = false;
  String? userId;

  // getter for loading
  bool get loading => _loading;
  List<ClassModel> get myCreatedEvents => _myCreatedEvents;
  List<ClassModel> get myParticipatingEvents => _myParticipatingEvents;

  // are there more classes to fetch
  bool get isLoadingMyEvents => _isLoadingMyEvents;
  bool get isLoadingParticipatingEvents => _isLoadingParticipatingEvents;

  // can fetch more classes
  bool get canFetchMoreMyEvents => _myCreatedEvents.length < _totalMyEvents;

  bool get canFetchMoreParticipatingEvents =>
      _myParticipatingEvents.length < _totalParticipatingEvents;

  // fetch data init
  TeacherEventsProvider() {
    _loading = true;
    notifyListeners();
  }

  // fetch more data
  Future<void> fetchMore({bool myEvents = true}) async {
    if (myEvents) {
      _isLoadingMyEvents = true;
      _offsetMyEvent += _limit;
    } else {
      _isLoadingParticipatingEvents = true;
      _offsetParticipatingEvent += _limit;
    }
    notifyListeners();

    await fetchMyEvents(isRefresh: false, myEvents: myEvents);

    myEvents
        ? _isLoadingMyEvents = false
        : _isLoadingParticipatingEvents = false;
    notifyListeners();
  }

  // fetch classevents from the backend in a certain radius of the location
  Future<void> fetchMyEvents(
      {bool isRefresh = true, bool myEvents = true}) async {
    if (isRefresh) {
      if (myEvents) {
        _offsetMyEvent = 0;
        _myCreatedEvents.clear();
        print("clearing my events");
        print(_myCreatedEvents);
      } else {
        _offsetParticipatingEvent = 0;
        _myParticipatingEvents.clear();
      }
    }

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

      // set total events
      myEvents
          ? _totalMyEvents = repositoryReturn["totalClasses"]
          : _totalParticipatingEvents = repositoryReturn["totalClasses"];
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
}