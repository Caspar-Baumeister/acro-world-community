import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/cards/modern_event_card.dart';
import 'package:acroworld/presentation/components/input/modern_search_bar.dart';
import 'package:acroworld/theme/modern_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Modern Components', () {
    testWidgets('ModernButton should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ModernTheme.lightTheme,
          home: Scaffold(
            body: ModernButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('ModernEventCard should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ModernTheme.lightTheme,
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: ModernEventCard(
                title: 'Test Event',
                date: '2024-01-01',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Event'), findsOneWidget);
      expect(find.text('2024-01-01'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('ModernSearchBar should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ModernTheme.lightTheme,
          home: Scaffold(
            body: ModernSearchBar(
              hintText: 'Search events...',
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    testWidgets('ModernFilterChip should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ModernTheme.lightTheme,
          home: Scaffold(
            body: ModernFilterChip(
              label: 'Test Filter',
              onSelected: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Filter'), findsOneWidget);
      expect(find.byType(FilterChip), findsOneWidget);
    });

    testWidgets('ModernSectionHeader should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ModernTheme.lightTheme,
          home: Scaffold(
            body: ModernSectionHeader(
              title: 'Test Section',
              subtitle: 'Test Subtitle',
              onViewAll: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Section'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
      expect(find.text('View all'), findsOneWidget);
    });
  });
}
