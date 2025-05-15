import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/bottom_navbar/creator_mode/creator_mode_primary_bottom_navbar.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboad_bookings_statistics.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_booking_view.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/state/provider/creator_bookings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
        appBar: const CustomAppbarSimple(
          title: "Bookings",
          isBackButton: false,
        ),
        makeScrollable: false,
        bottomNavigationBar:
            const CreatorModePrimaryBottomNavbar(selectedIndex: 0),
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
    // initialises the bookings provider with the creator id from the creator provider
    CreatorBookingsProvider creatorBookingsProvider =
        provider.Provider.of<CreatorBookingsProvider>(context, listen: false);
    if (creatorBookingsProvider.confirmedBookings.isEmpty) {
      // creatorBookingsProvider.creatorUserId =
      //     provider.Provider.of<UserProvider>(context, listen: false).activeUser!.id!;
      final userId = ref.read(userRiverpodProvider).value?.id;
      if (userId != null) {
        creatorBookingsProvider.creatorUserId = userId;
        creatorBookingsProvider.fetchBookings();
        creatorBookingsProvider.getClassEventBookingsAggregate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // get the bookings from the provider
    final creatorBookingsProvider =
        provider.Provider.of<CreatorBookingsProvider>(context);
    return RefreshIndicator(
      onRefresh: () async {
        await creatorBookingsProvider.fetchBookings(isRefresh: true);
        await creatorBookingsProvider.getClassEventBookingsAggregate();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboadBookingsStatistics(
              totalAmountBookings: creatorBookingsProvider.totalBookings),
          if (creatorBookingsProvider.confirmedBookings.isNotEmpty)
            Expanded(
                child: DashboardBookingView(
                    bookings: creatorBookingsProvider.confirmedBookings))
        ],
      ),
    );
  }
}
