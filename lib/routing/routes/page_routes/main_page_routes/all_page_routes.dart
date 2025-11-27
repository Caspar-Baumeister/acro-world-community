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
