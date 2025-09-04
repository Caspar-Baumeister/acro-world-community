import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import all the widgets we want to test for compilation
import 'package:acroworld/App.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/discover_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/discover_appbar.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/back_drop_action_row.dart';
import 'package:acroworld/presentation/shells/sidebar.dart';
import 'package:acroworld/presentation/screens/create_creator_profile_pages/create_creator_profile_body.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/error_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/profile_body.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/booking_state_manager.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/stripe_pages/stripe_callback_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/creator_switch_to_user_mode_button.dart';

// Import providers to test they can be accessed
import 'package:acroworld/provider/riverpod_provider/user_role_provider.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/provider/riverpod_provider/place_provider.dart';
import 'package:acroworld/provider/riverpod_provider/event_filter_provider.dart';
import 'package:acroworld/data/models/places/place.dart';
import 'package:acroworld/data/models/class_model.dart';

void main() {
  group('Compilation Tests', () {
    test('All widgets should compile without errors', () {
      // Test that all widget classes can be instantiated without compilation errors
      expect(() => const DiscoverPage(), returnsNormally);
      expect(() => const DiscoveryAppBar(), returnsNormally);
      expect(() => const ShellSideBar(isCreator: false), returnsNormally);
      expect(() => const CreateCreatorProfileBody(), returnsNormally);
      expect(() => const ErrorPage(error: 'Test error'), returnsNormally);
      expect(() => const ProfileBody(), returnsNormally);
      expect(() => const StripeCallbackPage(stripeId: 'test'), returnsNormally);
      expect(() => const CreatorSwitchToUserModeButton(), returnsNormally);
    });

    test('All Riverpod providers should be accessible', () {
      // Test that all our Riverpod providers can be accessed without errors
      expect(() => userRoleProvider, returnsNormally);
      expect(() => discoveryProvider, returnsNormally);
      expect(() => placeProvider, returnsNormally);
      expect(() => eventFilterProvider, returnsNormally);
    });

    test('Provider types should be correct', () {
      // Test that providers have the correct types
      expect(userRoleProvider, isA<StateNotifierProvider<UserRoleNotifier, bool>>());
      expect(discoveryProvider, isA<StateNotifierProvider<DiscoveryNotifier, DiscoveryState>>());
      expect(placeProvider, isA<StateNotifierProvider<PlaceNotifier, Place?>>());
      expect(eventFilterProvider, isA<StateNotifierProvider<EventFilterNotifier, EventFilterState>>());
    });

    test('Widget constructors should have correct parameters', () {
      // Test that widget constructors can be called with correct parameters
      // Note: We can't test with null values since the constructors require non-null parameters
      // This test just ensures the constructors exist and can be called
      expect(() => BackDropActionRow(
        isCollapsed: false,
        classId: 'test-id',
        shareEvents: () {},
        classObject: ClassModel(questions: []), // Minimal required parameters
        classEventId: 'event-id',
      ), returnsNormally);

      expect(() => CleanBookingButton(
        clas: ClassModel(questions: []), // Minimal required parameters
        classEvent: null,
      ), returnsNormally);
    });
  });
}
