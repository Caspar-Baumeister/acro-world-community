import 'dart:typed_data';

import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'event_creation_coordinator_provider.dart';

/// State for basic event information
class EventBasicInfoState {
  final String title;
  final String slug;
  final String description;
  final String? eventType;
  final Uint8List? eventImage;
  final String? existingImageUrl;
  final bool? isSlugValid;
  final bool? isSlugAvailable;
  final bool isLoading;
  final String? errorMessage;

  const EventBasicInfoState({
    this.title = '',
    this.slug = '',
    this.description = '',
    this.eventType,
    this.eventImage,
    this.existingImageUrl,
    this.isSlugValid,
    this.isSlugAvailable,
    this.isLoading = false,
    this.errorMessage,
  });

  EventBasicInfoState copyWith({
    String? title,
    String? slug,
    String? description,
    String? eventType,
    Uint8List? eventImage,
    String? existingImageUrl,
    bool? isSlugValid,
    bool? isSlugAvailable,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventBasicInfoState(
      title: title ?? this.title,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      eventType: eventType ?? this.eventType,
      eventImage: eventImage ?? this.eventImage,
      existingImageUrl: existingImageUrl ?? this.existingImageUrl,
      isSlugValid: isSlugValid ?? this.isSlugValid,
      isSlugAvailable: isSlugAvailable ?? this.isSlugAvailable,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier for basic event information
class EventBasicInfoNotifier extends StateNotifier<EventBasicInfoState> {
  final Ref? ref;

  EventBasicInfoNotifier({this.ref}) : super(const EventBasicInfoState());

  /// Set event title
  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  /// Set event slug
  void setSlug(String slug) {
    state = state.copyWith(slug: slug);
  }

  /// Set event description
  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  /// Set event type
  void setEventType(String eventType) {
    state = state.copyWith(eventType: eventType);
  }

  /// Set event image
  void setEventImage(Uint8List image) {
    state = state.copyWith(eventImage: image, existingImageUrl: null);
  }

  /// Set existing image URL
  void setExistingImageUrl(String imageUrl) {
    state = state.copyWith(existingImageUrl: imageUrl, eventImage: null);
  }

  /// Clear image
  void clearImage() {
    state = state.copyWith(eventImage: null, existingImageUrl: null);
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

  /// Clear slug validation state
  void clearSlugValidation() {
    state = state.copyWith(
        isSlugValid: null, isSlugAvailable: null, errorMessage: null);
  }

  /// Reset state
  void reset() {
    state = const EventBasicInfoState();
  }

  /// Set from template data
  void setFromTemplate({
    required String title,
    required String slug,
    required String description,
    required String? eventType,
    required String? existingImageUrl,
  }) {
    state = EventBasicInfoState(
      title: title,
      slug: slug,
      description: description,
      eventType: eventType,
      existingImageUrl: existingImageUrl,
      eventImage: null,
      isSlugValid: null,
      isSlugAvailable: null,
      isLoading: false,
      errorMessage: null,
    );
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

    // If editing and slug matches original, skip availability check
    if (ref != null) {
      try {
        final coordinator = ref!.read(eventCreationCoordinatorProvider);
        if (coordinator.isEditing &&
            coordinator.originalSlug != null &&
            slug.toLowerCase() == coordinator.originalSlug!.toLowerCase()) {
          CustomErrorHandler.logDebug(
              'Slug matches original when editing, marking as available');
          state = state.copyWith(isSlugValid: true, isSlugAvailable: true);
          return;
        }
      } catch (e) {
        CustomErrorHandler.logError('Error checking coordinator state: $e');
      }
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
}

/// Provider for basic event information
final eventBasicInfoProvider =
    StateNotifierProvider<EventBasicInfoNotifier, EventBasicInfoState>((ref) {
  return EventBasicInfoNotifier(ref: ref);
});
