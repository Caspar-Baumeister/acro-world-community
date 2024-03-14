import 'package:acroworld/routing/routes/base_route.dart';
import 'package:acroworld/screens/main_pages/discover/filter_page/filter_page.dart';

class FilterPageRoute extends BaseRoute {
  FilterPageRoute()
      : super(
          const FilterPage(),
          guards: [],
        );
}
