import 'package:acroworld/presentation/components/cards/ticket_card.dart';
import 'package:acroworld/presentation/components/loading/modern_loading_widget.dart';
import 'package:acroworld/presentation/components/sections/tickets_search_and_filter.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/modals/ticket_details_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/provider/riverpod_provider/user_bookings_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TicketsPage extends ConsumerWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BasePage(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "My Tickets",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: false,
        elevation: 0,
      ),
      child: const TicketsBody(),
    );
  }
}

class TicketsBody extends ConsumerStatefulWidget {
  const TicketsBody({super.key});

  @override
  ConsumerState<TicketsBody> createState() => _TicketsBodyState();
}

class _TicketsBodyState extends ConsumerState<TicketsBody> {
  @override
  void initState() {
    super.initState();
    // Fetch bookings when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userBookingsProvider.notifier).fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingsState = ref.watch(userBookingsProvider);
    final bookingsNotifier = ref.read(userBookingsProvider.notifier);

    return RefreshIndicator(
      onRefresh: () async {
        await bookingsNotifier.fetchBookings(isRefresh: true);
      },
      child: _buildContent(context, bookingsState),
    );
  }

  Widget _buildContent(BuildContext context, UserBookingsState state) {
    if (state.loading) {
      return const Center(
        child: ModernLoadingWidget(),
      );
    }

    if (state.error != null) {
      return _buildErrorState(context, state.error!);
    }

    if (state.filteredBookings.isEmpty) {
      return _buildEmptyState(context, state);
    }

    return _buildBookingsList(context, state);
  }

  Widget _buildBookingsList(BuildContext context, UserBookingsState state) {
    final futureBookings = state.futureBookings;
    final pastBookings = state.pastBookings;
    final bookingsNotifier = ref.read(userBookingsProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search and filter section
          TicketsSearchAndFilter(
            searchQuery: state.searchQuery,
            selectedFilter: state.selectedStatus,
            onSearchChanged: (query) =>
                bookingsNotifier.updateSearchQuery(query),
            onFilterChanged: (filter) =>
                bookingsNotifier.updateSelectedStatus(filter),
            onSearchSubmitted: (query) =>
                bookingsNotifier.updateSearchQuery(query),
          ),

          // Future bookings section
          if (futureBookings.isNotEmpty) ...[
            _buildSectionHeader(
                context, "Upcoming Events", futureBookings.length),
            ...futureBookings.map((booking) => TicketCard(
                  booking: booking,
                  onTap: () => _showTicketDetails(context, booking),
                )),
            const SizedBox(height: AppDimensions.spacingLarge),
          ],

          // Past bookings section
          if (pastBookings.isNotEmpty) ...[
            _buildSectionHeader(context, "Past Events", pastBookings.length),
            ...pastBookings.map((booking) => TicketCard(
                  booking: booking,
                  onTap: () => _showTicketDetails(context, booking),
                )),
          ],

          // Bottom padding to prevent content from being hidden behind navbar
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMedium,
        vertical: AppDimensions.spacingSmall,
      ),
      child: Text(
        "$title ($count)",
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showTicketDetails(BuildContext context, UserBookingModel booking) {
    buildMortal(
      context,
      TicketDetailsModal(booking: booking),
    );
  }

  Widget _buildEmptyState(BuildContext context, UserBookingsState state) {
    final bookingsNotifier = ref.read(userBookingsProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Search and filter section
          TicketsSearchAndFilter(
            searchQuery: state.searchQuery,
            selectedFilter: state.selectedStatus,
            onSearchChanged: (query) =>
                bookingsNotifier.updateSearchQuery(query),
            onFilterChanged: (filter) =>
                bookingsNotifier.updateSelectedStatus(filter),
            onSearchSubmitted: (query) =>
                bookingsNotifier.updateSearchQuery(query),
          ),

          // Empty state content
          SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight -
                200, // Account for search/filter and padding
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.bookings.isEmpty
                          ? "No Tickets Yet"
                          : "No Matching Tickets",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.bookings.isEmpty
                          ? "Here you will see all booked events"
                          : "Try adjusting your search or filters",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              "Something went wrong",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(userBookingsProvider.notifier)
                    .fetchBookings(isRefresh: true);
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }
}
