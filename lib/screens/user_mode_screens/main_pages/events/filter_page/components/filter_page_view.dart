import 'package:acroworld/screens/user_mode_screens/main_pages/events/filter_page/components/filter_chip_cards.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class FilterPageView extends StatelessWidget {
  const FilterPageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPaddings.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppPaddings.small),
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
            padding: const EdgeInsets.symmetric(vertical: AppPaddings.small),
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
            padding: const EdgeInsets.symmetric(vertical: AppPaddings.small),
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
            padding: const EdgeInsets.symmetric(vertical: AppPaddings.small),
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
    );
  }
}
