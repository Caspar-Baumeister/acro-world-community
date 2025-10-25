import 'package:acroworld/data/graphql/input/booking_category_input.dart';
import 'package:acroworld/data/graphql/input/booking_option_input.dart';
import 'package:acroworld/data/graphql/input/class_owner_input.dart';
import 'package:acroworld/data/graphql/input/class_upsert_input.dart';
import 'package:acroworld/data/graphql/input/multiple_choice_input.dart';
import 'package:acroworld/data/graphql/input/question_input.dart';
import 'package:acroworld/data/graphql/input/recurring_patterns_input.dart';
import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/profile_creation_service.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:acroworld/utils/helper_functions/country_helpers.dart';
import 'package:acroworld/utils/helper_functions/time_zone_api.dart';
import 'package:acroworld/utils/validation/event_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import 'event_basic_info_provider.dart';
import 'event_booking_provider.dart';
import 'event_location_provider.dart';
import 'event_questions_provider.dart';
import 'event_schedule_provider.dart';
import 'event_teachers_provider.dart';

/// State for event creation coordination
class EventCreationCoordinatorState {
  final int currentPage;
  final bool isEditing;
  final ClassModel? classModel;
  final bool isLoading;
  final String? errorMessage;
  final String? originalSlug; // Store original slug for editing

  const EventCreationCoordinatorState({
    this.currentPage = 0,
    this.isEditing = false,
    this.classModel,
    this.isLoading = false,
    this.errorMessage,
    this.originalSlug,
  });

  EventCreationCoordinatorState copyWith({
    int? currentPage,
    bool? isEditing,
    ClassModel? classModel,
    bool? isLoading,
    String? errorMessage,
    String? originalSlug,
  }) {
    return EventCreationCoordinatorState(
      currentPage: currentPage ?? this.currentPage,
      isEditing: isEditing ?? this.isEditing,
      classModel: classModel ?? this.classModel,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      originalSlug: originalSlug ?? this.originalSlug,
    );
  }
}

