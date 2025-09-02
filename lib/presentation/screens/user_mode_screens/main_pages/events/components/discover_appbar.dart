import 'package:acroworld/presentation/components/appbar/base_appbar.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/search_delegate/event_search_delegate.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DiscoveryAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DiscoveryAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryState = ref.watch(discoveryProvider);
    return BaseAppbar(
      // if filter is active, show back button
      title: Row(
        children: [
          // Conditionally display the leading icon
          if (discoveryState.isFilter)
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
                    horizontal: AppDimensions.spacingSmall, vertical: AppDimensions.spacingSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
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
          padding: const EdgeInsets.only(right: AppDimensions.spacingMedium),
          icon: Icon(Icons.filter_list,
              color: discoveryState.isFilter
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline),
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
