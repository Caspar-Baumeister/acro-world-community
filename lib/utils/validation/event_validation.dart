import 'dart:typed_data';

import 'package:latlong2/latlong.dart';

/// Event validation utility class
class EventValidation {
  // Title validation
  static String? validateTitle(String title) {
    if (title.trim().isEmpty) {
      return 'Title is required';
    }
    if (title.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (title.trim().length > 100) {
      return 'Title must be less than 100 characters';
    }
    return null;
  }

  // Slug validation
  static String? validateSlug(String slug) {
    if (slug.trim().isEmpty) {
      return 'Slug is required';
    }
    if (slug.trim().length < 3) {
      return 'Slug must be at least 3 characters';
    }
    if (slug.trim().length > 50) {
      return 'Slug must be less than 50 characters';
    }
    if (!RegExp(r'^[a-z0-9-]+$').hasMatch(slug.trim())) {
      return 'Slug can only contain lowercase letters, numbers, and hyphens';
    }
    if (slug.startsWith('-') || slug.endsWith('-')) {
      return 'Slug cannot start or end with a hyphen';
    }
    return null;
  }

  // Description validation
  static String? validateDescription(String description) {
    if (description.trim().isEmpty) {
      return 'Description is required';
    }
    if (description.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    if (description.trim().length > 2000) {
      return 'Description must be less than 2000 characters';
    }
    return null;
  }

  // Location name validation
  static String? validateLocationName(String? locationName) {
    if (locationName == null || locationName.trim().isEmpty) {
      return 'Location name is required';
    }
    if (locationName.trim().length < 2) {
      return 'Location name must be at least 2 characters';
    }
    if (locationName.trim().length > 100) {
      return 'Location name must be less than 100 characters';
    }
    return null;
  }

  // Location coordinates validation
  static String? validateLocation(LatLng? location) {
    if (location == null) {
      return 'Location coordinates are required';
    }
    if (location.latitude < -90 || location.latitude > 90) {
      return 'Invalid latitude value';
    }
    if (location.longitude < -180 || location.longitude > 180) {
      return 'Invalid longitude value';
    }
    return null;
  }

  // Event type validation
  static String? validateEventType(String? eventType) {
    if (eventType == null || eventType.isEmpty) {
      return 'Event type is required';
    }
    final validTypes = [
      'Workshops',
      'FestivalsAndCons',
      'Retreats',
      'Jams',
      'Classes',
      'Trainings'
    ];
    if (!validTypes.contains(eventType)) {
      return 'Invalid event type selected';
    }
    return null;
  }

  // Country code validation
  static String? validateCountryCode(String? countryCode) {
    if (countryCode == null || countryCode.isEmpty) {
      return 'Country is required';
    }
    if (countryCode.length != 2) {
      return 'Invalid country code format';
    }
    if (!RegExp(r'^[A-Z]{2}$').hasMatch(countryCode)) {
      return 'Country code must be 2 uppercase letters';
    }
    return null;
  }

  // Region/City validation
  static String? validateRegion(String? region) {
    if (region == null || region.trim().isEmpty) {
      return 'Region/City is required';
    }
    if (region.trim().length < 2) {
      return 'Region/City must be at least 2 characters';
    }
    if (region.trim().length > 100) {
      return 'Region/City must be less than 100 characters';
    }
    return null;
  }

  // Image validation
  static String? validateImage(Uint8List? image, String? existingImageUrl) {
    if (image == null && existingImageUrl == null) {
      return 'Event image is required';
    }
    return null;
  }

  // Comprehensive event validation
  static Map<String, String?> validateEvent({
    required String title,
    required String slug,
    required String description,
    required String? locationName,
    required LatLng? location,
    required String? eventType,
    required String? countryCode,
    required String? region,
    required Uint8List? image,
    required String? existingImageUrl,
  }) {
    return {
      'title': validateTitle(title),
      'slug': validateSlug(slug),
      'description': validateDescription(description),
      'locationName': validateLocationName(locationName),
      'location': validateLocation(location),
      'eventType': validateEventType(eventType),
      'countryCode': validateCountryCode(countryCode),
      'region': validateRegion(region),
      'image': validateImage(image, existingImageUrl),
    };
  }

  // Check if all validations pass
  static bool isValid(Map<String, String?> validations) {
    return validations.values.every((error) => error == null);
  }

  // Get first validation error
  static String? getFirstError(Map<String, String?> validations) {
    for (final error in validations.values) {
      if (error != null) return error;
    }
    return null;
  }

  // Get all validation errors
  static List<String> getAllErrors(Map<String, String?> validations) {
    return validations.values
        .where((error) => error != null)
        .cast<String>()
        .toList();
  }
}
