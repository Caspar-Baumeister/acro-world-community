import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboad_bookings_statistics.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_booking_view.dart';
import 'package:acroworld/provider/riverpod_provider/creator_bookings_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BasePage(
        appBar: const CustomAppbarSimple(
          title: "Bookings",
          isBackButton: false,
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
          DashboadBookingsStatistics(
              totalAmountBookings: creatorBookingsState.totalBookings),
          if (creatorBookingsState.confirmedBookings.isNotEmpty)
            Expanded(
                child: DashboardBookingView(
                    bookings: creatorBookingsState.confirmedBookings))
        ],
      ),
    );
  }
}
