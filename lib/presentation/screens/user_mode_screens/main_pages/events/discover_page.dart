import 'package:acroworld/presentation/components/buttons/floating_action_button.dart';
import 'package:acroworld/presentation/components/loading/modern_loading_widget.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/discover_appbar.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/discover_dashboard_body.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/filter_on_discover_body.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Stack(
      children: [
        const BasePage(
          appBar: DiscoveryAppBar(),
          makeScrollable: false,
          child: DiscoverBody(),
        ),
        // Floating Insert Event Button
        CustomFloatingActionButton(
          title: "Insert Event",
          subtitle: "Add your class or workshop",
          onPressed: () => context.goNamed(profileRoute),
          backgroundColor: colorScheme.tertiary,
          textColor: Colors.white,
        ),
      ],
    );
  }
}

class DiscoverBody extends ConsumerWidget {
  const DiscoverBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryState = ref.watch(discoveryProvider);
    if (discoveryState.loading) {
      return const ModernLoadingWidget();
    } else if (discoveryState.isFilter) {
      return const FilterOnDiscoveryBody();
    } else {
      return const DiscoverDashboardBody();
    }
  }
}
