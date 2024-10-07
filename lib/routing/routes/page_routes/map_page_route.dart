import 'package:acroworld/presentation/screens/map_page/map_page.dart';
import 'package:acroworld/routing/routes/base_route.dart';

class MapPageRoute extends BaseRoute {
  MapPageRoute()
      : super(
          const MapPage(),
          guards: [],
        );
}
