import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/class_booking_summary_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_occurence_page/class_occurence_page.dart';
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

// ClassBookingSummaryPage with
class ClassBookingSummaryPageRoute extends BaseRoute {
  ClassBookingSummaryPageRoute({required String classEventId})
      : super(
          ClassBookingSummaryPage(classEventId: classEventId),
          guards: [],
        );
}

//ClassOccurencePage
class ClassOccurencePageRoute extends BaseRoute {
  ClassOccurencePageRoute({required ClassModel classModel})
      : super(
          ClassOccurencePage(classModel: classModel),
          guards: [],
        );
}
