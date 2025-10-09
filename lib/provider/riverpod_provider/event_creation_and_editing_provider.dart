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
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/data/models/recurrent_pattern_model.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:acroworld/utils/helper_functions/country_helpers.dart';
import 'package:acroworld/utils/validation/event_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

/// State for event creation and editing
class EventCreationAndEditingState {
  final int currentPage;
  final bool? isSlugValid;
  final ClassModel? classModel;
  final List<BookingCategoryModel> bookingCategories;
  final List<BookingOption> bookingOptions;
  final List<QuestionModel> questions;
  final List<QuestionModel> oldQuestions;
  final String title;
  final String slug;
  final String description;
  final String? locationName;
  final Uint8List? eventImage;
  final String? existingImageUrl;
  final bool? isSlugAvailable;
  final LatLng? location;
  final String? locationDescription;
  final String? countryCode;
  final String? region;
  final String? eventType;
  final bool isCashAllowed;
  final bool isEditing;
  final List<TeacherModel> pendingInviteTeachers;
  final List<String> pendingEmailInvites;
  final int? maxBookingSlots;
  final List<RecurringPatternModel> recurringPatterns;
  final RecurringPatternModel? recurrentPattern;
  final bool isLoading;
  final String? errorMessage;

  const EventCreationAndEditingState({
    this.currentPage = 0,
    this.isSlugValid,
    this.classModel,
    this.bookingCategories = const [],
    this.bookingOptions = const [],
    this.questions = const [],
    this.oldQuestions = const [],
    this.title = '',
    this.slug = '',
    this.description = '',
    this.locationName,
    this.eventImage,
    this.existingImageUrl,
    this.isSlugAvailable,
    this.location,
    this.locationDescription,
    this.countryCode,
    this.region,
    this.eventType,
    this.isCashAllowed = false,
    this.isEditing = false,
    this.pendingInviteTeachers = const [],
    this.pendingEmailInvites = const [],
    this.maxBookingSlots,
    this.recurringPatterns = const [],
    this.recurrentPattern,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Get amount of followers from pending invite teachers
  int get amountOfFollowers {
    int amount = 0;
    for (var teacher in pendingInviteTeachers) {
      amount += (teacher.likes ?? 0).toInt();
    }
    return amount;
  }

  EventCreationAndEditingState copyWith({
    int? currentPage,
    bool? isSlugValid,
    ClassModel? classModel,
    List<BookingCategoryModel>? bookingCategories,
    List<BookingOption>? bookingOptions,
    List<QuestionModel>? questions,
    List<QuestionModel>? oldQuestions,
    String? title,
    String? slug,
    String? description,
    String? locationName,
    Uint8List? eventImage,
    String? existingImageUrl,
    bool? isSlugAvailable,
    LatLng? location,
    String? locationDescription,
    String? countryCode,
    String? region,
    String? eventType,
    bool? isCashAllowed,
    bool? isEditing,
    List<TeacherModel>? pendingInviteTeachers,
    List<String>? pendingEmailInvites,
    int? maxBookingSlots,
    List<RecurringPatternModel>? recurringPatterns,
    RecurringPatternModel? recurrentPattern,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventCreationAndEditingState(
      currentPage: currentPage ?? this.currentPage,
      isSlugValid: isSlugValid ?? this.isSlugValid,
      classModel: classModel ?? this.classModel,
      bookingCategories: bookingCategories ?? this.bookingCategories,
      bookingOptions: bookingOptions ?? this.bookingOptions,
      questions: questions ?? this.questions,
      oldQuestions: oldQuestions ?? this.oldQuestions,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      locationName: locationName ?? this.locationName,
      eventImage: eventImage ?? this.eventImage,
      existingImageUrl: existingImageUrl ?? this.existingImageUrl,
      isSlugAvailable: isSlugAvailable ?? this.isSlugAvailable,
      location: location ?? this.location,
      locationDescription: locationDescription ?? this.locationDescription,
      countryCode: countryCode ?? this.countryCode,
      region: region ?? this.region,
      eventType: eventType ?? this.eventType,
      isCashAllowed: isCashAllowed ?? this.isCashAllowed,
      isEditing: isEditing ?? this.isEditing,
      pendingInviteTeachers:
          pendingInviteTeachers ?? this.pendingInviteTeachers,
      pendingEmailInvites: pendingEmailInvites ?? this.pendingEmailInvites,
      maxBookingSlots: maxBookingSlots ?? this.maxBookingSlots,
      recurringPatterns: recurringPatterns ?? this.recurringPatterns,
      recurrentPattern: recurrentPattern ?? this.recurrentPattern,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier for event creation and editing state management
class EventCreationAndEditingNotifier
    extends StateNotifier<EventCreationAndEditingState> {
  EventCreationAndEditingNotifier({ClassModel? existingEvent})
      : super(EventCreationAndEditingState(
          classModel: existingEvent ?? _createEmptyClassModel(),
        ));

  /// Create empty class model
  static ClassModel _createEmptyClassModel() {
    return ClassModel(
      id: const Uuid().v4(),
      name: '',
      description: '',
      eventType: EventType.Workshops,
      country: '',
      city: '',
      questions: [],
    );
  }

  /// Set current page
  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  /// Update class model
  void updateClassModel(ClassModel classModel) {
    state = state.copyWith(classModel: classModel);
  }

  /// Add booking category
  void addBookingCategory(BookingCategoryModel category) {
    final updatedCategories = [...state.bookingCategories, category];
    state = state.copyWith(bookingCategories: updatedCategories);
  }

  /// Remove booking category
  void removeBookingCategory(int index) {
    final updatedCategories =
        List<BookingCategoryModel>.from(state.bookingCategories);
    updatedCategories.removeAt(index);
    state = state.copyWith(bookingCategories: updatedCategories);
  }

  /// Add booking option
  void addBookingOption(BookingOption option) {
    final updatedOptions = [...state.bookingOptions, option];
    state = state.copyWith(bookingOptions: updatedOptions);
  }

  /// Remove booking option
  void removeBookingOption(int index) {
    final updatedOptions = List<BookingOption>.from(state.bookingOptions);
    updatedOptions.removeAt(index);
    state = state.copyWith(bookingOptions: updatedOptions);
  }

  /// Add question
  void addQuestion(QuestionModel question) {
    final updatedQuestions = [...state.questions, question];
    state = state.copyWith(questions: updatedQuestions);
  }

  /// Edit question in list
  void editQuestion(String id, QuestionModel question) {
    final questions = List<QuestionModel>.from(state.questions);
    final index = questions.indexWhere((q) => q.id == id);
    if (index != -1) {
      questions[index] = question;
      state = state.copyWith(questions: questions);
    }
  }

  /// Remove question
  void removeQuestion(int index) {
    final updatedQuestions = List<QuestionModel>.from(state.questions);
    updatedQuestions.removeAt(index);
    state = state.copyWith(questions: updatedQuestions);
  }

  /// Clear all data and reset to initial state
  void clear() {
    state = const EventCreationAndEditingState();
  }

  /// Set recurrent pattern
  void setRecurrentPattern(RecurringPatternModel pattern) {
    state = state.copyWith(recurrentPattern: pattern);
  }

  /// Validate slug
  Future<void> validateSlug(String slug) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Basic format validation: lowercase letters, numbers, hyphens
      final isValidFormat =
          RegExp(r'^[a-z0-9-]+$').hasMatch(slug) && slug.isNotEmpty;

      if (!isValidFormat) {
        state = state.copyWith(
          isSlugValid: false,
          isSlugAvailable: false,
          isLoading: false,
          errorMessage:
              'Slug can only contain lowercase letters, numbers, and hyphens',
        );
        return;
      }

      // Always check availability via repository
      final repository =
          ClassesRepository(apiService: GraphQLClientSingleton());
      final isAvailable = await repository.isSlugAvailable(slug);

      // Only set as valid if format is correct AND available
      final isValid = isValidFormat && isAvailable;

      state = state.copyWith(
        isSlugValid: isValid,
        isSlugAvailable: isAvailable,
        isLoading: false,
        errorMessage: isValid
            ? null
            : (isAvailable
                ? 'Invalid slug format'
                : 'This identifier is already taken'),
      );
    } catch (e) {
      CustomErrorHandler.logError('Error validating slug: $e');
      state = state.copyWith(
        isSlugValid: false,
        isSlugAvailable: false,
        isLoading: false,
        errorMessage: 'Error validating slug: ${e.toString()}',
      );
    }
  }

  /// Save event
  Future<bool> saveEvent(String creatorId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Validate event data before saving
      if (!isEventDataValid()) {
        final firstError = getFirstValidationError();
        state = state.copyWith(
          isLoading: false,
          errorMessage: firstError ?? 'Event data validation failed',
        );
        CustomErrorHandler.logError('Event validation failed: $firstError');
        return false;
      }

      // Validate slug availability for new events
      if (!state.isEditing) {
        if (state.isSlugValid != true) {
          state = state.copyWith(
            isLoading: false,
            errorMessage:
                'Please ensure slug is valid and available before saving',
          );
          CustomErrorHandler.logError('Slug not validated for new event');
          return false;
        }
      }

      if (state.isEditing) {
        await updateClass(creatorId);
      } else {
        await createClass(creatorId);
      }

      state = state.copyWith(isLoading: false);
      CustomErrorHandler.logDebug('Event saved successfully');
      return true;
    } catch (e) {
      CustomErrorHandler.logError('Error saving event: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save event: ${e.toString()}',
      );
      return false;
    }
  }

  /// Reset state
  void reset() {
    state = EventCreationAndEditingState(
      classModel: _createEmptyClassModel(),
    );
  }

  /// Reorder questions from oldIndex to newIndex
  void reorderQuestions(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final questions = List<QuestionModel>.from(state.questions);
    final item = questions.removeAt(oldIndex);
    questions.insert(newIndex, item);
    state = state.copyWith(questions: questions);
  }

  /// Set class from existing slug for template creation
  Future<void> setClassFromExisting(
      String slug, bool isEditing, bool setFromTemplate) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Fetch the class data by slug
      final repository =
          ClassesRepository(apiService: GraphQLClientSingleton());
      final classModel = await repository.getClassBySlug(slug);

      // Create a class model - preserve original data for editing, clear for template creation
      final templateClassModel = ClassModel(
        id: isEditing ? classModel.id : null, // Preserve ID for editing
        urlSlug:
            isEditing ? classModel.urlSlug : null, // Preserve slug for editing
        description: classModel.description,
        imageUrl: classModel.imageUrl,
        location: classModel.location,
        locationName: classModel.locationName,
        name: classModel.name,
        requirements: classModel.requirements,
        websiteUrl: classModel.websiteUrl,
        classTeachers: classModel.classTeachers,
        classLevels: classModel.classLevels,
        eventType: classModel.eventType,
        city: classModel.city,
        country: classModel.country,
        classEvents: isEditing
            ? classModel.classEvents
            : null, // Preserve events for editing
        questions:
            List<QuestionModel>.from(classModel.questions), // Copy questions
        bookingCategories: classModel.bookingCategories,
        classFlags: isEditing
            ? classModel.classFlags
            : null, // Preserve flags for editing
        isCashAllowed: classModel.isCashAllowed,
        createdBy: isEditing
            ? classModel.createdBy
            : null, // Preserve creator for editing
        bookingEmail: classModel.bookingEmail,
        maxBookingSlots: classModel.maxBookingSlots,
        // Note: createdAt and updatedAt are not available in ClassModel
      );

      // Copy recurring patterns directly from the fetched class (following main branch approach)
      final recurringPatternsFromClass = classModel.recurringPatterns ?? [];

      // Convert country name to country code
      // Note: templateClassModel.country might already be a country code, not a name
      String? finalCountryCode;
      if (templateClassModel.country != null &&
          templateClassModel.country!.length == 2) {
        // It's likely already a country code
        finalCountryCode = templateClassModel.country!.toUpperCase();
      } else {
        // It's likely a country name, convert to code
        final countryCode = getCountryCode(templateClassModel.country);
        finalCountryCode = countryCode ?? templateClassModel.country;
      }

      // Build booking categories and options for state
      final List<BookingCategoryModel> copiedCategories = [];
      final List<BookingOption> copiedOptions = [];

      if (classModel.bookingCategories != null) {
        for (final category in classModel.bookingCategories!) {
          // Determine category id handling
          final String newCategoryId = isEditing
              ? (category.id ?? const Uuid().v4())
              : const Uuid().v4();

          // Copy category with potentially new id
          final BookingCategoryModel newCat = BookingCategoryModel(
            id: newCategoryId,
            name: category.name,
            description: category.description,
            contingent: category.contingent,
            bookingOptions: [],
          );

          // Copy options inside
          final options = category.bookingOptions ?? [];
          for (final option in options) {
            final String newOptionId = isEditing
                ? (option.id ?? const Uuid().v4())
                : const Uuid().v4();
            final BookingOption newOpt = BookingOption(
              id: newOptionId,
              bookingCategoryId: newCategoryId,
              title: option.title,
              subtitle: option.subtitle,
              price: option.price,
              discount: option.discount,
              currency: option.currency,
            );
            copiedOptions.add(newOpt);
            newCat.bookingOptions = [...(newCat.bookingOptions ?? []), newOpt];
          }

          copiedCategories.add(newCat);
        }
      }

      // Prepare teachers list from class for pending invites/owners display
      final List<TeacherModel> copiedTeachers = classModel.classTeachers
              ?.where((classTeacher) => classTeacher.teacher != null)
              .map((classTeacher) => classTeacher.teacher!)
              .toList() ??
          [];

      state = EventCreationAndEditingState(
        classModel: templateClassModel,
        title: templateClassModel.name ?? '',
        slug: isEditing
            ? (templateClassModel.urlSlug ?? '')
            : '', // Preserve slug for editing
        description: templateClassModel.description ?? '',
        locationName: templateClassModel.locationName,
        existingImageUrl: templateClassModel.imageUrl,
        location: templateClassModel.location?.toLatLng(),
        locationDescription:
            templateClassModel.locationName, // Use locationName as description
        eventType: templateClassModel.eventType?.name,
        isCashAllowed: templateClassModel.isCashAllowed ?? false,
        isEditing: isEditing, // Set the isEditing flag
        maxBookingSlots: templateClassModel.maxBookingSlots,
        questions: List<QuestionModel>.from(templateClassModel.questions),
        bookingCategories: copiedCategories,
        bookingOptions: copiedOptions,
        pendingInviteTeachers: copiedTeachers,
        recurringPatterns: recurringPatternsFromClass,
        countryCode:
            finalCountryCode, // Use final country code (handles both name and code)
        region: templateClassModel
            .city, // Use city as region (e.g., "State of Berlin")
        isLoading: false,
        errorMessage: null,
      );

      CustomErrorHandler.logDebug(
          'Template loaded successfully from slug: $slug');
    } catch (e) {
      CustomErrorHandler.logError('Error loading template: $e');
      state = EventCreationAndEditingState(
        classModel: _createEmptyClassModel(),
        isLoading: false,
        errorMessage: 'Failed to load template: ${e.toString()}',
      );
    }
  }

  /// Update title
  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  /// Update slug
  void setSlug(String slug) {
    state = state.copyWith(slug: slug);
  }

  /// Update description
  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  /// Update location name
  void setLocationName(String? locationName) {
    state = state.copyWith(locationName: locationName);
  }

  /// Update event image
  void setEventImage(Uint8List? eventImage) {
    state = state.copyWith(eventImage: eventImage);
  }

  /// Update existing image URL
  void setExistingImageUrl(String? existingImageUrl) {
    state = state.copyWith(existingImageUrl: existingImageUrl);
  }

  /// Check slug availability (simplified version)
  Future<void> checkSlugAvailability() async {
    final slug = state.slug.trim();
    // Basic format validation: lowercase letters, numbers, hyphens
    final isValid = RegExp(r'^[a-z0-9-]+$').hasMatch(slug) && slug.isNotEmpty;
    if (!isValid) {
      state = state.copyWith(isSlugValid: false, isSlugAvailable: null);
      return;
    }

    try {
      final repository =
          ClassesRepository(apiService: GraphQLClientSingleton());
      final available = await repository.isSlugAvailable(slug);
      state = state.copyWith(isSlugValid: true, isSlugAvailable: available);
    } catch (e) {
      CustomErrorHandler.logError('Slug availability check failed: $e');
      state = state.copyWith(isSlugValid: true, isSlugAvailable: null);
    }
  }

  /// Clear slug validation state
  void clearSlugValidation() {
    state = state.copyWith(isSlugValid: null, isSlugAvailable: null);
  }

  /// Validate all event data
  Map<String, String?> validateEventData() {
    return EventValidation.validateEvent(
      title: state.title,
      slug: state.slug,
      description: state.description,
      locationName: state.locationName,
      location: state.location,
      eventType: state.eventType,
      countryCode: state.countryCode,
      region: state.region,
      image: state.eventImage,
      existingImageUrl: state.existingImageUrl,
    );
  }

  /// Check if event data is valid
  bool isEventDataValid() {
    final validations = validateEventData();
    return EventValidation.isValid(validations);
  }

  /// Get first validation error
  String? getFirstValidationError() {
    final validations = validateEventData();
    return EventValidation.getFirstError(validations);
  }

  /// Get all validation errors
  List<String> getAllValidationErrors() {
    final validations = validateEventData();
    return EventValidation.getAllErrors(validations);
  }

  /// Convert String to EventType enum
  EventType? _stringToEventType(String? eventTypeString) {
    if (eventTypeString == null) return null;

    switch (eventTypeString) {
      case 'Workshops':
        return EventType.Workshops;
      case 'FestivalsAndCons':
        return EventType.FestivalsAndCons;
      case 'Retreats':
        return EventType.Retreats;
      case 'Jams':
        return EventType.Jams;
      case 'Classes':
        return EventType.Classes;
      case 'Trainings':
        return EventType.Trainings;
      default:
        return EventType.Workshops;
    }
  }

  /// Map EventType enum to API expected values
  String _mapEventTypeToApiValue(EventType? eventType) {
    if (eventType == null) return 'Workshops';

    switch (eventType) {
      case EventType.Workshops:
        return 'Workshops';
      case EventType.FestivalsAndCons:
        return 'FestivalsAndCons';
      case EventType.Retreats:
        return 'Retreats';
      case EventType.Jams:
        return 'Jams';
      case EventType.Classes:
        return 'Classes';
      case EventType.Trainings:
        return 'Trainings';
      default:
        return 'Workshops';
    }
  }

  /// Set location
  void setLocation(LatLng? location) {
    state = state.copyWith(location: location);
  }

  /// Set location description
  void setLocationDescription(String? locationDescription) {
    state = state.copyWith(locationDescription: locationDescription);
  }

  /// Set country code
  void setCountryCode(String? countryCode) {
    state = state.copyWith(countryCode: countryCode);
  }

  /// Set country
  void setCountry(String? country) {
    // TODO: Implement country setting logic
  }

  /// Set region
  void setRegion(String? region) {
    state = state.copyWith(region: region);
  }

  /// Set event type
  void setEventType(String? eventType) {
    state = state.copyWith(eventType: eventType);
  }

  /// Set current page
  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  /// Toggle cash allowed
  void toggleCashAllowed() {
    state = state.copyWith(isCashAllowed: !state.isCashAllowed);
  }

  String _timeStringFromTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00'; // Assuming seconds are always 00
  }

