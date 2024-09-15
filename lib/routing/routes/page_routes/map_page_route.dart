import 'package:acroworld/routing/routes/base_route.dart';
import 'package:acroworld/screens/user_mode_screens/map/map_page.dart';

class MapPageRoute extends BaseRoute {
  MapPageRoute()
      : super(
          const MapPage(),
          guards: [],
        );
}
