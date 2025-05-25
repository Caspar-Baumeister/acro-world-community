import 'package:acroworld/presentation/components/appbar/base_appbar.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/search_delegate/event_search_delegate.dart';
import 'package:acroworld/provider/discover_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/decorators.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DiscoveryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DiscoveryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    DiscoveryProvider discoveryProvider =
        Provider.of<DiscoveryProvider>(context);
    return BaseAppbar(
      // if filter is active, show back button
      title: Row(
        children: [
          // Conditionally display the leading icon
          if (discoveryProvider.isFilterActive())
            IconButton(
              padding:
                  const EdgeInsets.only(left: 0), // Adjust this value as needed

              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => discoveryProvider.resetFilter(),
            ),
          Expanded(
            child: InkWell(
              onTap: () =>
                  showSearch(context: context, delegate: EventSearchDelegate()),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppPaddings.small, vertical: AppPaddings.small),
                decoration: searchBarDecoration,
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.black),
                    const SizedBox(width: 10),
                    Text(
                      'Search',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          padding: const EdgeInsets.only(right: AppPaddings.medium),
          icon: Icon(Icons.filter_list,
              color: discoveryProvider.isFilterActive()
                  ? CustomColors.accentColor
                  : CustomColors.inactiveBorderColor),
          onPressed: () {
            context.pushNamed(
              filterRoute,
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
