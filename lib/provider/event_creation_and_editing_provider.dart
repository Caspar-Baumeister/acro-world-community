import 'dart:typed_data';

import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/data/models/recurrent_pattern_model.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/data/repositories/bookings_repository.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/data/repositories/event_forms_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/profile_creation_service.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:acroworld/utils/helper_functions/time_zone_api.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

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
  final List<BookingOption> _bookingOptions = [];
  final List<BookingOption> oldBookingOptions = [];
  final List<BookingCategoryModel> bookingCategories = [];
  final List<BookingCategoryModel> oldBookingCategories = [];
  final List<QuestionModel> oldQuestions = [];
  final List<QuestionModel> _questions = [];
  Uint8List? _eventImage;
  int? maxBookingSlots = 0;

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
  List<BookingOption> get bookingOptions => _bookingOptions;
  String? get errorMessage => _errorMesssage;
  List<QuestionModel> get questions => _questions;

  // SETTER //

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

  void addBookingOption(BookingOption option) {
    _bookingOptions.add(option);
    notifyListeners();
  }

  void editBookingOption(int index, BookingOption option) {
    _bookingOptions[index] = option;
    notifyListeners();
  }

  void removeBookingOption(int index) {
    _bookingOptions.removeAt(index);
    notifyListeners();
  }

  void addCategory(BookingCategoryModel category) {
    bookingCategories.add(category);
    notifyListeners();
  }

  void removeCategory(int index) {
    bookingCategories.removeAt(index);
    notifyListeners();
  }

  void editCategory(int index, BookingCategoryModel category) {
    bookingCategories[index] = category;
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

  // add question to list
  void addQuestion(QuestionModel question) {
    _questions.add(question);
    notifyListeners();
  }

  // remove question from list
  void removeQuestion(int index) {
    _questions.removeAt(index);
    notifyListeners();
  }

  // edit question in list
  void editQuestion(String id, QuestionModel question) {
    int index = _questions.indexWhere((question) => question.id == id);
    _questions[index] = question;
    notifyListeners();
  }

  // reorderQuestions oldIndex to newIndex
  void reorderQuestions(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _questions.removeAt(oldIndex);
    _questions.insert(newIndex, item);
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

    // check if slug is valid format
    if (slug.isEmpty || slug.contains(RegExp(r'[^a-z0-9-]'))) {
      isSlugValid = false;
      notifyListeners();
      return;
    }

    final client = GraphQLClientSingleton().client;

    try {
      const String query = """
    query CheckSlugAvailability(\$url_slug: String!) {
      is_class_slug_available(url_slug: \$url_slug)
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

      final bool isAvailable = result.data?['is_class_slug_available'] ?? false;

      print("checkt slug availability: $isAvailable");

      isSlugAvailable = isAvailable;
    } catch (e) {
      CustomErrorHandler.captureException(
          "Error checking slug availability: $e");
      isSlugAvailable = false;
    }
    notifyListeners();
  }

  void clear() {
    _classId = null;
    _title = '';
    _slug = '';
    _description = '';
    _eventType = null;
    _location = null;
    _locationDescription = null;
    _locationName = null;
    _pendingInviteTeachers.clear();
    _recurringPatterns.clear();
    existingImageUrl = null;
    _errorMesssage = null;
    _recurringPatterns.clear();
    _eventImage = null;
    _currentPage = 0;
    bookingCategories.clear();
    oldBookingCategories.clear();
    _questions.clear();
    oldQuestions.clear();
    _bookingOptions.clear();
    oldBookingOptions.clear();

    notifyListeners();
  }

  Future<void> createClass(String creatorId) async {
    try {
      List<Map<String, dynamic>> classTeachers = [];
      List<Map<String, dynamic>> classOwners = [];

      for (var teacher in pendingInviteTeachers) {
        classTeachers.add({'teacher_id': teacher.id, 'is_owner': false});
      }

      int maxBookingSlots = 0;
      // if a ticket was added, add the owner as a class owner with is_payment_receiver set to true
      if (bookingCategories.isNotEmpty) {
        classOwners.add({'teacher_id': creatorId, 'is_payment_receiver': true});
        // set max booking slots to the combined number of continguents of the categories
        for (var category in bookingCategories) {
          maxBookingSlots += category.contingent;
        }
      }

      // Convert recurring patterns to JSON format
      final List<Map<String, dynamic>> recurringPatternsJson =
          _recurringPatterns.map((pattern) => pattern.toJson()).toList();

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
        'classOwners': classOwners,
        'classTeachers': classTeachers,
        'max_booking_slots': maxBookingSlots == 0 ? null : maxBookingSlots,
      };

      ClassesRepository classesRepository =
          ClassesRepository(apiService: GraphQLClientSingleton());
      final createdClass = await classesRepository.createClass(variables);

      // create the categories
      if (bookingCategories.isNotEmpty) {
        try {
          ClassesRepository classesRepository =
              ClassesRepository(apiService: GraphQLClientSingleton());
          // convert questions to JSON format and add the event id from the created class
          List<Map<String, dynamic>> categoriesJson = bookingCategories
              .map((BookingCategoryModel category) =>
                  category.toJson(createdClass.id!))
              .toList();
          await classesRepository.insertBookingCategories(categoriesJson);
        } catch (e) {
          CustomErrorHandler.captureException("Error creating categories: $e");
        }
      }

      // create the booking options
      if (_bookingOptions.isNotEmpty) {
        try {
          BookingsRepository bookingsRepository =
              BookingsRepository(apiService: GraphQLClientSingleton());
          // convert questions to JSON format and add the event id from the created class
          List<Map<String, dynamic>> bookingOptionsJson = _bookingOptions
              .map((BookingOption bookingOption) => bookingOption.toJson())
              .toList();
          await bookingsRepository.insertBookingOptions(bookingOptionsJson);
        } catch (e) {
          CustomErrorHandler.captureException(
              "Error creating booking options: $e");
        }
      }

      // if successful, add the questions
      if (_questions.isNotEmpty) {
        try {
          EventFormsRepository eventFormsRepository =
              EventFormsRepository(apiService: GraphQLClientSingleton());
          // convert questions to JSON format and add the event id from the created class
          List<Map<String, dynamic>> questionsJson = _questions
              .map((question) => question.toJson(
                  createdClass.id!, _questions.indexOf(question)))
              .toList();
          await eventFormsRepository.insertQuestions(questionsJson);
        } catch (e) {
          CustomErrorHandler.captureException("Error creating questions: $e");
        }
      }
      clear();
    } catch (e) {
      CustomErrorHandler.captureException("Error creating class: $e");
      _errorMesssage = e.toString();
    }
  }

  Future<void> updateClass(String creatorId) async {
    try {
      List<Map<String, dynamic>> classTeachers = [];
      List<Map<String, dynamic>> classOwners = [];

      for (var teacher in pendingInviteTeachers) {
        classTeachers.add({'teacher_id': teacher.id, 'is_owner': false});
      }

      int maxBookingSlots = 0;
      // if a ticket was added, add the owner as a class owner with is_payment_receiver set to true
      if (bookingCategories.isNotEmpty) {
        classOwners.add({'teacher_id': creatorId, 'is_payment_receiver': true});
        // set max booking slots to the combined number of continguents of the categories
        for (var category in bookingCategories) {
          maxBookingSlots += category.contingent;
        }
      }

      if (_classId == null) {
        throw Exception(
            'The class id is missing, delete the class and create a new one');
      }

      // Convert recurring patterns to JSON format
      final List<Map<String, dynamic>> recurringPatternsJson =
          _recurringPatterns.map((pattern) => pattern.toJson()).toList();

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
        'classOwners': classOwners,
        'classTeachers': classTeachers,
        'max_booking_slots': maxBookingSlots == 0 ? null : maxBookingSlots,
      };

      ClassesRepository classesRepository =
          ClassesRepository(apiService: GraphQLClientSingleton());
      classesRepository.updateClass(variables);

      // if successful, update the questions
      try {
        EventFormsRepository eventFormsRepository =
            EventFormsRepository(apiService: GraphQLClientSingleton());
        // convert questions to JSON format and add the event id from the created class

        await eventFormsRepository.identifyQuestionUpdates(
            _questions, oldQuestions, _classId!);
      } catch (e, s) {
        CustomErrorHandler.captureException("Error updating questions: $e",
            stackTrace: s);
      }

      // if successful, update the categories
      try {
        ClassesRepository classesRepository =
            ClassesRepository(apiService: GraphQLClientSingleton());

        await classesRepository.identifyBookingCategoryUpdates(
            bookingCategories, oldBookingCategories, _classId!);
      } catch (e) {
        CustomErrorHandler.captureException("Error updating categories: $e");
      }

      print("class id: $_classId");

      // if successful, update the booing options
      try {
        BookingsRepository bookingsRepository =
            BookingsRepository(apiService: GraphQLClientSingleton());
        await bookingsRepository.identifyBookingOptionUpdates(
            _bookingOptions, oldBookingOptions);
      } catch (e) {
        CustomErrorHandler.captureException(
            "Error updating booking options: $e");
      }

      clear();
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

  Future<void> setClassFromExisting(String slug, bool isEditing) async {
    // clear existing data
    clear();
    // pull class data from database
    ClassesRepository classesRepository =
        ClassesRepository(apiService: GraphQLClientSingleton());

    // get the question repo
    EventFormsRepository eventFormsRepository =
        EventFormsRepository(apiService: GraphQLClientSingleton());
    ClassModel? fromClass;
    try {
      final repositoryReturnClass =
          await classesRepository.getClassBySlug(slug);
      fromClass = repositoryReturnClass;
      _title = fromClass.name ?? '';
      _slug = isEditing ? fromClass.urlSlug ?? '' : '';
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

      // get questions and save them in old and new questions
      final questions =
          await eventFormsRepository.getQuestionsForEvent(fromClass.id!);

      if (!isEditing) {
        for (var question in questions) {
          question.id = Uuid().v4();
        }
      }

      oldQuestions.addAll(questions);
      _questions.addAll(questions);

      // get categories and save them in old and new categories
      final categories =
          await classesRepository.getBookingCategoriesForEvent(fromClass.id!);

      if (!isEditing) {
        for (var category in categories) {
          final newCategoryId = Uuid().v4();
          category.id = newCategoryId;
          category.classId = null;
          for (BookingOption option in category.bookingOptions ?? []) {
            option.id = Uuid().v4();
            option.bookingCategoryId = newCategoryId;
          }
        }
      }

      oldBookingCategories.addAll(categories);
      bookingCategories.addAll(categories);
      for (var category in categories) {
        _bookingOptions.addAll(category.bookingOptions ?? []);
        oldBookingOptions.addAll(category.bookingOptions ?? []);
      }
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
    }

    notifyListeners();
  }
}
