import 'package:acroworld/routing/routes/base_route.dart';
import 'package:acroworld/screens/user_mode_screens/main_pages/activities/activities_page.dart';

class CalendarPageRoute extends BaseRoute {
  CalendarPageRoute()
      : super(
          const ActivitiesPage(),
          guards: [],
        );
}
