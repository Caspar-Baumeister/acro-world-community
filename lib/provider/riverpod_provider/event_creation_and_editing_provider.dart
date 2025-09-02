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
