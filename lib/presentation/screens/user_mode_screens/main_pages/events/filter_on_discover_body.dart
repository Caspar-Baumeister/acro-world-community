import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/event_occurence_monthly_grid_view.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This page body has only one downwards scroll with full with cards
class FilterOnDiscoveryBody extends ConsumerWidget {
  const FilterOnDiscoveryBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryState = ref.watch(discoveryProvider);

    List<ClassEvent> activeEvents = discoveryState.filteredEventOccurences;
    activeEvents.sort((a, b) => a.startDate!.compareTo(b.startDate!));



    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: activeEvents.isEmpty
          ? SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "We could not find any events for your search",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ModernButton(
                    text: "Reset Filter",
                    onPressed: () {
                      ref.read(discoveryProvider.notifier).resetFilter();
                    },
                  ),
                ],
              ),
            )
          : EventOccurenceMonthlyGridView(sortedEvents: activeEvents),
    );
  }
}
