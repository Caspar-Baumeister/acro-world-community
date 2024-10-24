import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/bottom_navbar/creator_mode/creator_mode_primary_bottom_navbar.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/state/provider/creator_bookings_provider.dart';
import 'package:acroworld/utils/constants.dart';
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
    CreatorBookingsProvider creatorBookingsProvider =
        Provider.of<CreatorBookingsProvider>(context, listen: false);
    if (creatorBookingsProvider.bookings.isEmpty) {
      creatorBookingsProvider.creatorId =
          Provider.of<CreatorProvider>(context, listen: false)
              .activeTeacher!
              .id!;
      creatorBookingsProvider.fetchBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DashboadBookingsStatistics(),
        const SizedBox(height: AppPaddings.medium),
        Expanded(child: DashboardBookingView())
      ],
    );
  }
}

class DashboadBookingsStatistics extends StatelessWidget {
  const DashboadBookingsStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    CreatorBookingsProvider creatorBookingsProvider =
        Provider.of<CreatorBookingsProvider>(context);
    return const Placeholder();
  }
}
