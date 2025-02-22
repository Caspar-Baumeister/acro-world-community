import 'package:acroworld/presentation/screens/authentication_screens/confirm_email/confirm_email_page.dart';
import 'package:acroworld/presentation/screens/authentication_screens/email_verification_page/email_verification_page.dart';
import 'package:acroworld/presentation/screens/create_creator_profile_pages/create_creator_profile_page.dart.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/edit_class_description.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/create_and_edit_event_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/question_page.dart/question_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/my_events_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/stripe_pages/stripe_callback_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/user_answer_page/user_answer_page.dart';
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

class StripeCallbackPageRoute extends BaseRoute {
  final String? stripeId;

  StripeCallbackPageRoute({this.stripeId})
      : super(
          StripeCallbackPage(stripeId: stripeId),
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
  CreateAndEditEventPageRoute({required bool isEditing})
      : super(
          CreateAndEditEventPage(isEditing: isEditing),
          guards: [],
        );
}

//QuestionPage
class QuestionPageRoute extends BaseRoute {
  QuestionPageRoute()
      : super(
          const QuestionPage(),
          guards: [],
        );
}

// EditDescriptionPageRoute
class EditDescriptionPageRoute extends BaseRoute {
  final String initialText;
  final Function(String) onTextUpdated;

  EditDescriptionPageRoute(
      {required this.initialText, required this.onTextUpdated})
      : super(
          EditClassDescriptionPage(
            initialText: initialText,
            onTextUpdated: onTextUpdated,
          ),
          guards: [],
        );
}

//UserAnswerPage
class UserAnswerPageRoute extends BaseRoute {
  final String userId;
  final String classEventId;

  UserAnswerPageRoute({required this.userId, required this.classEventId})
      : super(
          UserAnswerPage(userId: userId, classEventId: classEventId),
          guards: [],
        );
}
