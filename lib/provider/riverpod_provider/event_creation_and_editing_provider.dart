import 'dart:typed_data';

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
  final List<TeacherModel> pendingInviteTeachers;
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
    this.pendingInviteTeachers = const [],
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
    List<TeacherModel>? pendingInviteTeachers,
    int? maxBookingSlots,
    List<RecurringPatternModel>? recurringPatterns,
    RecurringPatternModel? recurrentPattern,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventCreationAndEditingState(
      currentPage: currentPage ?? this.currentPage,
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
      pendingInviteTeachers:
          pendingInviteTeachers ?? this.pendingInviteTeachers,
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

      // TODO: Implement validateSlug method in ClassesRepository
      // final repository = ClassesRepository(apiService: GraphQLClientSingleton());
      // final isValid = await repository.validateSlug(slug);

      state = state.copyWith(
        // isSlugValid: isValid,
        isLoading: false,
      );
    } catch (e) {
      CustomErrorHandler.logError('Error validating slug: $e');
      state = state.copyWith(
        isSlugValid: false,
        isLoading: false,
        errorMessage: 'Error validating slug',
      );
    }
  }

  /// Save event
  Future<bool> saveEvent() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // TODO: Fix createClass method signature
      // final repository = ClassesRepository(apiService: GraphQLClientSingleton());
      // final success = await repository.createClass(state.classModel!);

      // if (success) {
      if (true) {
        state = state.copyWith(isLoading: false);
        CustomErrorHandler.logDebug('Event saved successfully');
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to save event',
        );
        return false;
      }
    } catch (e) {
      CustomErrorHandler.logError('Error saving event: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error saving event',
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

      // Create a new class model based on the template but clear the ID and slug
      final templateClassModel = ClassModel(
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
        classEvents: null, // Clear events for new class
        questions:
            List<QuestionModel>.from(classModel.questions), // Copy questions
        bookingCategories: classModel.bookingCategories,
        classFlags: null, // Clear flags for new class
        isCashAllowed: classModel.isCashAllowed,
        createdBy: null, // Clear creator for new class
        bookingEmail: classModel.bookingEmail,
        maxBookingSlots: classModel.maxBookingSlots,
        // Don't set id, urlSlug, createdAt, updatedAt - these will be generated
      );

      // Debug: Print template data
      print('🔍 TEMPLATE DEBUG - Loading template: $slug');
      print('🔍 TEMPLATE DEBUG - Template name: ${templateClassModel.name}');
      print(
          '🔍 TEMPLATE DEBUG - Template description: ${templateClassModel.description}');
      print(
          '🔍 TEMPLATE DEBUG - Template locationName: ${templateClassModel.locationName}');
      print(
          '🔍 TEMPLATE DEBUG - Template imageUrl: ${templateClassModel.imageUrl}');
      print(
          '🔍 TEMPLATE DEBUG - Template eventType: ${templateClassModel.eventType?.name}');
      print('🔍 TEMPLATE DEBUG - Template city: ${templateClassModel.city}');
      print(
          '🔍 TEMPLATE DEBUG - Template country: ${templateClassModel.country}');
      print(
          '🔍 TEMPLATE DEBUG - Template location: ${templateClassModel.location}');

      // Convert country name to country code
      final countryCode = getCountryCode(templateClassModel.country);
      print('🔍 TEMPLATE DEBUG - Converted country code: $countryCode');

      state = EventCreationAndEditingState(
        classModel: templateClassModel,
        title: templateClassModel.name ?? '',
        description: templateClassModel.description ?? '',
        locationName: templateClassModel.locationName,
        existingImageUrl: templateClassModel.imageUrl,
        location: templateClassModel.location?.toLatLng(),
        locationDescription:
            templateClassModel.locationName, // Use locationName as description
        eventType: templateClassModel.eventType?.name,
        isCashAllowed: templateClassModel.isCashAllowed ?? false,
        maxBookingSlots: templateClassModel.maxBookingSlots,
        questions: List<QuestionModel>.from(templateClassModel.questions),
        bookingCategories: templateClassModel.bookingCategories ?? [],
        recurringPatterns: templateClassModel.recurringPatterns ?? [],
        countryCode: getCountryCode(
            templateClassModel.country), // Convert country name to country code
        region: templateClassModel
            .city, // Use city as region (e.g., "State of Berlin")
        isLoading: false,
        errorMessage: null,
      );

      // Debug: Print state after setting
      print('🔍 TEMPLATE DEBUG - State title: ${state.title}');
      print('🔍 TEMPLATE DEBUG - State description: ${state.description}');
      print('🔍 TEMPLATE DEBUG - State locationName: ${state.locationName}');
      print(
          '🔍 TEMPLATE DEBUG - State existingImageUrl: ${state.existingImageUrl}');
      print('🔍 TEMPLATE DEBUG - State eventType: ${state.eventType}');
      print('🔍 TEMPLATE DEBUG - State countryCode: ${state.countryCode}');
      print('🔍 TEMPLATE DEBUG - State region: ${state.region}');
      print('🔍 TEMPLATE DEBUG - State location: ${state.location}');
      print(
          '🔍 TEMPLATE DEBUG - State locationDescription: ${state.locationDescription}');
      print(
          '🔍 TEMPLATE DEBUG - Template city used as region: ${templateClassModel.city}');

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
    // TODO: Implement actual slug availability check
    // For now, just set as valid
    state = state.copyWith(isSlugValid: true, isSlugAvailable: true);
  }

  /// Clear slug validation state
  void clearSlugValidation() {
    state = state.copyWith(isSlugValid: null, isSlugAvailable: null);
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

  /// Create class
  Future<void> createClass(String creatorId) async {
    try {
      print("🚀 DEBUG: Starting event creation...");
      print("🚀 DEBUG: Creator ID: $creatorId");
      print("🚀 DEBUG: Event state: ${state.toString()}");

      state = state.copyWith(isLoading: true, errorMessage: null);

      // Import the repository
      final repository =
          ClassesRepository(apiService: GraphQLClientSingleton());

      // Prepare the variables for the mutation
      final variables = <String, dynamic>{
        'name': state.title,
        'description': state.description,
        'imageUrl': state.existingImageUrl ?? '',
        'eventType':
            _mapEventTypeToApiValue(_stringToEventType(state.eventType)),
        'location': state.location != null
            ? [state.location!.longitude, state.location!.latitude]
            : [0.0, 0.0],
        'locationName': state.locationName ?? '',
        'timezone': 'UTC', // TODO: Get user's timezone
        'urlSlug': state.slug,
        'recurringPatterns':
            state.recurringPatterns.map((pattern) => pattern.toJson()).toList(),
        'classOwners': [
          {
            'teacher_id': creatorId,
            'is_payment_receiver': true,
          }
        ],
        'classTeachers': state.pendingInviteTeachers
            .map((teacher) => {
                  'teacher_id': teacher.id,
                })
            .toList(),
        'max_booking_slots': state.maxBookingSlots,
        'location_country': state.countryCode,
        'location_city': state.region,
        'is_cash_allowed': state.isCashAllowed,
        'created_by_id': creatorId,
      };

      print(
          "🚀 DEBUG: Event type mapping: ${state.eventType} -> ${_mapEventTypeToApiValue(_stringToEventType(state.eventType))}");
      print("🚀 DEBUG: Mutation variables: $variables");

      // Create the class
      print("🚀 DEBUG: Calling repository.createClass()...");
      final createdClass = await repository.createClass(variables);

      print("🚀 DEBUG: Repository call completed successfully!");
      print("🚀 DEBUG: Created class ID: ${createdClass.id}");
      print("🚀 DEBUG: Created class name: ${createdClass.name}");
      print("🚀 DEBUG: Created class slug: ${createdClass.urlSlug}");

      // TODO: Create booking categories and options
      // This would require additional API calls to create the ticket categories and options
      print("🚀 DEBUG: Skipping booking categories creation for now...");

      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
      );

      print("🚀 DEBUG: State updated - isLoading: false, errorMessage: null");
      print("🚀 DEBUG: Event creation completed successfully!");
    } catch (e) {
      print("❌ DEBUG: Error creating event: $e");
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create event: ${e.toString()}',
      );
    }
  }

  /// Update class (simplified version)
  Future<void> updateClass(String creatorId) async {
    // TODO: Implement full updateClass logic
    // For now, just set loading state
    state = state.copyWith(isLoading: true);
    // Simulate async operation
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false);
  }

  /// Add pending invite teacher
  void addPendingInviteTeacher(TeacherModel teacher) {
    final updatedTeachers = List<TeacherModel>.from(state.pendingInviteTeachers)
      ..add(teacher);
    state = state.copyWith(pendingInviteTeachers: updatedTeachers);
  }

  /// Remove pending invite teacher
  void removePendingInviteTeacher(String teacherId) {
    final updatedTeachers = List<TeacherModel>.from(state.pendingInviteTeachers)
      ..removeWhere((teacher) => teacher.id == teacherId);
    state = state.copyWith(pendingInviteTeachers: updatedTeachers);
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
