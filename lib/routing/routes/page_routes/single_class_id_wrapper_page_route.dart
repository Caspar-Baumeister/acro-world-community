import 'package:acroworld/routing/routes/base_route.dart';
import 'package:acroworld/screens/single_class_page/single_class_query_wrapper.dart';

class SingleEventIdWrapperPageRoute extends BaseRoute<void> {
  SingleEventIdWrapperPageRoute({required String urlSlug, String? classEventId})
      : super(
          SingleEventQueryWrapper(urlSlug: urlSlug, classEventId: classEventId),
          guards: [],
        );
}
