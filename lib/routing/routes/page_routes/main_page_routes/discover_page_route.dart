import 'package:acroworld/routing/routes/base_route.dart';
import 'package:acroworld/screens/user_mode_screens/main_pages/events/discover_page.dart';

class DiscoverPageRoute extends BaseRoute {
  DiscoverPageRoute()
      : super(
          const DiscoverPage(),
          guards: [],
        );
}
