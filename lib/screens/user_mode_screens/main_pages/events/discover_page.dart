import 'package:acroworld/components/bottom_navbar/primary_bottom_navbar.dart';
import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/provider/discover_provider.dart';
import 'package:acroworld/screens/base_page.dart';
import 'package:acroworld/screens/user_mode_screens/main_pages/events/components/discover_appbar.dart';
import 'package:acroworld/screens/user_mode_screens/main_pages/events/components/discover_dashboard_body.dart';
import 'package:acroworld/screens/user_mode_screens/main_pages/events/filter_on_discover_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      appBar: DiscoveryAppBar(),
      bottomNavigationBar: PrimaryBottomNavbar(
        selectedIndex: 0,
      ),
      makeScrollable: false,
      child: DiscoverBody(),
    );
  }
}

class DiscoverBody extends StatelessWidget {
  const DiscoverBody({super.key});

  @override
  Widget build(BuildContext context) {
    DiscoveryProvider discoveryProvider =
        Provider.of<DiscoveryProvider>(context);
    if (discoveryProvider.loading) {
      return const LoadingWidget();
    } else if (discoveryProvider.isFilter) {
      return const FilterOnDiscoveryBody();
    } else {
      return const DiscoverDashboardBody();
    }
  }
}
