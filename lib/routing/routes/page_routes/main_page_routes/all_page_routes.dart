import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/edit_class_description.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/question_page.dart/question_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/my_events_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/stripe_pages/stripe_callback_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/user_answer_page/user_answer_page.dart';
import 'package:acroworld/routing/routes/base_route.dart';

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
