import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/cards/modern_booking_card.dart';
import 'package:acroworld/presentation/components/sections/bookings_search_and_filter.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/provider/riverpod_provider/creator_bookings_provider.dart';
import 'package:acroworld/provider/riverpod_provider/pending_invites_badge_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BasePage(
        appBar: CustomAppbarSimple(
          title: "Bookings",
          isBackButton: false,
          actions: [
            Builder(builder: (context) {
              final count = ref.watch(pendingInvitesBadgeProvider);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded),
                    onPressed: () {
                      context.goNamed(invitesRoute);
                    },
                  ),
                  if (count != null && count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          count.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onError,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                ],
              );
            })
          ],
        ),
        makeScrollable: false,
        child: DashboardBody());
  }
}

class DashboardBody extends ConsumerStatefulWidget {
  const DashboardBody({super.key});
  @override
  ConsumerState<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends ConsumerState<DashboardBody> {
  @override
  void initState() {
    super.initState();
    // Initialize the bookings provider with the creator id after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final creatorBookingsNotifier =
          ref.read(creatorBookingsProvider.notifier);
      final userId = ref.read(userRiverpodProvider).value?.id;

      if (userId != null) {
        creatorBookingsNotifier.setCreatorUserId(userId);
        creatorBookingsNotifier.fetchBookings();
        creatorBookingsNotifier.getClassEventBookingsAggregate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final creatorBookingsState = ref.watch(creatorBookingsProvider);
    final creatorBookingsNotifier = ref.read(creatorBookingsProvider.notifier);

    return RefreshIndicator(
      onRefresh: () async {
        await creatorBookingsNotifier.fetchBookings(isRefresh: true);
        await creatorBookingsNotifier.getClassEventBookingsAggregate();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics card

          // Search and filter section
          BookingsSearchAndFilter(
            searchQuery: creatorBookingsState.searchQuery,
            selectedStatus: creatorBookingsState.selectedStatus,
            onSearchChanged: (query) =>
                creatorBookingsNotifier.updateSearchQuery(query),
            onStatusChanged: (status) =>
                creatorBookingsNotifier.updateSelectedStatus(status),
            onSearchSubmitted: (query) =>
                creatorBookingsNotifier.updateSearchQuery(query),
          ),

          // Bookings list
          if (creatorBookingsState.filteredBookings.isNotEmpty)
            Expanded(
              child: _buildBookingsList(
                  creatorBookingsState, creatorBookingsNotifier),
            )
          else if (!creatorBookingsState.loading)
            Expanded(
              child: _buildEmptyState(context),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(
      CreatorBookingsState state, CreatorBookingsNotifier notifier) {
    return ListView.builder(
      itemCount: state.filteredBookings.length + (state.canFetchMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.filteredBookings.length) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ElevatedButton(
                onPressed: () => notifier.fetchMore(),
                child: const Text("Load more"),
              ),
            ),
          );
        }

        final booking = state.filteredBookings[index];
        return ModernBookingCard(booking: booking);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            "No bookings found",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your search or filters",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
