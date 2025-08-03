import 'dart:typed_data';

import 'package:acroworld/data/graphql/input/booking_category_input.dart';
import 'package:acroworld/data/graphql/input/booking_option_input.dart';
import 'package:acroworld/data/graphql/input/class_owner_input.dart';
import 'package:acroworld/data/graphql/input/class_teacher_input.dart';
import 'package:acroworld/data/graphql/input/class_upsert_input.dart';
import 'package:acroworld/data/graphql/input/multiple_choice_input.dart';
import 'package:acroworld/data/graphql/input/question_input.dart';
import 'package:acroworld/data/graphql/input/recurring_patterns_input.dart';
import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/data/models/recurrent_pattern_model.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/data/repositories/event_forms_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/profile_creation_service.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:acroworld/utils/helper_functions/country_helpers.dart';
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
  String? country;
  String? countryCode;
  String? locationCity;
  String? _classId;
  String _title = '';
  String _urlSlug = '';
  String _description = '';
  String? _eventType;
  LatLng? _location;
  String? _locationDescription;
  String? _locationName;
  String? existingImageUrl;
  final List<TeacherModel> _pendingInviteTeachers = [];
  final List<ClassTeacher> _classTeachers = [];
  final List<RecurringPatternModel> oldRecurringPatterns = [];
  final List<RecurringPatternModel> _recurringPatterns = [];
  final List<BookingOption> _bookingOptions = [];
  final List<BookingOption> oldBookingOptions = [];
  final List<BookingCategoryModel> bookingCategories = [];
  final List<BookingCategoryModel> oldBookingCategories = [];
  final List<QuestionModel> oldQuestions = [];
  final List<QuestionModel> _questions = [];
  final List<ClassOwnerInput> _classOwner = [];
  Uint8List? _eventImage;
  int? maxBookingSlots = 0;
  bool isCashAllowed = false;
  bool _isEdit = false;

  // GETTER
  String get title => _title;
  String get slug => _urlSlug;
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

  void setCountry(String? country) {
    this.country = country;
    notifyListeners();
  }

  void setRegion(String? region) {
    locationCity = region;
    notifyListeners();
  }

  void setSlug(String slug) {
    _urlSlug = slug;
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

  void switchAllowCashPayments() {
    isCashAllowed = !isCashAllowed;
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
    _urlSlug = '';
    _description = '';
    country = null;
    locationCity = null;
    countryCode = null;
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

  Future<void> upsertClass(String creatorId) async {
    String? timezone = await getTimezone(
        _location?.latitude ?? 51.1657, _location?.longitude ?? 10.4515);

    final newClassTeachers = _pendingInviteTeachers
        .map(
          (teacher) => ClassTeacherInput(
            id: _classTeachers
                    .where((classTeacher) =>
                        classTeacher.teacher?.id == teacher.id)
                    .firstOrNull
                    ?.id ??
                Uuid().v4(),
            teacherId: teacher.id!,
          ),
        )
        .toList();

    final List<String> bookingOptionIdsToDelete = _isEdit
        ? oldBookingOptions
            .where((oldOption) => !_bookingOptions
                .any((newOption) => newOption.id == oldOption.id))
            .map((bookingOption) => bookingOption.id!)
            .toList()
        : [];

    final List<String> bookingCategoryIdsToDelete = _isEdit
        ? oldBookingCategories
            .where((oldCategory) => !bookingCategories
                .any((newCategory) => newCategory.id == oldCategory.id))
            .map((category) => category.id!)
            .toList()
        : [];

    final List<String> recurringPatternIdsToDelete = _isEdit
        ? oldRecurringPatterns
            .where((oldPattern) => !_recurringPatterns
                .any((newPattern) => newPattern.id == oldPattern.id))
            .map((pattern) => pattern.id!)
            .toList()
        : [];

    final List<String> deleteClassTeacherIds = _isEdit
        ? _classTeachers
            .where((oldClassTeacher) => !newClassTeachers.any(
                (newClassTeacher) => newClassTeacher.id == oldClassTeacher.id))
            .map((classTeacher) => classTeacher.id!)
            .toList()
        : [];

    final List<String> questionIdsToDelete = _isEdit
        ? oldQuestions
            .where((oldQuestion) => !_questions
                .any((newQuestion) => newQuestion.id == oldQuestion.id))
            .map((question) => question.id!)
            .toList()
        : [];

    print('_classOwner $_classOwner');
    print('_isEdit $_isEdit');

    final classUpsertInput = ClassUpsertInput(
        id: _classId ?? Uuid().v4(),
        name: _title,
        description: _description,
        imageUrl: await _uploadImage(),
        isCashAllowed: isCashAllowed,
        eventType: eventType,
        timezone: timezone,
        urlSlug: _urlSlug,
        location: location!,
        locationName: _locationName,
        locationCity: locationCity,
        locationCountry: country,
        recurringPatterns: _recurringPatterns
            .map((pattern) => RecurringPatternInput(
                id: pattern.id ?? Uuid().v4(),
                dayOfWeek: pattern.dayOfWeek,
                startDate: pattern.startDate!.toIso8601String(),
                endDate: pattern.endDate?.toIso8601String(),
                startTime: _timeStringFromTimeOfDay(pattern.startTime),
                endTime: _timeStringFromTimeOfDay(pattern.endTime),
                recurringEveryXWeeks: pattern.recurringEveryXWeeks,
                isRecurring: pattern.isRecurring ?? false))
            .toList(),
        classOwners: _classOwner.lastOrNull != null && !_isEdit
            ? [_classOwner.last]
            : [],
        classTeachers: _pendingInviteTeachers
            .map(
              (teacher) => ClassTeacherInput(
                id: _classTeachers
                        .where((classTeacher) =>
                            classTeacher.teacher?.id == teacher.id)
                        .firstOrNull
                        ?.id ??
                    Uuid().v4(),
                teacherId: teacher.id!,
              ),
            )
            .toList(),
        bookingCategories: bookingCategories.map((category) {
          final bookingCategoryId = category.id ?? Uuid().v4();
          return BookingCategoryInput(
              id: bookingCategoryId,
              name: category.name,
              contingent: category.contingent,
              description: category.description ?? '',
              bookingOptions: bookingOptions
                  .where((option) => option.bookingCategoryId == category.id)
                  .map(
                    (bookingOption) => BookingOptionInput(
                      id: bookingOption.id ?? Uuid().v4(),
                      title: bookingOption.title ?? '',
                      subtitle: bookingOption.subtitle ?? '',
                      price: bookingOption.price ?? 0,
                      discount: bookingOption.discount ?? 0,
                      currency: bookingOption.currency.value,
                    ),
                  )
                  .toList());
        }).toList(),
        questions: List.generate(_questions.length, (i) {
          final question = _questions[i];
          return QuestionInput(
            id: question.id ?? Uuid().v4(),
            allowMultipleAnswers: question.isMultipleChoice ?? false,
            isRequired: question.isRequired ?? false,
            position: i,
            question: question.question ?? '',
            title: question.title ?? '',
            questionType: question.type ?? QuestionType.text,
            multipleChoiceOptions: question.choices != null
                ? List.generate(question.choices!.length, (j) {
                    final choice = question.choices![j];
                    return MultipleChoiceOptionInput(
                      id: choice.id ?? Uuid().v4(),
                      optionText: choice.optionText ?? '',
                      position: j,
                    );
                  })
                : [],
          );
        }));

    ClassesRepository classesRepository =
        ClassesRepository(apiService: GraphQLClientSingleton());
    final createdClass = await classesRepository.upsertClass(
      classUpsertInput,
      questionIdsToDelete,
      recurringPatternIdsToDelete,
      deleteClassTeacherIds,
      bookingOptionIdsToDelete,
      bookingCategoryIdsToDelete,
    );

    print('createdClass $createdClass');
  }

  String _timeStringFromTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00'; // Assuming seconds are always 00
  }

  Future<String> _uploadImage() async {
    String? imageUrl;
    if (_eventImage == null && existingImageUrl != null) {
      imageUrl = existingImageUrl;
    } else if (_eventImage != null) {
      imageUrl = await _uploadEventImage();
    } else {
      throw Exception('No image was provided');
    }
    return imageUrl!;
  }

  Future<String?> _uploadEventImage() async {
    if (_eventImage == null) {
      CustomErrorHandler.captureException("event image was null");
      return null;
    }
    return await ImageUploadService().uploadImage(_eventImage!,
        path: 'event_images/${DateTime.now().millisecondsSinceEpoch}.png');
  }

  Future<void> setClassFromExisting(String slug, bool isEditing,
      bool setFromTemplate, String creatorId) async {
    print(
        'setClassFromExisting $slug, $isEditing, $setFromTemplate, $creatorId');
    // clear existing data
    clear();
    // pull class data from database
    ClassesRepository classesRepository =
        ClassesRepository(apiService: GraphQLClientSingleton());

    // get the question repo
    EventFormsRepository eventFormsRepository =
        EventFormsRepository(apiService: GraphQLClientSingleton());
    ClassModel? fromClass;
    _isEdit = isEditing;

    try {
      final repositoryReturnClass =
          await classesRepository.getClassBySlug(slug);
      fromClass = repositoryReturnClass;

      _title = fromClass.name ?? '';
      _urlSlug = isEditing ? fromClass.urlSlug ?? '' : '';
      _description = fromClass.description ?? '';
      country = fromClass.country;

      locationCity = fromClass.city;
      countryCode = getCountryCode(fromClass.country);
      _eventType = fromClass.eventType != null
          ? mapEventTypeToString(fromClass.eventType!)
          : null;
      _location = fromClass.location?.toLatLng();
      _locationDescription = _location != null ? fromClass.locationName : null;
      _locationName = fromClass.locationName;
      maxBookingSlots = fromClass.maxBookingSlots;
      existingImageUrl = fromClass.imageUrl;
      isCashAllowed = fromClass.isCashAllowed ?? false;
      _recurringPatterns.clear();
      _recurringPatterns.addAll(fromClass.recurringPatterns ?? []);

      _classTeachers.addAll(fromClass.classTeachers ?? []);

      final questions =
          await eventFormsRepository.getQuestionsForEvent(fromClass.id!);
      // get categories and save them in old and new categories
      final categories =
          await classesRepository.getBookingCategoriesForEvent(fromClass.id!);
      if (setFromTemplate) {
        for (var recurringPattern in _recurringPatterns) {
          recurringPattern.id = null;
        }
        for (var question in questions) {
          question.id = null;
        }

        for (var category in categories) {
          category.id = null;
          if (category.bookingOptions != null) {
            for (var bookingOption in category.bookingOptions!) {
              bookingOption.id = null;
            }
          }
        }

        for (var classTeacher in _classTeachers) {
          classTeacher.id = null;
        }

        _classOwner.clear();
      } else {
        _classId = fromClass.id;
      }

      oldRecurringPatterns.addAll(_recurringPatterns);

      _pendingInviteTeachers.clear();
      _pendingInviteTeachers.addAll(fromClass.teachers);

      print('_classOwner $_classOwner');

      if (_classOwner.isEmpty) {
        _classOwner.add(ClassOwnerInput(
          id: Uuid().v4(),
          teacherId: creatorId,
          isPaymentReceiver: true,
        ));
      } else {
        _classOwner.add(fromClass.classOwner!
            .map(
              (classOwner) => ClassOwnerInput(
                id: setFromTemplate ? Uuid().v4() : classOwner.id!,
                teacherId: classOwner.teacher!.id!,
                isPaymentReceiver: classOwner.isPaymentReceiver!,
              ),
            )
            .toList()[0]);
      }

      // get questions and save them in old and new questions

      if (!isEditing) {
        for (var question in questions) {
          question.id = Uuid().v4();
        }
      }

      oldQuestions.addAll(questions);
      _questions.addAll(questions);

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
