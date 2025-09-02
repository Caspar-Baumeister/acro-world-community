import 'package:acroworld/presentation/components/loading_widget.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/discover_appbar.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/discover_dashboard_body.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/filter_on_discover_body.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class DiscoverBody extends ConsumerWidget {
  const DiscoverBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryState = ref.watch(discoveryProvider);
    if (discoveryState.loading) {
      return Center(child: const LoadingWidget());
    } else if (discoveryState.isFilter) {
      return const FilterOnDiscoveryBody();
    } else {
      return const DiscoverDashboardBody();
    }
  }
}
