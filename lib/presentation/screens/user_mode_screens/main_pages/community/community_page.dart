import 'package:acroworld/presentation/components/filters/modern_filter_chip.dart';
import 'package:acroworld/presentation/components/search/modern_search_bar.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/community_query.dart';
import 'package:acroworld/provider/riverpod_provider/community_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherPage extends ConsumerWidget {
  const TeacherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(communitySearchProvider);
    final filter = ref.watch(communityFilterProvider);
    final isFollowed = ref.watch(communityFilterProvider.notifier).isFollowed;

    return BasePage(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: ModernSearchBar(
          onSearchChanged: (value) {
            ref.read(communitySearchProvider.notifier).updateSearch(value);
          },
          hintText: 'Search community...',
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.spacingSmall),
          ModernFilterRow(
            filters: CommunityFilters.options,
            selectedFilter: filter,
            onFilterChanged: (value) {
              ref.read(communityFilterProvider.notifier).updateFilter(value);
            },
          ),
          const SizedBox(height: AppDimensions.spacingSmall),
          Expanded(
            child: TeacherQuery(
              search: search,
              isFollowed: isFollowed,
            ),
          ),
        ],
      ),
    );
  }
}
