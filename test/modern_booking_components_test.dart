import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/components/cards/modern_booking_card.dart';
import 'package:acroworld/presentation/components/cards/modern_summary_card.dart';
import 'package:acroworld/theme/modern_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Modern Booking Components', () {
    testWidgets('ModernBookingCard should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ModernTheme.lightTheme,
          home: Scaffold(
            body: ModernBookingCard(
              booking: ClassEventBooking(
                id: 'test-id',
                userId: 'test-user-id',
                classEventId: 'test-event-id',
                amount: 150.0,
                status: 'waiting_for_payment',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                user: null,
                classEvent: null,
              ),
            ),
          ),
        ),
      );

      // The card should render without errors
      expect(find.byType(ModernBookingCard), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('ModernSummaryCard should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ModernTheme.lightTheme,
          home: Scaffold(
            body: ModernSummaryCard(
              title: 'Total amount of bookings',
              value: '13',
              icon: Icons.bookmark,
            ),
          ),
        ),
      );

      expect(find.text('Total amount of bookings'), findsOneWidget);
      expect(find.text('13'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('ModernStatsCard should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ModernTheme.lightTheme,
          home: Scaffold(
            body: ModernStatsCard(
              title: 'Booking Statistics',
              stats: [
                StatItem(
                  label: 'Total',
                  value: '13',
                  icon: Icons.bookmark,
                ),
                StatItem(
                  label: 'Confirmed',
                  value: '10',
                  icon: Icons.check,
                ),
                StatItem(
                  label: 'Pending',
                  value: '3',
                  icon: Icons.schedule,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Booking Statistics'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('13'), findsOneWidget);
      expect(find.text('Confirmed'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });
  });
}
