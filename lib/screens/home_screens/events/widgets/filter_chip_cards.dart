import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CountryFilterCards extends StatelessWidget {
  const CountryFilterCards({super.key});

  @override
  Widget build(BuildContext context) {
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    return Wrap(
      spacing: 6.0, // gap between adjacent chips
      runSpacing: 0, // gap between lines
      children: <Widget>[
        ...eventFilterProvider.initialCountries
            .where((country) => country.isNotEmpty)
            .map((String country) {
          bool isSelected =
              eventFilterProvider.activeCountries.contains(country);
          return GestureDetector(
            onTap: () => eventFilterProvider.changeActiveCountry(country),
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
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    return Wrap(
      spacing: 6.0, // gap between adjacent chips
      runSpacing: 0, // gap between lines
      children: <Widget>[
        GestureDetector(
          onTap: () => eventFilterProvider.changeHighlighted(),
          child: FilterChipCard(
            label: "Highlights",
            isActive: eventFilterProvider.onlyHighlighted,
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
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');

    return Wrap(
      spacing: 6.0, // gap between adjacent chips
      runSpacing: 0.0, // gap between lines
      children: <Widget>[
        ...eventFilterProvider.initialCategories.map((String category) {
          bool isSelected =
              eventFilterProvider.activeCategories.contains(category);

          return GestureDetector(
            onTap: () => eventFilterProvider.changeActiveCategory(category),
            child: FilterChipCard(
              label: capitalizeWords(category
                  .replaceAllMapped(exp, (Match m) => (' ${m.group(0)}'))
                  .toLowerCase()),
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
//     EventFilterProvider eventFilterProvider =
//         Provider.of<EventFilterProvider>(context);

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
//                       style: H12W4.copyWith(
//                           color: isSelected ? Colors.white : PRIMARY_COLOR),
//                     ),
//                     Text(
//                       DateFormat.y().format(date),
//                       style: H10W4.copyWith(
//                           color: isSelected ? Colors.white : PRIMARY_COLOR),
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
    final EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    final List<DateTime> allDates = eventFilterProvider.initialDates..sort();

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
                      eventFilterProvider.activeDates, date);
                  return GestureDetector(
                    onTap: () =>
                        eventFilterProvider.changeActiveEventDates(date),
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
        style: H12W4.copyWith(color: isActive ? Colors.white : PRIMARY_COLOR),
      ),
      labelPadding: const EdgeInsets.all(0.0),
      backgroundColor: isActive ? ACTIVE_COLOR : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      side: const BorderSide(color: Colors.grey, width: 1.0),
    );
  }
}
