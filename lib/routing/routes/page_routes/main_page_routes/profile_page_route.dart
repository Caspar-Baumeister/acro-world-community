import 'package:acroworld/routing/routes/base_route.dart';
import 'package:acroworld/screens/user_mode_screens/main_pages/profile/profile_page.dart';

class ProfilePageRoute extends BaseRoute {
  ProfilePageRoute()
      : super(
          const ProfilePage(),
          guards: [],
        );
}
