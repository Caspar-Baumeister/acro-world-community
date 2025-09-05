import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/appbar/base_appbar.dart';
import 'package:acroworld/presentation/components/sections/responsive_event_list.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventSearchPage extends ConsumerStatefulWidget {
  const EventSearchPage({super.key});

  @override
  ConsumerState<EventSearchPage> createState() => _EventSearchPageState();
}

class _EventSearchPageState extends ConsumerState<EventSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discoveryState = ref.watch(discoveryProvider);

    // Filter events based on search query
    List<ClassEvent> filteredEvents = discoveryState.filteredEventOccurences
        .where((ClassEvent event) =>
            event.classModel?.name != null &&
            event.classModel!.name!
                .toLowerCase()
                .contains(_query.toLowerCase()))
        .toList();

    filteredEvents.sort((a, b) => a.startDate!.compareTo(b.startDate!));

    // Convert to EventCardData and display in grid
    final eventCardData = filteredEvents
        .map((event) => EventCardData.fromClassEvent(event))
        .toList();

    return Scaffold(
      appBar: BaseAppbar(
        leading: IconButton(
          padding: const EdgeInsets.only(left: 0),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search events...',
            border: InputBorder.none,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.6),
                ),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                _searchController.clear();
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ResponsiveEventList(
          events: eventCardData,
          isGridMode: true,
          isLoading: false,
        ),
      ),
    );
  }
}