  /// Create class using the working upsertClass approach
  Future<void> createClass(String creatorId) async {
    try {
      CustomErrorHandler.logDebug(
          "Starting event creation with upsertClass for creator: $creatorId");
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Import the repository
      final repository =
          ClassesRepository(apiService: GraphQLClientSingleton());

      // Create ClassOwnerInput for the creator
      final classOwner = ClassOwnerInput(
        id: const Uuid().v4(),
        teacherId: creatorId, // This is the teacher ID, not user ID
        isPaymentReceiver: true,
      );

      // Create ClassUpsertInput following the working pattern
      final classUpsertInput = ClassUpsertInput(
        id: const Uuid().v4(),
        name: state.title,
        description: state.description,
        imageUrl: state.existingImageUrl ?? '',
        timezone: 'UTC', // TODO: Get user's timezone
        urlSlug: state.slug,
        isCashAllowed: state.isCashAllowed,
        location: state.location ?? const LatLng(0.0, 0.0),
        locationName: state.locationName,
        locationCity: state.region,
        locationCountry: state.countryCode,
        eventType: _mapEventTypeToApiValue(_stringToEventType(state.eventType)),
        maxBookingSlots: state.bookingCategories
            .map((category) => category.contingent)
            .reduce((a, b) => a + b),
        recurringPatterns: state.recurringPatterns
            .map((pattern) => RecurringPatternInput(
                  id: pattern.id ?? const Uuid().v4(),
                  dayOfWeek: pattern.dayOfWeek,
                  startDate: pattern.startDate?.toIso8601String() ?? '',
                  endDate: pattern.endDate?.toIso8601String(),
                  startTime: _timeStringFromTimeOfDay(pattern.startTime),
                  endTime: _timeStringFromTimeOfDay(pattern.endTime),
                  recurringEveryXWeeks: pattern.recurringEveryXWeeks,
                  isRecurring: pattern.isRecurring ?? false,
                ))
            .toList(),
        classOwners: [classOwner], // Include the class owner
        classTeachers: state.pendingInviteTeachers
            .map((teacher) => ClassTeacherInput(
                  id: const Uuid().v4(),
                  teacherId: teacher.id!,
                ))
            .toList(),
        bookingCategories: state.bookingCategories
            .map((category) => BookingCategoryInput(
                  id: category.id ?? const Uuid().v4(),
                  name: category.name,
                  contingent: category.contingent,
                  description: category.description ?? '',
                  bookingOptions: state.bookingOptions
                      .where(
                          (option) => option.bookingCategoryId == category.id)
                      .map((option) => BookingOptionInput(
                            id: option.id ?? const Uuid().v4(),
                            title: option.title ?? '',
                            subtitle: option.subtitle ?? '',
                            price: option.price ?? 0,
                            discount: option.discount ?? 0,
                            currency: option.currency.value,
                          ))
                      .toList(),
                ))
            .toList(),
        questions: state.questions
            .map((question) => QuestionInput(
                  id: question.id ?? const Uuid().v4(),
                  allowMultipleAnswers: question.isMultipleChoice ?? false,
                  isRequired: question.isRequired ?? false,
                  position: 0, // TODO: Set proper position
                  question: question.question ?? '',
                  title: question.title ?? '',
                  questionType: question.type ?? QuestionType.text,
                  multipleChoiceOptions: question.choices
                          ?.map((choice) => MultipleChoiceOptionInput(
                                id: choice.id ?? const Uuid().v4(),
                                optionText: choice.optionText ?? '',
                                position: 0, // TODO: Set proper position
                              ))
                          .toList() ??
                      [],
                ))
            .toList(),
      );

      // Create the class using upsertClass
      final createdClass = await repository.upsertClass(
        classUpsertInput,
        [], // questionIdsToDelete
        [], // recurringPatternIdsToDelete
        [], // deleteClassTeacherIds
        [], // deleteBookingOptionIds
        [], // deleteBookingCategoryIds
      );

      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
      );

      CustomErrorHandler.logDebug(
          "Event creation completed successfully. Class ID: ${createdClass.id}");
    } catch (e) {
      CustomErrorHandler.logError("Error creating event: $e");
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create event: ${e.toString()}',
      );
    }
  }

  /// Update class
  Future<void> updateClass(String creatorId) async {
    try {
      CustomErrorHandler.logDebug(
          "Starting event update with upsertClass for creator: $creatorId");
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Import the repository
      final repository =
          ClassesRepository(apiService: GraphQLClientSingleton());

      // Create ClassOwnerInput for the creator
      final classOwner = ClassOwnerInput(
        id: const Uuid().v4(),
        teacherId: creatorId, // This is the teacher ID, not user ID
        isPaymentReceiver: true,
      );

      // Use existing class ID for editing, generate new one for creation
      final classId = state.isEditing && state.classModel?.id != null
          ? state.classModel!.id!
          : const Uuid().v4();

      // Create ClassUpsertInput following the working pattern
      final classUpsertInput = ClassUpsertInput(
        id: classId, // Use existing ID for editing
        name: state.title,
        description: state.description,
        imageUrl: state.existingImageUrl ?? '',
        timezone: 'UTC', // TODO: Get user's timezone
        urlSlug: state.slug,
        isCashAllowed: state.isCashAllowed,
        location: state.location ?? const LatLng(0.0, 0.0),
        locationName: state.locationName,
        locationCity: state.region,
        locationCountry: state.countryCode,
        eventType: state.eventType,
        maxBookingSlots: state.bookingCategories
            .map((category) => category.contingent)
            .reduce((a, b) => a + b),
        recurringPatterns: state.recurringPatterns
            .map((pattern) => RecurringPatternInput(
                  id: pattern.id ?? const Uuid().v4(),
                  dayOfWeek: pattern.dayOfWeek,
                  startDate: pattern.startDate?.toIso8601String() ?? '',
                  endDate: pattern.endDate?.toIso8601String(),
                  startTime: _timeStringFromTimeOfDay(pattern.startTime),
                  endTime: _timeStringFromTimeOfDay(pattern.endTime),
                  recurringEveryXWeeks: pattern.recurringEveryXWeeks,
                  isRecurring: pattern.isRecurring ?? false,
                ))
            .toList(),
        classOwners: [classOwner], // Include the class owner
        classTeachers: state.pendingInviteTeachers
            .map((teacher) => ClassTeacherInput(
                  id: const Uuid().v4(),
                  teacherId: teacher.id!,
                ))
            .toList(),
        bookingCategories: state.bookingCategories
            .map((category) => BookingCategoryInput(
                  id: category.id ?? const Uuid().v4(),
                  name: category.name,
                  contingent: category.contingent,
                  description: category.description ?? '',
                  bookingOptions: state.bookingOptions
                      .where(
                          (option) => option.bookingCategoryId == category.id)
                      .map((option) => BookingOptionInput(
                            id: option.id ?? const Uuid().v4(),
                            title: option.title ?? '',
                            subtitle: option.subtitle ?? '',
                            price: option.price ?? 0,
                            discount: option.discount ?? 0,
                            currency: option.currency.value,
                          ))
                      .toList(),
                ))
            .toList(),
        questions: state.questions
            .map((question) => QuestionInput(
                  id: question.id ?? const Uuid().v4(),
                  allowMultipleAnswers: question.isMultipleChoice ?? false,
                  isRequired: question.isRequired ?? false,
                  position: 0, // TODO: Set proper position
                  question: question.question ?? '',
                  title: question.title ?? '',
                  questionType: question.type ?? QuestionType.text,
                  multipleChoiceOptions: question.choices != null
                      ? question.choices!
                          .map((choice) => MultipleChoiceOptionInput(
                                id: choice.id ?? const Uuid().v4(),
                                optionText: choice.optionText ?? '',
                                position: choice.position ?? 0,
                              ))
                          .toList()
                      : [],
                ))
            .toList(),
      );

      // Call the repository method
      final createdClass = await repository.upsertClass(
        classUpsertInput,
        [], // deleteQuestionIds - empty for now
        [], // deleteRecurringPatternIds - empty for now
        [], // deleteClassTeacherIds - empty for now
        [], // deleteBookingOptionIds - empty for now
        [], // deleteBookingCategoryIds - empty for now
      );

      if (createdClass.id != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
        );
        CustomErrorHandler.logDebug(
            "Event updated successfully with ID: ${createdClass.id}");
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to update event: No ID returned',
        );
      }
    } catch (e) {
      CustomErrorHandler.logError("Error updating event: $e");
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update event: ${e.toString()}',
      );
    }
  }

  /// Add pending invite teacher
  void addPendingInviteTeacher(TeacherModel teacher) {
    // Check if teacher is already in the list to avoid duplicates
    final existingTeacher =
        state.pendingInviteTeachers.where((t) => t.id == teacher.id).isNotEmpty;

    if (!existingTeacher) {
      final updatedTeachers =
          List<TeacherModel>.from(state.pendingInviteTeachers)..add(teacher);
      state = state.copyWith(pendingInviteTeachers: updatedTeachers);
    }
  }

  /// Remove pending invite teacher
  void removePendingInviteTeacher(String teacherId) {
    final updatedTeachers = List<TeacherModel>.from(state.pendingInviteTeachers)
      ..removeWhere((teacher) => teacher.id == teacherId);
    state = state.copyWith(pendingInviteTeachers: updatedTeachers);
  }

  /// Add email invitation
  void addEmailInvite(String email) {
    // Validate email format
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) {
      return;
    }

    // Check for duplicates
    if (!state.pendingEmailInvites.contains(email)) {
      final emails = List<String>.from(state.pendingEmailInvites);
      emails.add(email);
      state = state.copyWith(pendingEmailInvites: emails);
    }
  }

  /// Remove email invitation
  void removeEmailInvite(String email) {
    final emails = List<String>.from(state.pendingEmailInvites);
    emails.remove(email);
    state = state.copyWith(pendingEmailInvites: emails);
  }

  /// Set max booking slots
  void setMaxBookingSlots(int? slots) {
    state = state.copyWith(maxBookingSlots: slots);
  }

  /// Edit booking option
  void editBookingOption(int index, BookingOption option) {
    final options = List<BookingOption>.from(state.bookingOptions);
    if (index >= 0 && index < options.length) {
      options[index] = option;
      state = state.copyWith(bookingOptions: options);
    }
  }

  /// Edit booking category
  void editCategory(int index, BookingCategoryModel category) {
    final categories = List<BookingCategoryModel>.from(state.bookingCategories);
    if (index >= 0 && index < categories.length) {
      categories[index] = category;
      state = state.copyWith(bookingCategories: categories);
    }
  }

  /// Remove booking category
  void removeCategory(int index) {
    final categories = List<BookingCategoryModel>.from(state.bookingCategories);
    if (index >= 0 && index < categories.length) {
      categories.removeAt(index);
      state = state.copyWith(bookingCategories: categories);
    }
  }

  /// Add booking category
  void addCategory(BookingCategoryModel category) {
    final categories = List<BookingCategoryModel>.from(state.bookingCategories)
      ..add(category);
    state = state.copyWith(bookingCategories: categories);
  }

  /// Switch allow cash payments
  void switchAllowCashPayments() {
    state = state.copyWith(isCashAllowed: !state.isCashAllowed);
  }

  /// Add recurring pattern
  void addRecurringPattern(RecurringPatternModel pattern) {
    final patterns = List<RecurringPatternModel>.from(state.recurringPatterns)
      ..add(pattern);
    state = state.copyWith(recurringPatterns: patterns);
  }

  /// Edit recurring pattern
  void editRecurringPattern(int index, RecurringPatternModel pattern) {
    final patterns = List<RecurringPatternModel>.from(state.recurringPatterns);
    if (index >= 0 && index < patterns.length) {
      patterns[index] = pattern;
      state = state.copyWith(recurringPatterns: patterns);
    }
  }

  /// Remove recurring pattern
  void removeRecurringPattern(int index) {
    final patterns = List<RecurringPatternModel>.from(state.recurringPatterns);
    if (index >= 0 && index < patterns.length) {
      patterns.removeAt(index);
      state = state.copyWith(recurringPatterns: patterns);
    }
  }

  /// Test constructor for unit tests
  EventCreationAndEditingNotifier.test()
      : super(EventCreationAndEditingState(
          classModel: _createEmptyClassModel(),
        ));
}

/// Provider for event creation and editing state
final eventCreationAndEditingProvider = StateNotifierProvider<
    EventCreationAndEditingNotifier, EventCreationAndEditingState>((ref) {
  return EventCreationAndEditingNotifier();
});
