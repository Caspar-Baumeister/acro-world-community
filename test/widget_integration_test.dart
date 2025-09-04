import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/class_event.dart';

import 'package:acroworld/provider/riverpod_provider/user_role_provider.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/provider/riverpod_provider/place_provider.dart';
import 'package:acroworld/provider/riverpod_provider/event_filter_provider.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('Widget Integration Tests', () {
    testWidgets('App should build without compilation errors', (WidgetTester tester) async {
      // Test that the main App widget can be built without compilation errors
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: App(),
          ),
        ),
      );
      
      // If we get here without compilation errors, the test passes
      expect(find.byType(App), findsOneWidget);
    });

    testWidgets('DiscoverPage should build without compilation errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const DiscoverPage(),
          ),
        ),
      );
      
      expect(find.byType(DiscoverPage), findsOneWidget);
    });

    testWidgets('DiscoveryAppBar should build without compilation errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              appBar: const DiscoveryAppBar(),
              body: const Center(child: Text('Test')),
            ),
          ),
        ),
      );
      
      expect(find.byType(DiscoveryAppBar), findsOneWidget);
    });

    testWidgets('BackDropActionRow should build without compilation errors', (WidgetTester tester) async {
      final mockClassModel = ClassModel(
        id: 'test-id',
        name: 'Test Class',
        description: 'Test Description',
        eventType: EventType.Workshops,
        country: 'Germany',
        city: 'Berlin',
        questions: [],
      );

      final mockClassEvent = ClassEvent(
        id: 'event-id',
        classId: 'test-id',
        startDate: '2024-01-01',
        endDate: '2024-01-01',
        classModel: mockClassModel,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BackDropActionRow(
                isCollapsed: false,
                classId: 'test-id',
                shareEvents: () {},
                classObject: mockClassModel,
                classEventId: 'event-id',
                classEvent: mockClassEvent,
              ),
            ),
          ),
        ),
      );
      
      expect(find.byType(BackDropActionRow), findsOneWidget);
    });

    testWidgets('ShellSideBar should build without compilation errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const ShellSideBar(isCreator: false),
            ),
          ),
        ),
      );
      
      expect(find.byType(ShellSideBar), findsOneWidget);
    });

    testWidgets('CreateCreatorProfileBody should build without compilation errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const CreateCreatorProfileBody(),
          ),
        ),
      );
      
      expect(find.byType(CreateCreatorProfileBody), findsOneWidget);
    });

    testWidgets('ErrorPage should build without compilation errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ErrorPage(error: 'Test error'),
          ),
        ),
      );
      
      expect(find.byType(ErrorPage), findsOneWidget);
    });

    testWidgets('ProfileBody should build without compilation errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ProfileBody(),
          ),
        ),
      );
      
      expect(find.byType(ProfileBody), findsOneWidget);
    });

    testWidgets('CleanBookingButton should build without compilation errors', (WidgetTester tester) async {
      final mockClassModel = ClassModel(
        id: 'test-id',
        name: 'Test Class',
        description: 'Test Description',
        eventType: EventType.Workshops,
        country: 'Germany',
        city: 'Berlin',
        questions: [],
      );

      final mockClassEvent = ClassEvent(
        id: 'event-id',
        classId: 'test-id',
        startDate: '2024-01-01',
        endDate: '2024-01-01',
        classModel: mockClassModel,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CleanBookingButton(
                clas: mockClassModel,
                classEvent: mockClassEvent,
              ),
            ),
          ),
        ),
      );
      
      expect(find.byType(CleanBookingButton), findsOneWidget);
    });

    testWidgets('StripeCallbackPage should build without compilation errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const StripeCallbackPage(stripeId: 'test-stripe-id'),
          ),
        ),
      );
      
      expect(find.byType(StripeCallbackPage), findsOneWidget);
    });

    testWidgets('CreatorSwitchToUserModeButton should build without compilation errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const CreatorSwitchToUserModeButton(),
            ),
          ),
        ),
      );
      
      expect(find.byType(CreatorSwitchToUserModeButton), findsOneWidget);
    });

    testWidgets('All Riverpod providers should be accessible', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final container = ProviderScope.containerOf(context);
                
                // Test that all our Riverpod providers can be accessed without errors
                expect(() => container.read(userRoleProvider), returnsNormally);
                expect(() => container.read(discoveryProvider), returnsNormally);
                expect(() => container.read(placeProvider), returnsNormally);
                expect(() => container.read(eventFilterProvider), returnsNormally);
                
                return const Center(child: Text('Provider test passed'));
              },
            ),
          ),
        ),
      );
      
      expect(find.text('Provider test passed'), findsOneWidget);
    });
  });
}
