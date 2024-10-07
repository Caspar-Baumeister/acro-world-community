import 'dart:typed_data';

import 'package:acroworld/data/models/booking_option_model.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/recurrent_pattern_model.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/profile_creation_service.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:acroworld/utils/helper_functions/time_zone_api.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:latlong2/latlong.dart';

class EventCreationAndEditingProvider extends ChangeNotifier {
  // the eventCreationAndEditingProvider keeps track of the data entered by the user
  // and provides methods to save the event
  // the provider is initialized with the existing event if it is passed as an argument
  // otherwise it is initialized with an empty event
  // and keeps track of the current step of the event creation process
  int _currentPage = 0;
  bool? isSlugValid;
  bool? isSlugAvailable;
  // this bool determines if there is a event currently under construction or editing.
  // this prevents the overwriting of the event if the user clicks on create new event again
  final bool _isEventUnderConstruction = false;

  String? _errorMesssage;

  // class properties
  String? _classId;
  String _title = '';
  String _slug = '';
  String _description = '';
  String? _eventType;
  LatLng? _location;
  String? _locationDescription;
  String? _locationName;
  String? existingImageUrl;
  final List<TeacherModel> _pendingInviteTeachers = [];
  final List<RecurringPatternModel> _recurringPatterns = [];
  final List<BookingOptionModel> _bookingOptions = [];
  Uint8List? _eventImage;
  int? maxBookingSlots;

  // GETTER
  String get title => _title;
  String get slug => _slug;
  String? get eventType => _eventType;
  String get description => _description;
  LatLng? get location => _location;
  String? get locationDescription => _locationDescription;
  String? get locationName => _locationName;
  List<TeacherModel> get pendingInviteTeachers => _pendingInviteTeachers;
  List<RecurringPatternModel> get recurringPatterns => _recurringPatterns;
  List<BookingOptionModel> get bookingOptions => _bookingOptions;
  String? get errorMessage => _errorMesssage;

  void addRecurringPattern(RecurringPatternModel pattern) {
    _recurringPatterns.add(pattern);
    notifyListeners();
  }

  void editRecurringPattern(int index, RecurringPatternModel pattern) {
    _recurringPatterns[index] = pattern;
    notifyListeners();
  }

  void removeRecurringPattern(int index) {
    _recurringPatterns.removeAt(index);
    notifyListeners();
  }

  void addBookingOption(BookingOptionModel option) {
    _bookingOptions.add(option);
    notifyListeners();
  }

  void editBookingOption(int index, BookingOptionModel option) {
    _bookingOptions[index] = option;
    notifyListeners();
  }

  void removeBookingOption(int index) {
    _bookingOptions.removeAt(index);
    notifyListeners();
  }

  void addPendingInviteTeacher(TeacherModel teacher) {
    _pendingInviteTeachers.add(teacher);
    notifyListeners();
  }

  void removePendingInviteTeacher(String teacherId) {
    _pendingInviteTeachers.removeWhere((element) => element.id == teacherId);
    notifyListeners();
  }

  void setLocationName(String locationName) {
    _locationName = locationName;
    notifyListeners();
  }

  void setLocationDescription(String locationDescription) {
    _locationDescription = locationDescription;
    notifyListeners();
  }

  void setLocation(LatLng location) {
    _location = location;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    notifyListeners();
  }

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setEventType(String? eventType) {
    _eventType = eventType;
    notifyListeners();
  }

  void setSlug(String slug) {
    _slug = slug;
    notifyListeners();
  }

  // get amount of followers from all teachers combined
  int get amountOfFollowers {
    int amount = 0;
    for (var teacher in _pendingInviteTeachers) {
      amount += (teacher.likes ?? 0).toInt();
    }
    return amount;
  }

  // get current page
  int get currentPage => _currentPage;
  Uint8List? get eventImage => _eventImage;
  bool get isEventUnderConstruction => _isEventUnderConstruction;

  EventCreationAndEditingProvider();

  // change page
  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setEventImage(Uint8List image) {
    _eventImage = image;
    notifyListeners();
  }

