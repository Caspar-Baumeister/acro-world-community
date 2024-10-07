import 'package:acroworld/presentation/screens/main_pages/profile/user_profile_page.dart';
import 'package:acroworld/routing/routes/base_route.dart';

class ProfilePageRoute extends BaseRoute {
  ProfilePageRoute()
      : super(
          const ProfilePage(),
          guards: [],
        );
}
