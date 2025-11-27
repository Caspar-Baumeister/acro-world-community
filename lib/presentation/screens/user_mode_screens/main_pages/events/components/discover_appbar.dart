import 'package:acroworld/presentation/components/appbar/base_appbar.dart';
import 'package:acroworld/presentation/components/input/modern_search_bar.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/routing/route_names.dart';
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
      leading: discoveryState.isFilter
          ? IconButton(
              padding: const EdgeInsets.only(left: 0),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () =>
                  ref.read(discoveryProvider.notifier).resetFilter(),
            )
          : null,
      title: ModernSearchBar(
        hintText: 'Search events...',
        readOnly: true,
        onTap: () => context.pushNamed(eventSearchRoute),
        onFilterPressed: () => context.pushNamed(filterRoute),
        isFilterActive: discoveryState.isFilter,
        showFilterButton: true,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
