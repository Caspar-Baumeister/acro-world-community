import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/screens/authentication_screens/confirm_email/confirm_email_page.dart';
import 'package:acroworld/presentation/screens/authentication_screens/email_verification_page/email_verification_page.dart';
import 'package:acroworld/presentation/screens/create_creator_profile_pages/create_creator_profile_page.dart.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/create_and_edit_event_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/my_events_page.dart';
import 'package:acroworld/routing/routes/base_route.dart';
import 'package:acroworld/routing/transitions.dart';

class CreateCreatorProfilePageRoute extends BaseRoute {
  CreateCreatorProfilePageRoute()
      : super(const CreateCreatorProfilePage(),
            guards: [], transitionsBuilderFunction: Transitions.slideBottom);
}

class EditCreatorProfilePageRoute extends BaseRoute {
  EditCreatorProfilePageRoute()
      : super(const CreateCreatorProfilePage(isEditing: true),
            guards: [], transitionsBuilderFunction: Transitions.slideLeft);
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

//CreateAndEditEventPage
class CreateAndEditEventPageRoute extends BaseRoute {
  CreateAndEditEventPageRoute({required bool isEditing, ClassModel? classModel})
      : super(
          CreateAndEditEventPage(isEditing: isEditing, classModel: classModel),
          guards: [],
        );
}