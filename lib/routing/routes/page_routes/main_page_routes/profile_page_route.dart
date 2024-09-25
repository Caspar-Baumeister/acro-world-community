import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/profile_page.dart';
import 'package:acroworld/routing/routes/base_route.dart';

class ProfilePageRoute extends BaseRoute {
  ProfilePageRoute()
      : super(
          const ProfilePage(),
          guards: [],
        );
}