  Future<void> checkSlugAvailability() async {
    isSlugAvailable = true;
    isSlugValid = true;
    if (slug.isEmpty || slug.contains(RegExp(r'[^a-z0-9-]'))) {
      isSlugValid = false;
      notifyListeners();
      return;
    }

    final client = GraphQLClientSingleton().client;

    const String query = """
    query CheckSlugAvailability(\$url_slug: String!) {
      is_event_slug_available(url_slug: \$url_slug)
    }
    """;

    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(query),
        variables: {'url_slug': slug},
      ),
    );

    if (result.hasException) {
      isSlugAvailable = false;
      notifyListeners();
      return;
    }

    final bool isAvailable = result.data?['is_event_slug_available'] ?? false;

    isSlugAvailable = isAvailable;
    notifyListeners();
  }

  void clear() {
    _title = '';
    _slug = '';
    _description = '';
    _eventType = null;
    _location = null;
    _locationDescription = null;
    _locationName = null;
    _pendingInviteTeachers.clear();
    _recurringPatterns.clear();
    _bookingOptions.clear();
    _eventImage = null;
    _currentPage = 0;
    notifyListeners();
  }

  Future<void> createClass() async {
    try {
      List<Map<String, dynamic>> classTeachers = [];
      List<Map<String, dynamic>> classOwners = [];

      for (var teacher in pendingInviteTeachers) {
        classTeachers.add({'teacher_id': teacher.id, 'is_owner': false});
      }

      // Convert recurring patterns to JSON format
      final List<Map<String, dynamic>> recurringPatternsJson =
          _recurringPatterns.map((pattern) => pattern.toJson()).toList();

      final List<Map<String, dynamic>> bookingOptionsJson =
          _bookingOptions.map((option) => option.toMap()).toList();

      String? imageUrl = await _uploadEventImage();
      // get timezone with default value to germany
      String? timezone = await getTimezone(
          _location?.latitude ?? 51.1657, _location?.longitude ?? 10.4515);

      Map<String, dynamic> variables = {
        'name': _title,
        'description': _description,
        'imageUrl': imageUrl,
        'eventType': _eventType ?? 'Trainings',
        'location': [
          _location?.longitude,
          _location?.latitude,
        ],
        'locationName': _locationName,
        'timezone': timezone,
        'urlSlug': _slug,
        'recurringPatterns': recurringPatternsJson,
        'classBookingOptions': bookingOptionsJson,
        'classOwners': classOwners,
        'classTeachers': classTeachers,
        'max_booking_slots': maxBookingSlots
      };
      ClassesRepository classesRepository =
          ClassesRepository(apiService: GraphQLClientSingleton());
      classesRepository.createClass(variables);
    } catch (e) {
      CustomErrorHandler.captureException("Error creating class: $e");
      _errorMesssage = e.toString();
    }
  }

  Future<void> updateClass() async {
    try {
      List<Map<String, dynamic>> classTeachers = [];
      List<Map<String, dynamic>> classOwners = [];

      for (var teacher in pendingInviteTeachers) {
        classTeachers.add({'teacher_id': teacher.id, 'is_owner': false});
      }

      if (_classId == null) {
        throw Exception(
            'The class id is missing, delete the class and create a new one');
      }

      // Convert recurring patterns to JSON format
      final List<Map<String, dynamic>> recurringPatternsJson =
          _recurringPatterns.map((pattern) => pattern.toJson()).toList();

      final List<Map<String, dynamic>> bookingOptionsJson =
          _bookingOptions.map((option) => option.toMap()).toList();
      String? imageUrl;
      if (_eventImage == null && existingImageUrl != null) {
        imageUrl = existingImageUrl;
      } else if (_eventImage != null) {
        imageUrl = await _uploadEventImage();
      } else {
        throw Exception('No image was provided');
      }
      // get timezone with default value to germany
      String? timezone = await getTimezone(
          _location?.latitude ?? 51.1657, _location?.longitude ?? 10.4515);

      Map<String, dynamic> variables = {
        'id': _classId,
        'name': _title,
        'description': _description,
        'imageUrl': imageUrl,
        'eventType': _eventType ?? 'Trainings',
        'location': [
          _location?.longitude,
          _location?.latitude,
        ],
        'locationName': _locationName,
        'timezone': timezone,
        'urlSlug': _slug,
        'recurringPatterns': recurringPatternsJson,
        'classBookingOptions': bookingOptionsJson,
        'classOwners': classOwners,
        'classTeachers': classTeachers,
        'max_booking_slots': maxBookingSlots
      };

      print("variables: $variables");
      ClassesRepository classesRepository =
          ClassesRepository(apiService: GraphQLClientSingleton());
      classesRepository.updateClass(variables);
    } catch (e) {
      CustomErrorHandler.captureException("Error updating class: $e");
      _errorMesssage = e.toString();
    }
  }

  Future<String?> _uploadEventImage() async {
    if (_eventImage == null) {
      CustomErrorHandler.captureException("event image was null");
      return null;
    }
    return await ImageUploadService().uploadImage(_eventImage!,
        path: 'event_images/${DateTime.now().millisecondsSinceEpoch}.png');
  }

  Future<void> setClassFromExisting(String slug) async {
    // clear existing data
    clear();
    // pull class data from database
    ClassesRepository classesRepository =
        ClassesRepository(apiService: GraphQLClientSingleton());

    ClassModel? fromClass;
    try {
      final repositoryReturnClass =
          await classesRepository.getClassBySlug(slug);

      fromClass = repositoryReturnClass;

      // set recurrent patterns

      _title = fromClass.name ?? '';
      _slug = "${fromClass.urlSlug ?? ''}-1";
      _description = fromClass.description ?? '';
      _eventType = fromClass.eventType != null
          ? mapEventTypeToString(fromClass.eventType!)
          : null;
      _location = fromClass.location?.toLatLng();
      _locationDescription = _location != null ? fromClass.locationName : null;
      _locationName = fromClass.locationName;
      maxBookingSlots = fromClass.maxBookingSlots;
      existingImageUrl = fromClass.imageUrl;
      _recurringPatterns.clear();
      _recurringPatterns.addAll(fromClass.recurringPatterns ?? []);
      _pendingInviteTeachers.clear();
      _pendingInviteTeachers.addAll(fromClass.teachers);
      _classId = fromClass.id;
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
    }

    notifyListeners();
  }
}
