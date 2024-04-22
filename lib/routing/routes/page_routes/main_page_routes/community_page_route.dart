import 'package:acroworld/routing/routes/base_route.dart';
import 'package:acroworld/screens/main_pages/community/community_page.dart';

class CommunityPageRoute extends BaseRoute {
  CommunityPageRoute()
      : super(
          const TeacherPage(),
          guards: [],
        );
}
