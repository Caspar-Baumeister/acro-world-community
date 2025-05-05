import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/bottom_navbar/creator_mode/creator_mode_primary_bottom_navbar.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboad_bookings_statistics.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_booking_view.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/state/provider/creator_bookings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  @override
  void initState() {
    super.initState();
    // initialises the bookings provider with the creator id from the creator provider
    CreatorBookingsProvider creatorBookingsProvider =
        Provider.of<CreatorBookingsProvider>(context, listen: false);
    if (creatorBookingsProvider.confirmedBookings.isEmpty) {
      creatorBookingsProvider.creatorUserId =
          Provider.of<UserProvider>(context, listen: false).activeUser!.id!;
      creatorBookingsProvider.fetchBookings();
      creatorBookingsProvider.getClassEventBookingsAggregate();
    }
  }

  @override
  Widget build(BuildContext context) {
    // get the bookings from the provider
    final creatorBookingsProvider =
        Provider.of<CreatorBookingsProvider>(context);
    return RefreshIndicator(
      onRefresh: () async {
        await creatorBookingsProvider.fetchBookings(isRefresh: true);
        await creatorBookingsProvider.getClassEventBookingsAggregate();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboadBookingsStatistics(
            totalAmountBookings:
                creatorBookingsProvider.confirmedBookings.length,
          ),
          if (creatorBookingsProvider.confirmedBookings.isNotEmpty)
            Expanded(
                child: DashboardBookingView(
                    bookings: creatorBookingsProvider.confirmedBookings))
        ],
      ),
    );
  }
}
