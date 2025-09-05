import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FavoriteEventsState {
  final List<ClassEvent> events;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final bool showPastEvents;

  FavoriteEventsState({
    this.events = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.showPastEvents = false,
  });

  FavoriteEventsState copyWith({
    List<ClassEvent>? events,
    bool? isLoading,
    bool? hasMore,
    String? error,
    bool? showPastEvents,
  }) {
    return FavoriteEventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      showPastEvents: showPastEvents ?? this.showPastEvents,
    );
  }
}

class FavoriteEventsNotifier extends StateNotifier<FavoriteEventsState> {
  FavoriteEventsNotifier() : super(FavoriteEventsState());

  static const int _pageSize = 20;
  int _currentOffset = 0;

  Future<void> loadFavoriteEvents({bool refresh = false}) async {
    if (refresh) {
      _currentOffset = 0;
      state = state.copyWith(
        events: [],
        isLoading: true,
        error: null,
        hasMore: true,
      );
    } else if (state.isLoading || !state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoading: true);
    }

    try {
      final client = GraphQLClientSingleton().client;
      final result = await client.query(
        QueryOptions(
          document: state.showPastEvents 
              ? Queries.userFavoriteClassEventsAll 
              : Queries.userFavoriteClassEventsUpcoming,
          variables: {
            'limit': _pageSize,
            'offset': _currentOffset,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ?? 'Failed to load favorite events');
      }

      final data = result.data;
      if (data == null || data['me'] == null) {
        throw Exception('No data received');
      }

      final meData = data['me'] as List<dynamic>?;
      if (meData == null || meData.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
        );
        return;
      }

      final favoriteData = meData[0]['class_favorits'] as List<dynamic>?;
      if (favoriteData == null) {
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
        );
        return;
      }

      List<ClassEvent> newEvents = [];
      
      // Debug logging
      print('DEBUG: favoriteData length: ${favoriteData.length}');
      if (favoriteData.isNotEmpty) {
        print('DEBUG: first favorite keys: ${favoriteData[0].keys.toList()}');
        print('DEBUG: first favorite classes type: ${favoriteData[0]['classes'].runtimeType}');
        print('DEBUG: first favorite classes value: ${favoriteData[0]['classes']}');
      }
      
      for (final favorite in favoriteData) {
        // Handle both cases: classes as a single object or as a list
        final classesData = favorite['classes'];
        List<dynamic> classes = [];
        
        if (classesData is List) {
          classes = classesData;
        } else if (classesData is Map) {
          classes = [classesData];
        }
        
        for (final classData in classes) {
          final classEvents = classData['class_events'] as List<dynamic>?;
          if (classEvents != null) {
            for (final eventData in classEvents) {
              try {
                final classEvent = ClassEvent.fromJson(eventData);
                newEvents.add(classEvent);
              } catch (e) {
                CustomErrorHandler.captureException('Error parsing class event: $e');
              }
            }
          }
        }
      }

      // Sort events by start date
      newEvents.sort((a, b) => a.startDate!.compareTo(b.startDate!));

      final allEvents = refresh ? newEvents : [...state.events, ...newEvents];
      
      state = state.copyWith(
        events: allEvents,
        isLoading: false,
        hasMore: newEvents.length == _pageSize,
        error: null,
      );

      _currentOffset += _pageSize;
    } catch (e, stackTrace) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> togglePastEvents() async {
    state = state.copyWith(showPastEvents: !state.showPastEvents);
    await loadFavoriteEvents(refresh: true);
  }

  Future<void> refresh() async {
    await loadFavoriteEvents(refresh: true);
  }

  Future<void> loadMore() async {
    if (!state.isLoading && state.hasMore) {
      await loadFavoriteEvents();
    }
  }
}

final favoriteEventsProvider = StateNotifierProvider<FavoriteEventsNotifier, FavoriteEventsState>(
  (ref) => FavoriteEventsNotifier(),
);
