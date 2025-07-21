import 'package:acroworld/presentation/components/loading_widget.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/discover_appbar.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/discover_dashboard_body.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/filter_on_discover_body.dart';
import 'package:acroworld/provider/discover_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      appBar: DiscoveryAppBar(),
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
      return Center(child: const LoadingWidget());
    } else if (discoveryProvider.isFilter) {
      return const FilterOnDiscoveryBody();
    } else {
      return const DiscoverDashboardBody();
    }
  }
}
