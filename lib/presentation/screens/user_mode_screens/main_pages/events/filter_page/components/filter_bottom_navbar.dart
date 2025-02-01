import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/provider/discover_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterBottomNavbar extends StatelessWidget {
  const FilterBottomNavbar({
    super.key,
    required this.buttonWidth,
  });

  final double buttonWidth;

  @override
  Widget build(BuildContext context) {
    DiscoveryProvider discoveryProvider =
        Provider.of<DiscoveryProvider>(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppPaddings.small).copyWith(top: 5),
            child: Center(
              child: Text(
                "This filter will show ${discoveryProvider.filteredEventOccurencesLength.toString()} results",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 20),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StandardButton(
                  width: MediaQuery.of(context).size.width * 0.4,
                  text: "Reset",
                  onPressed: () {
                    discoveryProvider.resetFilter();

                    Navigator.of(context).pop();
                  },
                ),
                StandardButton(
                  width: MediaQuery.of(context).size.width * 0.4,
                  text: "Continue",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  isFilled: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
