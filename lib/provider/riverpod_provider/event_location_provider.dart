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
    String? locationName,
    LatLng? location,
    String? locationDescription,
    String? countryCode,
    String? region,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventLocationState(
      locationName: locationName ?? this.locationName,
      location: location ?? this.location,
      locationDescription: locationDescription ?? this.locationDescription,
      countryCode: countryCode ?? this.countryCode,
      region: region ?? this.region,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

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
  void setRegion(String region) {
    state = state.copyWith(region: region);
  }

  /// Set country
  void setCountry(String? country) {
    // TODO: Implement country setting logic
    state = state.copyWith(countryCode: country);
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
    state = state.copyWith(
      locationName: locationName,
      location: location,
      locationDescription: locationDescription,
      countryCode: countryCode,
      region: region,
    );
  }
}

/// Provider for event location information
final eventLocationProvider =
    StateNotifierProvider<EventLocationNotifier, EventLocationState>((ref) {
  return EventLocationNotifier();
});
