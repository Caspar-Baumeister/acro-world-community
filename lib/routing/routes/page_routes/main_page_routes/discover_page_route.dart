import 'package:acroworld/routing/routes/base_route.dart';
import 'package:acroworld/screens/main_pages/discover/discover_page.dart';

class DiscoverPageRoute extends BaseRoute {
  DiscoverPageRoute()
      : super(
          const DiscoverPage(),
          guards: [],
        );
}
