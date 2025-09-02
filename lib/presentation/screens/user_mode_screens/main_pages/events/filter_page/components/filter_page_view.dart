import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/filter_page/components/filter_chip_cards.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterPageView extends ConsumerWidget {
  const FilterPageView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryState = ref.watch(discoveryProvider);
    final hasRealRegions = discoveryState.filterCountries.any((country) {
      final regions = discoveryState.allRegionsByCountry[country] ?? [];
      return regions.any((region) => region != "Not specified");
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall),
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
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall),
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
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall),
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
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall),
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
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall),
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
            padding: const EdgeInsets.all(AppDimensions.spacingSmall),
            child: Center(
              child: Text(
                "This filter will show ${discoveryState.filteredEventOccurencesLength.toString()} results",
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
                ref.read(discoveryProvider.notifier).resetFilter();

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
