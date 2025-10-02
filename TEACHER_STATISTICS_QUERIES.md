# Teacher Statistics Queries Documentation

This document outlines all the GraphQL queries used for fetching teacher statistics in the AcroWorld app.

## Overview

The teacher statistics system displays 5 key metrics on teacher profiles:

1. **Events** - Total classes/events created by the teacher
2. **Rating** - Average rating from reviews (1-5 stars)
3. **Reviews** - Total number of reviews received
4. **Participated** - Events where the teacher participated as a student
5. **Booked** - Times the teacher was booked for events by students

## Query Details

### 1. Comments Statistics (Reviews & Rating)

**Query**: `getCommentsStatsForTeacher`

```graphql
query getCommentsStatsForTeacher($teacher_id: uuid!) {
  comments_aggregate(where: {teacher_id: {_eq: $teacher_id}}) {
    aggregate {
      count
      avg {
        rating
      }
    }
  }
}
```

**Purpose**: Fetches aggregated review statistics for a specific teacher
- **count**: Total number of reviews/comments
- **avg.rating**: Average rating (1.0 - 5.0)

**Database Table**: `comments`
**Filters**: `teacher_id = $teacher_id`

### 2. Teacher Events Statistics

**Query**: `getTeacherEventsStats`

```graphql
query getTeacherEventsStats($teacher_id: uuid!) {
  classes_aggregate(where: {teacher_id: {_eq: $teacher_id}}) {
    aggregate {
      count
    }
  }
}
```

**Purpose**: Counts total classes/events created by the teacher
- **count**: Total number of classes created

**Database Table**: `classes`
**Filters**: `teacher_id = $teacher_id`

### 3. Teacher Participated Events Statistics

**Query**: `getTeacherParticipatedEventsStats`

```graphql
query getTeacherParticipatedEventsStats($teacher_id: uuid!) {
  class_events_aggregate(where: {class: {teacher_id: {_eq: $teacher_id}}}) {
    aggregate {
      count
    }
  }
}
```

**Purpose**: Counts total class events where the teacher participated
- **count**: Total number of class events created by the teacher

**Database Table**: `class_events` (joined with `classes`)
**Filters**: `class.teacher_id = $teacher_id`

**Note**: This query counts class events, not individual classes. If a teacher creates a recurring class with 10 events, this will count 10.

### 4. Teacher Bookings Statistics

**Query**: `getTeacherBookingsStats`

```graphql
query getTeacherBookingsStats($teacher_id: uuid!) {
  class_event_bookings_aggregate(where: {class_event: {class: {teacher_id: {_eq: $teacher_id}}}}) {
    aggregate {
      count
    }
  }
}
```

**Purpose**: Counts total bookings made for the teacher's events
- **count**: Total number of bookings for the teacher's events

**Database Table**: `class_event_bookings` (joined with `class_events` and `classes`)
**Filters**: `class_event.class.teacher_id = $teacher_id`

## Data Flow

1. **Provider Initialization**: `teacherStatisticsProvider(teacherId)` is called
2. **Parallel Execution**: All 4 queries are executed simultaneously using `Future.wait()`
3. **Data Aggregation**: Results are parsed and combined into `TeacherStatistics` model
4. **UI Display**: Statistics are displayed in the teacher profile header

## Current Issues

1. **No Caching**: Each profile visit triggers fresh queries
2. **No Error Recovery**: Individual query failures can break the entire statistics display
3. **No Loading States**: Loading states are basic and don't show progress
4. **No Refresh Mechanism**: No way to manually refresh statistics
5. **Duplicate Code**: Both `FutureProvider` and `StateNotifier` implementations exist

## Proposed Improvements

1. **Clean Architecture**: Separate data layer from presentation layer
2. **Error Handling**: Graceful degradation when individual queries fail
3. **Caching**: Implement smart caching with TTL
4. **Loading States**: Better loading indicators with partial data display
5. **Refresh Mechanism**: Pull-to-refresh and manual refresh capabilities
6. **Performance**: Optimize queries and reduce network calls

## Usage in UI

The statistics are displayed in `ModernTeacherHeader` widget:

```dart
Consumer(
  builder: (context, ref, child) {
    final statisticsAsync = ref.watch(teacherStatisticsProvider(teacher.id!));
    
    return statisticsAsync.when(
      data: (statistics) => Row(
        children: [
          _buildStatItem(context, "Events", statistics.totalEvents.toString(), Icons.event),
          _buildStatItem(context, "Rating", statistics.averageRating.toStringAsFixed(1), Icons.star),
          _buildStatItem(context, "Reviews", statistics.totalReviews.toString(), Icons.rate_review),
          _buildStatItem(context, "Participated", statistics.eventsParticipated.toString(), Icons.event_available),
          _buildStatItem(context, "Booked", statistics.timesBooked.toString(), Icons.book_online),
        ],
      ),
      loading: () => /* Loading skeleton */,
      error: (error, stack) => /* Error state */,
    );
  },
)
```

## Verification Checklist

- [ ] **Events**: Verify count matches classes created by teacher in database
- [ ] **Rating**: Verify average matches manual calculation of all ratings for teacher
- [ ] **Reviews**: Verify count matches total comments for teacher
- [ ] **Participated**: Verify count matches class_events for teacher's classes
- [ ] **Booked**: Verify count matches bookings for teacher's class events
- [ ] **Performance**: All queries execute within reasonable time (<2s)
- [ ] **Error Handling**: Graceful fallback when queries fail
- [ ] **Caching**: Statistics persist between profile visits
