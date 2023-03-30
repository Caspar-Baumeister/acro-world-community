import 'package:acroworld/components/standart_button.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/utils/colors.dart';
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
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Categories",
                      style: BIG_TEXT_STYLE,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CategorieFilterCards()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Months",
                      style: BIG_TEXT_STYLE,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    DateFilterCards()
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: Text(
                    "${eventFilterProvider.activeEvents.length.toString()} results",
                    style: STANDART_TEXT_STYLE,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30)
                    .copyWith(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StandartButton(
                      text: "Reset",
                      onPressed: () {
                        eventFilterProvider.resetFilter();

                        Navigator.of(context).pop();
                      },
                      width: buttonWidth,
                    ),
                    StandartButton(
                      text: "Apply",
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      isFilled: true,
                      width: buttonWidth,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class CategorieFilterCards extends StatelessWidget {
  const CategorieFilterCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    return Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: <Widget>[
        ...eventFilterProvider.initialCategories.map((String category) {
          bool isSelected =
              eventFilterProvider.activeCategories.contains(category);
          return GestureDetector(
            onTap: () => eventFilterProvider.changeActiveCategory(category),
            child: Chip(
              label: Text(
                category,
                style: SMALL_TEXT_STYLE.copyWith(
                    color: isSelected ? Colors.white : PRIMARY_COLOR),
              ),
              labelPadding: const EdgeInsets.all(2.0),
              backgroundColor: isSelected ? ACTIVE_COLOR : Colors.white,
              elevation: 6.0,
              shadowColor: Colors.grey[60],
              padding: const EdgeInsets.all(8.0),
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

    int nowMonth = DateTime.now().month;
    List<int> allMonth = eventFilterProvider.initialDates;
    return Wrap(
      spacing: 4.0, // gap between adjacent chips
      runSpacing: 0.0, // gap between lines
      children: <Widget>[
        ...allMonth.map((number) {
          int month = number + nowMonth;
          bool isSelected = eventFilterProvider.activeDates.contains(month);
          return GestureDetector(
            onTap: () => eventFilterProvider.changeActiveEventMonths(month),
            child: Chip(
              label: Text(
                DateFormat.MMMM().format(DateTime(0, month)),
                style: SMALL_TEXT_STYLE.copyWith(
                    color: isSelected ? Colors.white : PRIMARY_COLOR),
              ),
              labelPadding: const EdgeInsets.all(2.0),
              backgroundColor: isSelected ? ACTIVE_COLOR : Colors.white,
              elevation: 6.0,
              shadowColor: Colors.grey[60],
              padding: const EdgeInsets.all(8.0),
            ),
          );
        })
      ],
    );
  }
}
