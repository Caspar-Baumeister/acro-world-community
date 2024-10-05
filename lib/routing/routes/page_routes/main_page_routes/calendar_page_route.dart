import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/activities_page.dart';
import 'package:acroworld/routing/routes/base_route.dart';

class CalendarPageRoute extends BaseRoute {
  CalendarPageRoute()
      : super(
          const ActivitiesPage(),
          guards: [],
        );
}
