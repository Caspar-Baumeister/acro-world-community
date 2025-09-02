import 'dart:typed_data';

import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:latlong2/latlong.dart';
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
import 'package:acroworld/utils/helper_functions/country_helpers.dart';
import 'package:acroworld/utils/helper_functions/time_zone_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
  final bool? isSlugValid;
  final bool? isSlugAvailable;
  final LatLng? location;
  final String? locationDescription;
  final String? countryCode;
  final String? region;
  final String? eventType;
  final RecurrentPatternModel? recurrentPattern;
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
    this.isSlugValid,
    this.isSlugAvailable,
    this.location,
    this.locationDescription,
    this.countryCode,
    this.region,
    this.eventType,
    this.recurrentPattern,
    this.isLoading = false,
    this.errorMessage,
  });

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
    bool? isSlugValid,
    bool? isSlugAvailable,
    LatLng? location,
    String? locationDescription,
    String? countryCode,
    String? region,
    String? eventType,
    RecurrentPatternModel? recurrentPattern,
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
      isSlugValid: isSlugValid ?? this.isSlugValid,
      isSlugAvailable: isSlugAvailable ?? this.isSlugAvailable,
      location: location ?? this.location,
      locationDescription: locationDescription ?? this.locationDescription,
      countryCode: countryCode ?? this.countryCode,
      region: region ?? this.region,
      eventType: eventType ?? this.eventType,
      recurrentPattern: recurrentPattern ?? this.recurrentPattern,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier for event creation and editing state management
class EventCreationAndEditingNotifier extends StateNotifier<EventCreationAndEditingState> {
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
    final updatedCategories = List<BookingCategoryModel>.from(state.bookingCategories);
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

  /// Set recurrent pattern
  void setRecurrentPattern(RecurrentPatternModel pattern) {
    state = state.copyWith(recurrentPattern: pattern);
  }

  /// Validate slug
  Future<void> validateSlug(String slug) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final repository = ClassesRepository(apiService: GraphQLClientSingleton());
      final isValid = await repository.validateSlug(slug);
      
      state = state.copyWith(
        isSlugValid: isValid,
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
      
      final repository = ClassesRepository(apiService: GraphQLClientSingleton());
      final success = await repository.createClass(state.classModel!);
      
      if (success) {
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

  /// Remove a question at the given index
  void removeQuestion(int index) {
    final questions = List<QuestionModel>.from(state.questions);
    questions.removeAt(index);
    state = state.copyWith(questions: questions);
  }

  /// Set class from existing slug (simplified version)
  Future<void> setClassFromExisting(String slug, bool isEditing, bool setFromTemplate) async {
    // TODO: Implement full setClassFromExisting logic
    // For now, just clear the state and set a basic class model
    state = EventCreationAndEditingState(
      classModel: _createEmptyClassModel(),
    );
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

  /// Test constructor for unit tests
  EventCreationAndEditingNotifier.test() 
      : super(EventCreationAndEditingState(
          classModel: _createEmptyClassModel(),
        ));
}

/// Provider for event creation and editing state
final eventCreationAndEditingProvider = 
    StateNotifierProvider<EventCreationAndEditingNotifier, EventCreationAndEditingState>((ref) {
  return EventCreationAndEditingNotifier();
});
