import 'package:acroworld/routing/routes/base_route.dart';
import 'package:acroworld/routing/transitions.dart';
import 'package:acroworld/screens/authentication_screens/confirm_email/confirm_email_page.dart';
import 'package:acroworld/screens/authentication_screens/email_verification_page/email_verification_page.dart';
import 'package:acroworld/screens/create_creator_profile_pages/create_creator_profile_page.dart.dart';
import 'package:acroworld/screens/creator_mode_screens/my_events_page/my_events_page.dart';

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

class EmailVerificationPageRoute extends BaseRoute {
  final String? code;

  EmailVerificationPageRoute({this.code})
      : super(
          EmailVerificationPage(code: code),
          guards: [],
        );
}

//MyEventsPage
class MyEventsPageRoute extends BaseRoute {
  MyEventsPageRoute()
      : super(
          const MyEventsPage(),
          guards: [],
        );
}
