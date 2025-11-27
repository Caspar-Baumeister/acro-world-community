import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/filter_page/components/base_chip_wrapper.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CountryFilterCards extends ConsumerWidget {
  const CountryFilterCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryState = ref.watch(discoveryProvider);
    return BaseChipWrapper(
      children: <Widget>[
        ...discoveryState.allCountries
            .where((country) => country.isNotEmpty)
            .map((String country) {
          bool isSelected = discoveryState.filterCountries.contains(country);
          return GestureDetector(
            onTap: () => ref
                .read(discoveryProvider.notifier)
                .changeActiveCountry(country),
            child: FilterChipCard(
              label: country,
              isActive: isSelected,
            ),
          );
        })
      ],
    );
  }
}

class RegionFilterCards extends ConsumerWidget {
  const RegionFilterCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryState = ref.watch(discoveryProvider);

    // Collect all regions matching selected countries
    List<String> selectedRegions = [];
    for (var country in discoveryState.filterCountries) {
      if (discoveryState.allRegionsByCountry.containsKey(country)) {
        selectedRegions.addAll(discoveryState.allRegionsByCountry[country]!);
      }
    }
    selectedRegions = selectedRegions.toSet().toList(); // remove duplicates

    // Add 'Not specified' option
    const String notSpecifiedKey = "Not specified";

    return BaseChipWrapper(
      children: <Widget>[
        ...selectedRegions
            .where((region) => region != notSpecifiedKey)
            .map((String region) {
          bool isSelected = discoveryState.filterRegions.contains(region);
          return GestureDetector(
            onTap: () =>
                ref.read(discoveryProvider.notifier).changeActiveRegion(region),
            child: FilterChipCard(
              label: region,
              isActive: isSelected,
            ),
          );
        }),
        GestureDetector(
          onTap: () => ref
              .read(discoveryProvider.notifier)
              .changeActiveRegion(notSpecifiedKey),
          child: FilterChipCard(
            label: notSpecifiedKey,
            isActive: discoveryState.filterRegions.contains(notSpecifiedKey),
          ),
        ),
      ],
    );
  }
}

class QuickFilterCards extends ConsumerWidget {
  const QuickFilterCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryState = ref.watch(discoveryProvider);
    return BaseChipWrapper(
      children: <Widget>[
        GestureDetector(
          onTap: () =>
              ref.read(discoveryProvider.notifier).setToOnlyHighlightedFilter(),
          child: FilterChipCard(
            label: "Highlights",
            isActive: discoveryState.isOnlyHighlightedFilter,
          ),
        ),
        GestureDetector(
          onTap: () =>
              ref.read(discoveryProvider.notifier).setToOnlyBookableFilter(),
          child: FilterChipCard(
            label: "Bookable Events",
            isActive: discoveryState.isOnlyBookableFilter,
          ),
        )
      ],
    );
  }
}

class CategorieFilterCards extends ConsumerWidget {
  const CategorieFilterCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryState = ref.watch(discoveryProvider);

    return BaseChipWrapper(
      children: <Widget>[
        ...discoveryState.allEventTypes.map((EventType eventType) {
          bool isSelected = discoveryState.filterCategories.contains(eventType);

          return GestureDetector(
            onTap: () => ref
                .read(discoveryProvider.notifier)
                .changeActiveCategory(eventType),
            child: FilterChipCard(
              label: eventType.name,
              isActive: isSelected,
            ),
          );
        })
      ],
    );
  }
}

class DateFilterCards extends ConsumerWidget {
  const DateFilterCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryState = ref.watch(discoveryProvider);
    final List<DateTime> allDates = discoveryState.allDates..sort();

    // Group dates by year
    final Map<int, List<DateTime>> datesGroupedByYear = {};
    for (var date in allDates) {
      final year = date.year;
      datesGroupedByYear.putIfAbsent(year, () => []).add(date);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: datesGroupedByYear.entries.map((entry) {
          int year = entry.key;
          List<DateTime> yearDates = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('$year',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal)),
              ),
              Wrap(
                spacing: 6.0,
                runSpacing: 0.0,
                children: yearDates.map((date) {
                  bool isSelected = isDateMonthAndYearInList(
                      discoveryState.filterDates, date);
                  return GestureDetector(
                    onTap: () => ref
                        .read(discoveryProvider.notifier)
                        .changeActiveEventDates(date),
                    child: FilterChipCard(
                      label: DateFormat.MMMM().format(date),
                      isActive: isSelected,
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class FilterChipCard extends StatelessWidget {
  const FilterChipCard(
      {super.key, required this.label, required this.isActive, this.amount});

  final String label;
  final bool isActive;
  final int? amount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Chip(
          label: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: isActive
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface),
          ),
          labelPadding: const EdgeInsets.all(0.0),
          backgroundColor: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          side: BorderSide(
              color: Theme.of(context).colorScheme.outline, width: 1.0),
        ),
        if (amount != null)
          Positioned(
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
              ),
              child: Text(
                '$amount',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
      ],
    );
  }
}
