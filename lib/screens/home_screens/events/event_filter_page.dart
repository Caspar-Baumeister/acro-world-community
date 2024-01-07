import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/screens/home_screens/events/widgets/filter_chip_cards.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventFilterPage extends StatelessWidget {
  const EventFilterPage({super.key});

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
                      "Dates",
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
