import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/screens/main_pages/events/widgets/filter_chip_cards.dart';
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
                    style: Theme.of(context).textTheme.bodyLarge,
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Categories",
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(
                      height: 5,
                    ),
                    const CategorieFilterCards()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dates",
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(
                      height: 5,
                    ),
                    const DateFilterCards()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Countries",
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(
                      height: 5,
                    ),
                    const CountryFilterCards()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Quick filter",
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(
                      height: 5,
                    ),
                    const QuickFilterCards()
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
