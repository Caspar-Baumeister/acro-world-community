import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/filter_page/filter_page.dart';
import 'package:acroworld/routing/routes/base_route.dart';

class FilterPageRoute extends BaseRoute {
  FilterPageRoute()
      : super(
          const FilterPage(),
          guards: [],
        );
}
