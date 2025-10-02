# Teacher Statistics V2 Usage Examples

This document shows how to use the new enhanced teacher statistics provider with clean architecture and better error handling.

## Basic Usage

### 1. Simple Statistics Display

```dart
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/widgets/enhanced_teacher_statistics.dart';

// In your teacher profile widget
class TeacherProfileWidget extends StatelessWidget {
  final String teacherId;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Use the enhanced statistics widget
        EnhancedTeacherStatistics(
          teacherId: teacherId,
          showLabels: true,
        ),
      ],
    );
  }
}
```

### 2. Compact Statistics (without labels)

```dart
// For space-constrained layouts
CompactTeacherStatistics(teacherId: teacherId)
```

### 3. Manual Provider Usage

```dart
import 'package:acroworld/provider/riverpod_provider/teacher_statistics_provider_v2.dart';

class CustomStatisticsWidget extends ConsumerWidget {
  final String teacherId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(teacherStatisticsV2Provider(teacherId));
    final notifier = ref.read(teacherStatisticsNotifierV2Provider(teacherId).notifier);
    
    return Column(
      children: [
        // Display statistics
        Row(
          children: [
            _buildStatItem('Events', state.statistics.totalEvents.toString()),
            _buildStatItem('Rating', state.statistics.averageRating.toStringAsFixed(1)),
            _buildStatItem('Reviews', state.statistics.totalReviews.toString()),
          ],
        ),
        
        // Show loading state
        if (state.isLoading)
          const CircularProgressIndicator(),
          
        // Show errors
        if (state.hasErrors)
          Column(
            children: state.errors.entries.map((entry) => 
              Text('Error in ${entry.key}: ${entry.value}')
            ).toList(),
          ),
          
        // Refresh button
        ElevatedButton(
          onPressed: () => notifier.refresh(),
          child: const Text('Refresh'),
        ),
      ],
    );
  }
}
```

## Advanced Usage

### 1. Individual Statistic Loading

```dart
// Load specific statistics individually
final notifier = ref.read(teacherStatisticsNotifierV2Provider(teacherId).notifier);

// Load only events statistics
await notifier.loadEventsStats();

// Load only comments/reviews statistics
await notifier.loadCommentsStats();

// Load all statistics at once
await notifier.loadStatistics();
```

### 2. Error Handling with Retry

```dart
class StatisticsWithRetry extends ConsumerWidget {
  final String teacherId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(teacherStatisticsV2Provider(teacherId));
    final notifier = ref.read(teacherStatisticsNotifierV2Provider(teacherId).notifier);
    
    if (state.hasErrors) {
      return Column(
        children: [
          Text('Some statistics failed to load'),
          // Retry specific statistics
          ...state.errors.keys.map((statName) => 
            ElevatedButton(
              onPressed: () {
                switch (statName) {
                  case 'events':
                    notifier.loadEventsStats();
                    break;
                  case 'comments':
                    notifier.loadCommentsStats();
                    break;
                  case 'participated':
                    notifier.loadParticipatedStats();
                    break;
                  case 'bookings':
                    notifier.loadBookingsStats();
                    break;
                }
              },
              child: Text('Retry $statName'),
            ),
          ),
        ],
      );
    }
    
    return Text('Statistics loaded successfully');
  }
}
```

### 3. Caching and Stale Data Detection

```dart
class SmartStatisticsWidget extends ConsumerWidget {
  final String teacherId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(teacherStatisticsV2Provider(teacherId));
    final notifier = ref.read(teacherStatisticsNotifierV2Provider(teacherId).notifier);
    
    // Check if data is stale (older than 5 minutes)
    final isStale = notifier.shouldRefresh();
    
    return Column(
      children: [
        // Show statistics
        Text('Events: ${state.statistics.totalEvents}'),
        Text('Rating: ${state.statistics.averageRating}'),
        
        // Show stale data indicator
        if (isStale)
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info, size: 16),
                SizedBox(width: 8),
                Text('Data may be outdated'),
                Spacer(),
                TextButton(
                  onPressed: () => notifier.refresh(),
                  child: Text('Refresh'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
```

### 4. Pull-to-Refresh Integration

```dart
class RefreshableStatistics extends ConsumerWidget {
  final String teacherId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(teacherStatisticsNotifierV2Provider(teacherId).notifier);
    
    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: ListView(
        children: [
          EnhancedTeacherStatistics(teacherId: teacherId),
          // Other content
        ],
      ),
    );
  }
}
```

## Migration from V1

### Before (V1)
```dart
// Old way - basic provider
final statisticsAsync = ref.watch(teacherStatisticsProvider(teacherId));

return statisticsAsync.when(
  data: (statistics) => Row(
    children: [
      Text('Events: ${statistics.totalEvents}'),
      Text('Rating: ${statistics.averageRating}'),
    ],
  ),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

### After (V2)
```dart
// New way - enhanced provider with better error handling
final state = ref.watch(teacherStatisticsV2Provider(teacherId));

return Column(
  children: [
    // Statistics with individual error handling
    Row(
      children: [
        _buildStatWithError('Events', state.statistics.totalEvents, 
                           state.getErrorForStat('events')),
        _buildStatWithError('Rating', state.statistics.averageRating, 
                           state.getErrorForStat('comments')),
      ],
    ),
    
    // Show individual loading states
    if (state.isLoadingStat('events'))
      Text('Loading events...'),
      
    // Show refresh button for stale data
    if (state.hasData && notifier.shouldRefresh())
      ElevatedButton(
        onPressed: () => notifier.refresh(),
        child: Text('Refresh'),
      ),
  ],
);
```

## Benefits of V2

1. **Better Error Handling**: Individual statistics can fail without breaking the entire display
2. **Partial Loading**: Show available data while loading missing statistics
3. **Caching**: Smart caching with stale data detection
4. **Retry Mechanisms**: Retry individual failed statistics
5. **Clean Architecture**: Separated repository pattern for better testability
6. **Performance**: Parallel loading and cache-first strategies
7. **User Experience**: Better loading states and error recovery

## Testing

```dart
// Test the repository
testWidgets('Teacher statistics repository', (tester) async {
  final repository = TeacherStatisticsRepositoryImpl(mockClient);
  
  final result = await repository.getEventsStats('teacher-id');
  
  expect(result.name, 'events');
  expect(result.value, isA<int>());
  expect(result.error, isNull);
});

// Test the notifier
testWidgets('Teacher statistics notifier', (tester) async {
  final notifier = TeacherStatisticsNotifierV2(mockRepository, 'teacher-id');
  
  await notifier.loadStatistics();
  
  expect(notifier.state.hasData, true);
  expect(notifier.state.isLoading, false);
});
```
