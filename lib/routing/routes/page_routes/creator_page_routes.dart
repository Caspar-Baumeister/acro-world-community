import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/dashboard_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/invites_page.dart';
import 'package:acroworld/routing/routes/base_route.dart';

class InvitesPageRoute extends BaseRoute {
  InvitesPageRoute()
      : super(
          const InvitesPage(),
          guards: [],
        );
}

class DashboardPageRoute extends BaseRoute {
  DashboardPageRoute()
      : super(
          const DashboardPage(),
          guards: [],
        );
}
