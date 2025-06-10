import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/filter_page/components/filter_chip_cards.dart';
import 'package:acroworld/provider/discover_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterPageView extends StatelessWidget {
  const FilterPageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DiscoveryProvider discoveryProvider =
        Provider.of<DiscoveryProvider>(context);
    final hasRealRegions = discoveryProvider.filterCountries.any((country) {
      final regions = discoveryProvider.allRegionsByCountry[country] ?? [];
      return regions.any((region) => region != "Not specified");
    });
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
          if (hasRealRegions) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPaddings.small),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Regions",
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 5),
                  const RegionFilterCards(),
                ],
              ),
            ),
          ],
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
          Padding(
            padding: const EdgeInsets.all(AppPaddings.small),
            child: Center(
              child: Text(
                "This filter will show ${discoveryProvider.filteredEventOccurencesLength.toString()} results",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: StandartButton(
              text: "Continue",
              onPressed: () {
                Navigator.of(context).pop();
              },
              isFilled: true,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: StandartButton(
              text: "Reset",
              onPressed: () {
                discoveryProvider.resetFilter();

                Navigator.of(context).pop();
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