/// Notifier for event creation coordination
class EventCreationCoordinatorNotifier
    extends StateNotifier<EventCreationCoordinatorState> {
  final Ref ref;

  EventCreationCoordinatorNotifier(this.ref, {ClassModel? existingEvent})
      : super(EventCreationCoordinatorState(
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

  // Getters for accessing other providers
  EventBasicInfoState get _basicInfo => ref.read(eventBasicInfoProvider);
  EventLocationState get _location => ref.read(eventLocationProvider);

  /// Set current page
  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  /// Set editing mode
  void setEditing(bool isEditing) {
    state = state.copyWith(isEditing: isEditing);
  }

  /// Load existing class for editing or template creation
  Future<void> loadExistingClass(String slug, bool isEditing) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Fetch the class data by slug
      final repository =
          ClassesRepository(apiService: GraphQLClientSingleton());
      final classModel = await repository.getClassBySlug(slug);

      // Create a class model - preserve original data for editing, clear for template creation
      final templateClassModel = ClassModel(
        id: isEditing ? classModel.id : null, // Preserve ID for editing
        urlSlug: isEditing ? classModel.urlSlug : '', // Clear slug for template
        name: classModel.name,
        description: classModel.description,
        locationName: classModel.locationName,
        imageUrl: classModel.imageUrl,
        eventType: classModel.eventType,
        city: classModel.city,
        country: classModel.country,
        location: classModel.location,
        isCashAllowed: classModel.isCashAllowed,
        bookingEmail: classModel.bookingEmail,
        maxBookingSlots: classModel.maxBookingSlots,
        questions: classModel.questions,
      );

      // Copy recurring patterns directly from the fetched class
      final recurringPatternsFromClass = classModel.recurringPatterns ?? [];

      // Convert country name to country code
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

      print('🎟️ BOOKING DEBUG - Starting to copy booking categories...');
      print(
          '🎟️ BOOKING DEBUG - classModel.bookingCategories: ${classModel.bookingCategories?.length ?? 0}');

      if (classModel.bookingCategories != null) {
        for (final category in classModel.bookingCategories!) {
          print('🎟️ BOOKING DEBUG - Processing category: ${category.name}');
          print('🎟️ BOOKING DEBUG - Category ID (original): ${category.id}');
          print(
              '🎟️ BOOKING DEBUG - Category contingent: ${category.contingent}');
          print(
              '🎟️ BOOKING DEBUG - Category has ${category.bookingOptions?.length ?? 0} options');

          // Preserve original ID for editing, generate new for template creation
          final categoryId = isEditing ? category.id : const Uuid().v4();

          final copiedCategory = BookingCategoryModel(
            id: categoryId,
            name: category.name,
            description: category.description,
            contingent: category.contingent,
          );
          copiedCategories.add(copiedCategory);

          print(
              '🎟️ BOOKING DEBUG - ✅ Created copied category with ID: $categoryId (isEditing: $isEditing)');

          // Copy associated booking options
          if (category.bookingOptions != null) {
            for (final option in category.bookingOptions!) {
              print('🎟️ BOOKING DEBUG - Processing option: ${option.title}');
              print('🎟️ BOOKING DEBUG - Option ID (original): ${option.id}');
              print(
                  '🎟️ BOOKING DEBUG - Option bookingCategoryId (original): ${option.bookingCategoryId}');
              print('🎟️ BOOKING DEBUG - Option price: ${option.price}');

              final copiedOption = BookingOption(
                id: isEditing ? option.id : null, // Preserve ID for editing
                title: option.title,
                subtitle: option.subtitle,
                price: option.price,
                currency: option.currency,
                bookingCategoryId: categoryId,
              );
              copiedOptions.add(copiedOption);

              print(
                  '🎟️ BOOKING DEBUG - ✅ Created copied option with ID: ${copiedOption.id} (isEditing: $isEditing)');
            }
          }
        }
      }

      print(
          '🎟️ BOOKING DEBUG - Final copied categories: ${copiedCategories.length}');
      print(
          '🎟️ BOOKING DEBUG - Final copied options: ${copiedOptions.length}');

      // Copy questions
      final List<QuestionModel> copiedQuestions = [];
      if (classModel.questions.isNotEmpty) {
        for (final question in classModel.questions) {
          final copiedQuestion = QuestionModel(
            id: isEditing ? question.id : null, // Preserve ID for editing
            question: question.question,
            type: question.type,
            isRequired: question.isRequired,
            choices: question.choices,
          );
          copiedQuestions.add(copiedQuestion);
        }
      }

      // Copy class teachers
      final List<TeacherModel> copiedTeachers = [];
      if (classModel.classTeachers != null) {
        for (final classTeacher in classModel.classTeachers!) {
          if (classTeacher.teacher != null) {
            copiedTeachers.add(classTeacher.teacher!);
          }
        }
      }

      // Set data in all providers
      ref.read(eventBasicInfoProvider.notifier).setFromTemplate(
            title: templateClassModel.name ?? '',
            slug: templateClassModel.urlSlug ?? '',
            description: templateClassModel.description ?? '',
            eventType: templateClassModel.eventType?.name,
            existingImageUrl: templateClassModel.imageUrl,
          );

      ref.read(eventLocationProvider.notifier).setFromTemplate(
            locationName: templateClassModel.locationName,
            location: templateClassModel.location?.toLatLng(),
            locationDescription: templateClassModel.locationName,
            countryCode: finalCountryCode,
            region: templateClassModel.city, // Use city as region
          );

      ref.read(eventBookingProvider.notifier).setFromTemplate(
            bookingCategories: copiedCategories,
            bookingOptions: copiedOptions,
            maxBookingSlots: templateClassModel.maxBookingSlots,
            isCashAllowed: templateClassModel.isCashAllowed ?? false,
          );

      ref.read(eventQuestionsProvider.notifier).setFromTemplate(
            questions: copiedQuestions,
          );

      ref.read(eventScheduleProvider.notifier).setFromTemplate(
            recurringPatterns: recurringPatternsFromClass,
            recurrentPattern: recurringPatternsFromClass.isNotEmpty
                ? recurringPatternsFromClass.first
                : null,
          );

      ref.read(eventTeachersProvider.notifier).setFromTemplate(
            pendingInviteTeachers: copiedTeachers,
          );

      // Set old data for deletion tracking (only when editing)
      if (isEditing) {
        // Set old recurring patterns
        final oldPatterns = classModel.recurringPatterns ?? [];

        ref
            .read(eventScheduleProvider.notifier)
            .setOldRecurringPatterns(oldPatterns);

        // Set old booking data
        ref.read(eventBookingProvider.notifier).setOldBookingData(
              categories: copiedCategories,
              options: copiedOptions,
            );

        // Set old questions
        ref
            .read(eventQuestionsProvider.notifier)
            .setOldQuestions(copiedQuestions);

        // Set old class teachers
        final oldTeachers = classModel.classTeachers ?? [];

        ref
            .read(eventTeachersProvider.notifier)
            .setOldClassTeachers(oldTeachers);
      }

      state = state.copyWith(
        classModel: templateClassModel,
        isEditing: isEditing,
        isLoading: false,
        errorMessage: null,
        originalSlug: isEditing
            ? classModel.urlSlug
            : null, // Store original slug when editing
      );
    } catch (e) {
      CustomErrorHandler.logError('Error loading template: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load template: ${e.toString()}',
      );
    }
  }

  /// Validate all event data
  Map<String, String?> validateEventData() {
    return EventValidation.validateEvent(
      title: _basicInfo.title,
      slug: _basicInfo.slug,
      description: _basicInfo.description,
      locationName: _location.locationName,
      location: _location.location,
      eventType: _basicInfo.eventType,
      countryCode: _location.countryCode,
      region: _location.region,
      image: _basicInfo.eventImage,
      existingImageUrl: _basicInfo.existingImageUrl,
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

  /// Save event (create or update)
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
        if (_basicInfo.isSlugValid != true) {
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

      // Get data from sub-providers
      final basicInfo = ref.read(eventBasicInfoProvider);
      final location = ref.read(eventLocationProvider);
      final booking = ref.read(eventBookingProvider);
      final questions = ref.read(eventQuestionsProvider);
      final schedule = ref.read(eventScheduleProvider);

      // Get timezone based on location
      String timezone = 'Europe/Berlin'; // Default
      if (location.location != null) {
        try {
          timezone = await getTimezone(
            location.location!.latitude,
            location.location!.longitude,
          );
        } catch (e) {
          CustomErrorHandler.logError('Failed to get timezone: $e');
        }
      }

      // Upload event image if new one selected
      final imageUrl = await _uploadImage();

      // Calculate maxBookingSlots safely
      final maxBookingSlots = booking.bookingCategories.isEmpty
          ? 0
          : booking.bookingCategories
              .map((category) => category.contingent)
              .reduce((a, b) => a + b);

      // Create ClassUpsertInput following the working pattern
      final classUpsertInput = ClassUpsertInput(
        id: const Uuid().v4(),
        name: basicInfo.title,
        description: basicInfo.description,
        imageUrl: imageUrl,
        timezone: timezone,
        urlSlug: basicInfo.slug,
        isCashAllowed: booking.isCashAllowed,
        location: location.location ?? const LatLng(0.0, 0.0),
        locationName: location.locationName,
        locationCity: location.region,
        locationCountry: location.countryCode,
        eventType:
            _mapEventTypeToApiValue(_stringToEventType(basicInfo.eventType)),
        maxBookingSlots: maxBookingSlots,
        recurringPatterns: schedule.recurringPatterns
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
        bookingCategories: booking.bookingCategories
            .map((category) => BookingCategoryInput(
                  id: category.id ?? const Uuid().v4(),
                  name: category.name,
                  contingent: category.contingent,
                  description: category.description ?? '',
                  bookingOptions: booking.bookingOptions
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
        questions: questions.questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          return QuestionInput(
            id: question.id ?? const Uuid().v4(),
            allowMultipleAnswers: question.isMultipleChoice ?? false,
            isRequired: question.isRequired ?? false,
            position: index,
            question: question.question ?? '',
            title: question.title ?? '',
            questionType: question.type ?? QuestionType.text,
            multipleChoiceOptions: question.choices
                    ?.asMap()
                    .entries
                    .map((choiceEntry) => MultipleChoiceOptionInput(
                          id: choiceEntry.value.id ?? const Uuid().v4(),
                          optionText: choiceEntry.value.optionText ?? '',
                          position: choiceEntry.key,
                        ))
                    .toList() ??
                [],
          );
        }).toList(),
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

      // Send invitations to teachers after class creation
      if (createdClass.id != null) {
        await _sendTeacherInvitations(createdClass.id!);
      }

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

      // Get data from sub-providers
      final basicInfo = ref.read(eventBasicInfoProvider);
      final location = ref.read(eventLocationProvider);
      final booking = ref.read(eventBookingProvider);
      final questions = ref.read(eventQuestionsProvider);
      final schedule = ref.read(eventScheduleProvider);

      // Get teachers data
      final teachers = ref.read(eventTeachersProvider);

      // Use existing class ID for editing, generate new one for creation
      final classId = state.isEditing && state.classModel?.id != null
          ? state.classModel!.id!
          : const Uuid().v4();

      // Get timezone based on location
      String timezone = 'Europe/Berlin'; // Default
      if (location.location != null) {
        try {
          timezone = await getTimezone(
            location.location!.latitude,
            location.location!.longitude,
          );
        } catch (e) {
          CustomErrorHandler.logError('Failed to get timezone: $e');
        }
      }

      // Upload event image if new one selected
      final imageUrl = await _uploadImage();

      // Calculate maxBookingSlots safely
      final maxBookingSlots = booking.bookingCategories.isEmpty
          ? 0
          : booking.bookingCategories
              .map((category) => category.contingent)
              .reduce((a, b) => a + b);

      // Create ClassUpsertInput following the working pattern
      final classUpsertInput = ClassUpsertInput(
        id: classId, // Use existing ID for editing
        name: basicInfo.title,
        description: basicInfo.description,
        imageUrl: imageUrl,
        timezone: timezone,
        urlSlug: basicInfo.slug,
        isCashAllowed: booking.isCashAllowed,
        location: location.location ?? const LatLng(0.0, 0.0),
        locationName: location.locationName,
        locationCity: location.region,
        locationCountry: location.countryCode,
        eventType: basicInfo.eventType,
        maxBookingSlots: maxBookingSlots,
        recurringPatterns: schedule.recurringPatterns
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
        bookingCategories: booking.bookingCategories
            .map((category) => BookingCategoryInput(
                  id: category.id ?? const Uuid().v4(),
                  name: category.name,
                  contingent: category.contingent,
                  description: category.description ?? '',
                  bookingOptions: booking.bookingOptions
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
        questions: questions.questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          return QuestionInput(
            id: question.id ?? const Uuid().v4(),
            allowMultipleAnswers: question.isMultipleChoice ?? false,
            isRequired: question.isRequired ?? false,
            position: index,
            question: question.question ?? '',
            title: question.title ?? '',
            questionType: question.type ?? QuestionType.text,
            multipleChoiceOptions: question.choices
                    ?.asMap()
                    .entries
                    .map((choiceEntry) => MultipleChoiceOptionInput(
                          id: choiceEntry.value.id ?? const Uuid().v4(),
                          optionText: choiceEntry.value.optionText ?? '',
                          position: choiceEntry.key,
                        ))
                    .toList() ??
                [],
          );
        }).toList(),
      );

      // Calculate deletions by comparing old vs new data
      print('🗑️ DELETION DEBUG - ========================================');
      print('🗑️ DELETION DEBUG - CALCULATING DELETIONS');
      print('🗑️ DELETION DEBUG - isEditing: ${state.isEditing}');

      // Calculate question deletions
      print('🗑️ DELETION DEBUG - --- QUESTIONS ---');
      print(
          '🗑️ DELETION DEBUG - Old Questions: ${questions.oldQuestions.length}');
      for (var i = 0; i < questions.oldQuestions.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   Old[$i]: ID=${questions.oldQuestions[i].id}');
      }
      print(
          '🗑️ DELETION DEBUG - New Questions: ${questions.questions.length}');
      for (var i = 0; i < questions.questions.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   New[$i]: ID=${questions.questions[i].id}');
      }

      final List<String> questionIdsToDelete = state.isEditing
          ? questions.oldQuestions
              .where((oldQuestion) => !questions.questions
                  .any((newQuestion) => newQuestion.id == oldQuestion.id))
              .map((question) => question.id!)
              .toList()
          : [];
      print(
          '🗑️ DELETION DEBUG - Questions to Delete: ${questionIdsToDelete.length}');
      for (var i = 0; i < questionIdsToDelete.length; i++) {
        print('🗑️ DELETION DEBUG -   Delete[$i]: ${questionIdsToDelete[i]}');
      }

      // Calculate recurring pattern deletions
      print('🗑️ DELETION DEBUG - --- RECURRING PATTERNS ---');
      print(
          '🗑️ DELETION DEBUG - Old Patterns: ${schedule.oldRecurringPatterns.length}');
      for (var i = 0; i < schedule.oldRecurringPatterns.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   Old[$i]: ID=${schedule.oldRecurringPatterns[i].id}');
      }
      print(
          '🗑️ DELETION DEBUG - New Patterns: ${schedule.recurringPatterns.length}');
      for (var i = 0; i < schedule.recurringPatterns.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   New[$i]: ID=${schedule.recurringPatterns[i].id}');
      }

      final List<String> recurringPatternIdsToDelete = state.isEditing
          ? schedule.oldRecurringPatterns
              .where((oldPattern) => !schedule.recurringPatterns
                  .any((newPattern) => newPattern.id == oldPattern.id))
              .map((pattern) => pattern.id!)
              .toList()
          : [];
      print(
          '🗑️ DELETION DEBUG - Patterns to Delete: ${recurringPatternIdsToDelete.length}');
      for (var i = 0; i < recurringPatternIdsToDelete.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   Delete[$i]: ${recurringPatternIdsToDelete[i]}');
      }

      // Calculate booking category deletions
      print('🗑️ DELETION DEBUG - --- BOOKING CATEGORIES ---');
      print(
          '🗑️ DELETION DEBUG - Old Categories: ${booking.oldBookingCategories.length}');
      for (var i = 0; i < booking.oldBookingCategories.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   Old[$i]: ID=${booking.oldBookingCategories[i].id}, Name=${booking.oldBookingCategories[i].name}');
      }
      print(
          '🗑️ DELETION DEBUG - New Categories: ${booking.bookingCategories.length}');
      for (var i = 0; i < booking.bookingCategories.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   New[$i]: ID=${booking.bookingCategories[i].id}, Name=${booking.bookingCategories[i].name}');
      }

      final List<String> bookingCategoryIdsToDelete = state.isEditing
          ? booking.oldBookingCategories
              .where((oldCategory) => !booking.bookingCategories
                  .any((newCategory) => newCategory.id == oldCategory.id))
              .map((category) => category.id!)
              .toList()
          : [];
      print(
          '🗑️ DELETION DEBUG - Categories to Delete: ${bookingCategoryIdsToDelete.length}');
      for (var i = 0; i < bookingCategoryIdsToDelete.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   Delete[$i]: ${bookingCategoryIdsToDelete[i]}');
      }

      // Calculate booking option deletions
      print('🗑️ DELETION DEBUG - --- BOOKING OPTIONS ---');
      print(
          '🗑️ DELETION DEBUG - Old Options: ${booking.oldBookingOptions.length}');
      for (var i = 0; i < booking.oldBookingOptions.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   Old[$i]: ID=${booking.oldBookingOptions[i].id}, Title=${booking.oldBookingOptions[i].title}');
      }
      print(
          '🗑️ DELETION DEBUG - New Options: ${booking.bookingOptions.length}');
      for (var i = 0; i < booking.bookingOptions.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   New[$i]: ID=${booking.bookingOptions[i].id}, Title=${booking.bookingOptions[i].title}');
      }

      final List<String> bookingOptionIdsToDelete = state.isEditing
          ? booking.oldBookingOptions
              .where((oldOption) => !booking.bookingOptions
                  .any((newOption) => newOption.id == oldOption.id))
              .map((option) => option.id!)
              .toList()
          : [];
      print(
          '🗑️ DELETION DEBUG - Options to Delete: ${bookingOptionIdsToDelete.length}');
      for (var i = 0; i < bookingOptionIdsToDelete.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   Delete[$i]: ${bookingOptionIdsToDelete[i]}');
      }

      // Calculate class teacher deletions
      print('🗑️ DELETION DEBUG - --- CLASS TEACHERS ---');
      print(
          '🗑️ DELETION DEBUG - Old Teachers: ${teachers.oldClassTeachers.length}');
      for (var i = 0; i < teachers.oldClassTeachers.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   Old[$i]: ID=${teachers.oldClassTeachers[i].id}, TeacherID=${teachers.oldClassTeachers[i].teacher?.id}');
      }
      print(
          '🗑️ DELETION DEBUG - New Teachers: ${teachers.pendingInviteTeachers.length}');
      for (var i = 0; i < teachers.pendingInviteTeachers.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   New[$i]: ID=${teachers.pendingInviteTeachers[i].id}');
      }

      final List<String> classTeacherIdsToDelete = state.isEditing
          ? teachers.oldClassTeachers
              .where((oldClassTeacher) => !teachers.pendingInviteTeachers.any(
                  (newTeacher) => newTeacher.id == oldClassTeacher.teacher?.id))
              .map((classTeacher) => classTeacher.id!)
              .toList()
          : [];
      print(
          '🗑️ DELETION DEBUG - Teachers to Delete: ${classTeacherIdsToDelete.length}');
      for (var i = 0; i < classTeacherIdsToDelete.length; i++) {
        print(
            '🗑️ DELETION DEBUG -   Delete[$i]: ${classTeacherIdsToDelete[i]}');
      }

      print('🗑️ DELETION DEBUG - ========================================');
      print('🗑️ DELETION DEBUG - SENDING TO REPOSITORY');
      print(
          '🗑️ DELETION DEBUG - questionIdsToDelete: ${questionIdsToDelete.length} items');
      if (questionIdsToDelete.isNotEmpty) {
        for (var i = 0; i < questionIdsToDelete.length; i++) {
          print(
              '🗑️ DELETION DEBUG -   questionIdsToDelete[$i]: ${questionIdsToDelete[i]}');
        }
      }
      print(
          '🗑️ DELETION DEBUG - recurringPatternIdsToDelete: ${recurringPatternIdsToDelete.length} items');
      if (recurringPatternIdsToDelete.isNotEmpty) {
        for (var i = 0; i < recurringPatternIdsToDelete.length; i++) {
          print(
              '🗑️ DELETION DEBUG -   recurringPatternIdsToDelete[$i]: ${recurringPatternIdsToDelete[i]}');
        }
      }
      print(
          '🗑️ DELETION DEBUG - classTeacherIdsToDelete: ${classTeacherIdsToDelete.length} items');
      if (classTeacherIdsToDelete.isNotEmpty) {
        for (var i = 0; i < classTeacherIdsToDelete.length; i++) {
          print(
              '🗑️ DELETION DEBUG -   classTeacherIdsToDelete[$i]: ${classTeacherIdsToDelete[i]}');
        }
      }
      print(
          '🗑️ DELETION DEBUG - bookingOptionIdsToDelete: ${bookingOptionIdsToDelete.length} items');
      if (bookingOptionIdsToDelete.isNotEmpty) {
        for (var i = 0; i < bookingOptionIdsToDelete.length; i++) {
          print(
              '🗑️ DELETION DEBUG -   bookingOptionIdsToDelete[$i]: ${bookingOptionIdsToDelete[i]}');
        }
      }
      print(
          '🗑️ DELETION DEBUG - bookingCategoryIdsToDelete: ${bookingCategoryIdsToDelete.length} items');
      if (bookingCategoryIdsToDelete.isNotEmpty) {
        for (var i = 0; i < bookingCategoryIdsToDelete.length; i++) {
          print(
              '🗑️ DELETION DEBUG -   bookingCategoryIdsToDelete[$i]: ${bookingCategoryIdsToDelete[i]}');
        }
      }
      print('🗑️ DELETION DEBUG - ========================================');

      // Call the repository method
      print('🗑️ DELETION DEBUG - Calling repository.upsertClass()...');
      final createdClass = await repository.upsertClass(
        classUpsertInput,
        questionIdsToDelete,
        recurringPatternIdsToDelete,
        classTeacherIdsToDelete,
        bookingOptionIdsToDelete,
        bookingCategoryIdsToDelete,
      );

      print('🗑️ DELETION DEBUG - Repository call completed successfully');
      print('🗑️ DELETION DEBUG - Created class ID: ${createdClass.id}');

      if (createdClass.id != null) {
        // Send invitations to teachers after class update
        await _sendTeacherInvitations(createdClass.id!);

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

  /// Convert TimeOfDay to string format
  String _timeStringFromTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00'; // Assuming seconds are always 00
  }

  /// Upload image to Firebase Storage
  Future<String> _uploadImage() async {
    final basicInfo = ref.read(eventBasicInfoProvider);

    String? imageUrl;
    if (basicInfo.eventImage == null && basicInfo.existingImageUrl != null) {
      // No new image selected, use existing URL
      imageUrl = basicInfo.existingImageUrl;
    } else if (basicInfo.eventImage != null) {
      // New image selected, upload it
      imageUrl = await _uploadEventImage();
    } else {
      // No image at all
      imageUrl = '';
    }
    return imageUrl ?? '';
  }

  /// Upload event image bytes to Firebase Storage
  Future<String?> _uploadEventImage() async {
    final basicInfo = ref.read(eventBasicInfoProvider);

    if (basicInfo.eventImage == null) {
      CustomErrorHandler.logError("Event image was null");
      return null;
    }

    try {
      final imageService = ImageUploadService();
      final imageUrl = await imageService.uploadImage(
        basicInfo.eventImage!,
        path: 'events/images/${DateTime.now().millisecondsSinceEpoch}.png',
      );
      CustomErrorHandler.logDebug(
          'Event image uploaded successfully: $imageUrl');
      return imageUrl;
    } catch (e) {
      CustomErrorHandler.logError('Error uploading event image: $e');
      return null;
    }
  }

  /// Send teacher invitations after class creation
  Future<void> _sendTeacherInvitations(String classId) async {
    try {
      final teachers = ref.read(eventTeachersProvider);
      final client = GraphQLClientSingleton().client;

      // Send invitations to selected teachers (with user accounts)
      for (final teacher in teachers.pendingInviteTeachers) {
        if (teacher.email != null) {
          try {
            final result = await client.mutate(
              MutationOptions(
                document: Mutations.inviteToClassMutation,
                variables: {
                  'email': teacher.email!,
                  'entity': 'class',
                  'entity_id': classId,
                  'userId': teacher.userId,
                },
              ),
            );

            if (result.hasException) {
              CustomErrorHandler.logError(
                  'Failed to invite teacher ${teacher.name}: ${result.exception}');
            } else {
              CustomErrorHandler.logDebug(
                  'Successfully invited teacher ${teacher.name} to class $classId');
            }
          } catch (e) {
            CustomErrorHandler.logError(
                'Error inviting teacher ${teacher.name}: $e');
          }
        } else {
          CustomErrorHandler.logError(
              'Teacher ${teacher.name} has no email, skipping invitation');
        }
      }

      // Send email invitations (for users without teacher accounts)
      for (final email in teachers.pendingEmailInvites) {
        try {
          final result = await client.mutate(
            MutationOptions(
              document: Mutations.inviteToClassMutation,
              variables: {
                'email': email,
                'entity': 'class',
                'entity_id': classId,
                // userId is null for email-only invitations
              },
            ),
          );

          if (result.hasException) {
            CustomErrorHandler.logError(
                'Failed to invite email $email: ${result.exception}');
          } else {
            CustomErrorHandler.logDebug(
                'Successfully invited email $email to class $classId');
          }
        } catch (e) {
          CustomErrorHandler.logError('Error inviting email $email: $e');
        }
      }
    } catch (e) {
      CustomErrorHandler.logError('Error sending teacher invitations: $e');
    }
  }

  /// Reset all providers
  void reset() {
    ref.read(eventBasicInfoProvider.notifier).reset();
    ref.read(eventLocationProvider.notifier).reset();
    ref.read(eventBookingProvider.notifier).reset();
    ref.read(eventQuestionsProvider.notifier).reset();
    ref.read(eventScheduleProvider.notifier).reset();
    ref.read(eventTeachersProvider.notifier).reset();

    state = const EventCreationCoordinatorState();
  }
}

/// Provider for event creation coordination
final eventCreationCoordinatorProvider = StateNotifierProvider<
    EventCreationCoordinatorNotifier, EventCreationCoordinatorState>((ref) {
  return EventCreationCoordinatorNotifier(ref);
});

/// Provider family for event creation coordination with existing event
final eventCreationCoordinatorProviderWithEvent = StateNotifierProvider.family<
    EventCreationCoordinatorNotifier,
    EventCreationCoordinatorState,
    ClassModel?>((ref, existingEvent) {
  return EventCreationCoordinatorNotifier(ref, existingEvent: existingEvent);
});
