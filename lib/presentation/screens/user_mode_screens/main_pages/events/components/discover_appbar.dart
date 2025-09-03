import 'package:acroworld/presentation/components/appbar/base_appbar.dart';
import 'package:acroworld/presentation/components/input/modern_search_bar.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return BaseAppbar(
      // if filter is active, show back button
      leading: discoveryState.isFilter
          ? IconButton(
              padding: const EdgeInsets.only(left: 0),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => ref.read(discoveryProvider.notifier).resetFilter(),
            )
          : null,
      title: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Modern search field
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => showSearch(
                      context: context, 
                      delegate: EventSearchDelegate(),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Search events...',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Modern filter button
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: discoveryState.isFilter
                      ? colorScheme.primary
                      : colorScheme.outline.withOpacity(0.2),
                  width: discoveryState.isFilter ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.pushNamed(filterRoute),
                  borderRadius: BorderRadius.circular(12),
                  child: Icon(
                    Icons.tune,
                    color: discoveryState.isFilter
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
