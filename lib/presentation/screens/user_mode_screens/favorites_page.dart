import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/buttons/past_events_filter_button.dart';
import 'package:acroworld/presentation/components/cards/favorite_event_card.dart';
import 'package:acroworld/presentation/components/loading/modern_loading_widget.dart';
import 'package:acroworld/presentation/components/sections/month_header.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/provider/riverpod_provider/favorite_events_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Load favorite events when the page is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoriteEventsProvider.notifier).loadFavoriteEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteEventsState = ref.watch(favoriteEventsProvider);

    return BasePage(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "My Favorites",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: false,
        elevation: 0,
      ),
      child: FavoritesBody(
        state: favoriteEventsState,
        onRefresh: () => ref.read(favoriteEventsProvider.notifier).refresh(),
        onTogglePastEvents: () => ref.read(favoriteEventsProvider.notifier).togglePastEvents(),
        onLoadMore: () => ref.read(favoriteEventsProvider.notifier).loadMore(),
      ),
    );
  }
}

class FavoritesBody extends StatefulWidget {
  final FavoriteEventsState state;
  final VoidCallback onRefresh;
  final VoidCallback onTogglePastEvents;
  final VoidCallback onLoadMore;

  const FavoritesBody({
    super.key,
    required this.state,
    required this.onRefresh,
    required this.onTogglePastEvents,
    required this.onLoadMore,
  });

  @override
  State<FavoritesBody> createState() => _FavoritesBodyState();
}

class _FavoritesBodyState extends State<FavoritesBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.isLoading && widget.state.events.isEmpty) {
      return const ModernLoadingWidget();
    }

    if (widget.state.error != null && widget.state.events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load favorite events',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.state.error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onRefresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (widget.state.events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No Favorite Events',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Start favoriting classes to see their events here!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: Column(
        children: [
          // Filter Button
          PastEventsFilterButton(
            showPastEvents: widget.state.showPastEvents,
            onToggle: widget.onTogglePastEvents,
          ),
          
          // Events List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: widget.state.events.length + (widget.state.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= widget.state.events.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final event = widget.state.events[index];
                final isPastEvent = event.startDate != null && 
                    DateTime.parse(event.startDate!).isBefore(DateTime.now());

                // Add month header if this is the first event of a new month
                final shouldShowMonthHeader = _shouldShowMonthHeader(index, widget.state.events);
                
                return Column(
                  children: [
                    if (shouldShowMonthHeader)
                      MonthHeader(
                        monthYear: _getMonthYear(DateTime.parse(event.startDate!)),
                        isFirst: index == 0,
                      ),
                    FavoriteEventCard(
                      event: event,
                      isPastEvent: isPastEvent,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowMonthHeader(int index, List<ClassEvent> events) {
    if (index == 0) return true;
    
    final currentEvent = events[index];
    final previousEvent = events[index - 1];
    
    if (currentEvent.startDate == null || previousEvent.startDate == null) {
      return false;
    }
    
    final currentMonth = DateTime(DateTime.parse(currentEvent.startDate!).year, DateTime.parse(currentEvent.startDate!).month);
    final previousMonth = DateTime(DateTime.parse(previousEvent.startDate!).year, DateTime.parse(previousEvent.startDate!).month);
    
    return !currentMonth.isAtSameMomentAs(previousMonth);
  }

  String _getMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
