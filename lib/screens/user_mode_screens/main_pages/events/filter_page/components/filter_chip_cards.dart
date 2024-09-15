import 'package:acroworld/provider/discover_provider.dart';
import 'package:acroworld/screens/user_mode_screens/main_pages/events/filter_page/components/base_chip_wrapper.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CountryFilterCards extends StatelessWidget {
  const CountryFilterCards({super.key});

  @override
  Widget build(BuildContext context) {
    DiscoveryProvider discoveryProvider =
        Provider.of<DiscoveryProvider>(context);
    return BaseChipWrapper(
      children: <Widget>[
        ...discoveryProvider.allCountries
            .where((country) => country.isNotEmpty)
            .map((String country) {
          bool isSelected = discoveryProvider.filterCountries.contains(country);
          return GestureDetector(
            onTap: () => discoveryProvider.changeActiveCountry(country),
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

class QuickFilterCards extends StatelessWidget {
  const QuickFilterCards({super.key});

  @override
  Widget build(BuildContext context) {
    DiscoveryProvider discoveryProvider =
        Provider.of<DiscoveryProvider>(context);
    return BaseChipWrapper(
      children: <Widget>[
        GestureDetector(
          onTap: () => discoveryProvider.setToOnlyHighlightedFilter(),
          child: FilterChipCard(
            label: "Highlights",
            isActive: discoveryProvider.isOnlyHighlightedFilter,
          ),
        ),
        GestureDetector(
          onTap: () => discoveryProvider.setToOnlyBookableFilter(),
          child: FilterChipCard(
            label: "Bookable Events",
            isActive: discoveryProvider.isOnlyBookableFilter,
          ),
        )
      ],
    );
  }
}

class CategorieFilterCards extends StatelessWidget {
  const CategorieFilterCards({super.key});

  @override
  Widget build(BuildContext context) {
    DiscoveryProvider discoveryProvider =
        Provider.of<DiscoveryProvider>(context);

    return BaseChipWrapper(
      children: <Widget>[
        ...discoveryProvider.allEventTypes.map((EventType eventType) {
          bool isSelected =
              discoveryProvider.filterCategories.contains(eventType);

          return GestureDetector(
            onTap: () => discoveryProvider.changeActiveCategory(eventType),
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

// always shows the next 12 months (March, April, Mai, June, Juli, August,
// September, October, November, December, January, Febuary)
// so it counts from 0 to 11 and shows the current month number (3) + 0,1,2,3,...
// class DateFilterCards extends StatelessWidget {
//   const DateFilterCards({super.key});

//   @override
//   Widget build(BuildContext context) {
//     discoveryProvider discoveryProvider =
//         Provider.of<discoveryProvider>(context);

//     List<DateTime> allMonth = eventFilterProvider.initialDates;
//     allMonth.sort();
//     return Wrap(
//       spacing: 6.0, // gap between adjacent chips
//       runSpacing: 0.0, // gap between lines
//       children: <Widget>[
//         ...allMonth.map((date) {
//           bool isSelected =
//               isDateMonthAndYearInList(eventFilterProvider.activeDates, date);
//           return GestureDetector(
//             onTap: () => eventFilterProvider.changeActiveEventDates(date),
//             child: FilterChipCard(
//               label: Container(
//                 constraints: const BoxConstraints(minWidth: 40),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       DateFormat.MMMM().format(date),
//                       style: Theme.of(context).textTheme.bodySmall.copyWith(
//                           color: isSelected ? Colors.white : CustomColors.primaryColor),
//                     ),
//                     Text(
//                       DateFormat.y().format(date),
//                       style: Theme.of(context).textTheme.labelSmall.copyWith(
//                           color: isSelected ? Colors.white : CustomColors.primaryColor),
//                     )
//                   ],
//                 ),
//               ),
//               isActive: isSelected,
//             ),
//           );
//         })
//       ],
//     );
//   }
// }

class DateFilterCards extends StatelessWidget {
  const DateFilterCards({super.key});

  @override
  Widget build(BuildContext context) {
    final DiscoveryProvider discoveryProvider =
        Provider.of<DiscoveryProvider>(context);
    final List<DateTime> allDates = discoveryProvider.allDates..sort();

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
                      discoveryProvider.filterDates, date);
                  return GestureDetector(
                    onTap: () => discoveryProvider.changeActiveEventDates(date),
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
      {super.key, required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: isActive ? Colors.white : CustomColors.primaryColor),
      ),
      labelPadding: const EdgeInsets.all(0.0),
      backgroundColor: isActive ? CustomColors.primaryColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      side: const BorderSide(color: Colors.grey, width: 1.0),
    );
  }
}
