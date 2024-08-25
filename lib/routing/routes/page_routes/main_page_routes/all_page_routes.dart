import 'package:acroworld/routing/routes/base_route.dart';
import 'package:acroworld/routing/transitions.dart';
import 'package:acroworld/screens/authentication_screens/confirm_email/confirm_email_page.dart';
import 'package:acroworld/screens/create_creator_profile_pages/create_creator_profile_page.dart.dart';

class CreateCreatorProfilePageRoute extends BaseRoute {
  CreateCreatorProfilePageRoute()
      : super(const CreateCreatorProfilePage(),
            guards: [], transitionsBuilderFunction: Transitions.slideBottom);
}

class ConfirmEmailPageRoute extends BaseRoute {
  ConfirmEmailPageRoute()
      : super(
          const ConfirmEmailPage(),
          guards: [],
        );
}
