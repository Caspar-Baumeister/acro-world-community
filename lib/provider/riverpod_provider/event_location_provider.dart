import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

/// State for event location information
class EventLocationState {
  final String? locationName;
  final LatLng? location;
  final String? locationDescription;
  final String? countryCode;
  final String? region;
  final bool isLoading;
  final String? errorMessage;

  const EventLocationState({
    this.locationName,
    this.location,
    this.locationDescription,
    this.countryCode,
    this.region,
    this.isLoading = false,
    this.errorMessage,
  });

  EventLocationState copyWith({
    Object? locationName = _undefined,
    Object? location = _undefined,
    Object? locationDescription = _undefined,
    Object? countryCode = _undefined,
    Object? region = _undefined,
    bool? isLoading,
    Object? errorMessage = _undefined,
  }) {
    return EventLocationState(
      locationName: locationName == _undefined
          ? this.locationName
          : locationName as String?,
      location: location == _undefined ? this.location : location as LatLng?,
      locationDescription: locationDescription == _undefined
          ? this.locationDescription
          : locationDescription as String?,
      countryCode:
          countryCode == _undefined ? this.countryCode : countryCode as String?,
      region: region == _undefined ? this.region : region as String?,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _undefined
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

// Sentinel value to distinguish between "not provided" and "set to null"
const _undefined = Object();

/// Notifier for event location information
class EventLocationNotifier extends StateNotifier<EventLocationState> {
  EventLocationNotifier() : super(const EventLocationState());

  /// Set location name
  void setLocationName(String locationName) {
    state = state.copyWith(locationName: locationName);
  }

  /// Set location coordinates
  void setLocation(LatLng location) {
    state = state.copyWith(location: location);
  }

  /// Set location description
  void setLocationDescription(String locationDescription) {
    state = state.copyWith(locationDescription: locationDescription);
  }

  /// Set country code
  void setCountryCode(String countryCode) {
    state = state.copyWith(countryCode: countryCode);
  }

  /// Set region/city
  void setRegion(String? region) {
    state = state.copyWith(region: region);
  }

  /// Set all location data at once
  void setLocationData({
    required String locationName,
    required LatLng location,
    required String? locationDescription,
    required String? countryCode,
    required String? region,
  }) {
    state = state.copyWith(
      locationName: locationName,
      location: location,
      locationDescription: locationDescription,
      countryCode: countryCode,
      region: region,
    );
  }

  /// Clear location data
  void clearLocation() {
    state = state.copyWith(
      locationName: null,
      location: null,
      locationDescription: null,
      countryCode: null,
      region: null,
    );
  }

  /// Reset state
  void reset() {
    state = const EventLocationState();
  }

  /// Set from template data
  void setFromTemplate({
    required String? locationName,
    required LatLng? location,
    required String? locationDescription,
    required String? countryCode,
    required String? region,
  }) {
    state = EventLocationState(
      locationName: locationName,
      location: location,
      locationDescription: locationDescription,
      countryCode: countryCode,
      region: region,
      isLoading: false,
      errorMessage: null,
    );
  }
}

/// Provider for event location information
final eventLocationProvider =
    StateNotifierProvider<EventLocationNotifier, EventLocationState>((ref) {
  return EventLocationNotifier();
});
