import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EventFilterPage extends StatelessWidget {
  const EventFilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    double buttonWidth = MediaQuery.of(context).size.width * 0.4;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Filters"),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: Text(
                    "${eventFilterProvider.activeEvents.length.toString()} results",
                    style: H14W4,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30)
                    .copyWith(bottom: 20),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StandardButton(
                      text: "Reset",
                      onPressed: () {
                        eventFilterProvider.resetFilter();

                        Navigator.of(context).pop();
                      },
                      width: buttonWidth,
                    ),
                    StandardButton(
                      text: "Apply",
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      isFilled: true,
                      width: buttonWidth,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Categories",
                      style: H20W6,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CategorieFilterCards()
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Months",
                      style: H20W6,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    DateFilterCards()
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Countries",
                      style: H20W6,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CountryFilterCards()
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quick filter",
                      style: H20W6,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    QuickFilterCards()
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}

class CountryFilterCards extends StatelessWidget {
  const CountryFilterCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    return Wrap(
      spacing: 6.0, // gap between adjacent chips
      runSpacing: 0, // gap between lines
      children: <Widget>[
        ...eventFilterProvider.initialCountries.map((String country) {
          bool isSelected =
              eventFilterProvider.activeCountries.contains(country);
          return GestureDetector(
            onTap: () => eventFilterProvider.changeActiveCountry(country),
            child: Chip(
              label: Text(
                country,
                style: H12W4.copyWith(
                    color: isSelected ? Colors.white : PRIMARY_COLOR),
              ),
              labelPadding: const EdgeInsets.all(2.0),
              backgroundColor: isSelected ? ACTIVE_COLOR : Colors.white,
              elevation: 6.0,
              shadowColor: Colors.grey[60],
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
            ),
          );
        })
      ],
    );
  }
}

class QuickFilterCards extends StatelessWidget {
  const QuickFilterCards({Key? key}) : super(key: key);

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
          child: Chip(
            label: Text(
              "Highlights",
              style: H12W4.copyWith(
                  color: eventFilterProvider.onlyHighlighted
                      ? Colors.white
                      : PRIMARY_COLOR),
            ),
            labelPadding: const EdgeInsets.all(2.0),
            backgroundColor: eventFilterProvider.onlyHighlighted
                ? ACTIVE_COLOR
                : Colors.white,
            elevation: 6.0,
            shadowColor: Colors.grey[60],
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
          ),
        )
      ],
    );
  }
}

class CategorieFilterCards extends StatelessWidget {
  const CategorieFilterCards({Key? key}) : super(key: key);

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
            child: Chip(
              label: Text(
                capitalizeWords(category
                    .replaceAllMapped(exp, (Match m) => (' ${m.group(0)}'))
                    .toLowerCase()),
                style: H12W4.copyWith(
                    color: isSelected ? Colors.white : PRIMARY_COLOR),
              ),
              labelPadding: const EdgeInsets.all(2.0),
              backgroundColor: isSelected ? ACTIVE_COLOR : Colors.white,
              elevation: 6.0,
              shadowColor: Colors.grey[60],
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
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
class DateFilterCards extends StatelessWidget {
  const DateFilterCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);

    List<DateTime> allMonth = eventFilterProvider.initialDates;
    allMonth.sort();
    return Wrap(
      spacing: 6.0, // gap between adjacent chips
      runSpacing: 0.0, // gap between lines
      children: <Widget>[
        ...allMonth.map((date) {
          bool isSelected =
              isDateMonthAndYearInList(eventFilterProvider.activeDates, date);
          return GestureDetector(
            onTap: () => eventFilterProvider.changeActiveEventDates(date),
            child: Chip(
              label: Container(
                constraints: const BoxConstraints(minWidth: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat.MMMM().format(date),
                      style: H12W4.copyWith(
                          color: isSelected ? Colors.white : PRIMARY_COLOR),
                    ),
                    Text(
                      DateFormat.y().format(date),
                      style: H10W4.copyWith(
                          color: isSelected ? Colors.white : PRIMARY_COLOR),
                    )
                  ],
                ),
              ),
              labelPadding: const EdgeInsets.all(0.0),
              backgroundColor: isSelected ? ACTIVE_COLOR : Colors.white,
              elevation: 6.0,
              shadowColor: Colors.grey[60],
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
            ),
          );
        })
      ],
    );
  }
}
