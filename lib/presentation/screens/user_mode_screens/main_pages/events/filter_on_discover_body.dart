import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/event_occurence_monthly_sorted_view.dart';
import 'package:acroworld/provider/discover_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This page body has only one downwards scroll with full with cards
class FilterOnDiscoveryBody extends StatelessWidget {
  const FilterOnDiscoveryBody({super.key});

  @override
  Widget build(BuildContext context) {
    DiscoveryProvider discoveryProvider =
        Provider.of<DiscoveryProvider>(context);

    List<ClassEvent> activeEvents = discoveryProvider.filteredEventOccurences;
    activeEvents.sort((a, b) => a.startDate!.compareTo(b.startDate!));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPaddings.medium),
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
                  StandardButton(
                    text: "Reset Filter",
                    onPressed: () {
                      discoveryProvider.resetFilter();
                    },
                  ),
                ],
              ),
            )
          : EventOccurenceMonthlySortedView(sortedEvents: activeEvents),
    );
  }
}
